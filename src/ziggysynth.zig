const std = @import("std");
const mem = std.mem;
const Allocator = mem.Allocator;

const ZiggySynthError = error {
    InvalidSoundFont,
    Unknown,
};

const BinaryReader = struct
{
    fn read(comptime T: type, reader: anytype) !T
    {
        var data: [@sizeOf(T)]u8 = undefined;
        _ = try reader.readNoEof(&data);
        return @bitCast(T, data);
    }
};

pub const SoundFont = struct
{
    const Self = @This();

    allocator: Allocator,
    wave_data: []i16,
    sample_headers: []SampleHeader,
    instrument_regions: []InstrumentRegion,

    pub fn init(allocator: Allocator, reader: anytype) !Self
    {
        var wave_data: ?[]i16 = null;
        var sample_headers: ?[]SampleHeader = null;
        var instrument_regions: ?[]InstrumentRegion = null;

        errdefer
        {
            if (wave_data) |value| allocator.free(value);
            if (sample_headers) |value| allocator.free(value);
            if (instrument_regions) |value| allocator.free(value);
        }

        const chunk_id = try BinaryReader.read([4]u8, reader);
        if (!mem.eql(u8, &chunk_id, "RIFF"))
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        _ = try BinaryReader.read(u32, reader);

        const form_type = try BinaryReader.read([4]u8, reader);
        if (!mem.eql(u8, &form_type, "sfbk"))
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        try SoundFont.skipInfo(reader);

        const sampleData = try SoundFontSampleData.init(allocator, reader);
        wave_data = sampleData.wave_data;

        const parameters = try SoundFontParameters.init(allocator, reader);
        sample_headers = parameters.sample_headers;
        instrument_regions = parameters.instrument_regions;

        return Self
        {
            .allocator = allocator,
            .wave_data = wave_data.?,
            .sample_headers = sample_headers.?,
            .instrument_regions = instrument_regions.?,
        };
    }

    pub fn deinit(self: Self) void
    {
        self.allocator.free(self.wave_data);
        self.allocator.free(self.sample_headers);
        self.allocator.free(self.instrument_regions);
    }

    fn skipInfo(reader: anytype) !void
    {
        const chunk_id = try BinaryReader.read([4]u8, reader);
        if (!mem.eql(u8, &chunk_id, "LIST"))
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const size = try BinaryReader.read(u32, reader);
        try reader.skipBytes(size, .{});
    }
};

const SoundFontSampleData = struct
{
    const Self = @This();

    bits_per_sample: i32,
    wave_data: []i16,

    fn init(allocator: Allocator, reader: anytype) !Self
    {
        var wave_data: ?[]i16 = null;

        errdefer
        {
            if (wave_data) |value| allocator.free(value);
        }

        const chunk_id = try BinaryReader.read([4]u8, reader);
        if (!mem.eql(u8, &chunk_id, "LIST"))
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const end = try BinaryReader.read(u32, reader);

        var pos: u32 = 0;

        const list_type = try BinaryReader.read([4]u8, reader);
        if (!mem.eql(u8, &list_type, "sdta"))
        {
            return ZiggySynthError.InvalidSoundFont;
        }
        pos += 4;

        while (pos < end)
        {
            const id = try BinaryReader.read([4]u8, reader);
            pos += 4;

            const size = try BinaryReader.read(u32, reader);
            pos += 4;

            if (mem.eql(u8, &id, "smpl"))
            {
                wave_data = try allocator.alloc(i16, size / 2);
                try reader.readNoEof(@ptrCast([*]u8, wave_data.?.ptr)[0..size]);
            }
            else if (mem.eql(u8, &id, "sm24"))
            {
                try reader.skipBytes(size, .{});
            }
            else
            {
                return ZiggySynthError.InvalidSoundFont;
            }

            pos += size;
        }

        _ = wave_data orelse return ZiggySynthError.InvalidSoundFont;

        return Self
        {
            .bits_per_sample = 16,
            .wave_data = wave_data.?,
        };
    }
};

const SoundFontParameters = struct
{
    const Self = @This();

    sample_headers: []SampleHeader,
    instrument_regions: []InstrumentRegion,

    fn init(allocator: Allocator, reader: anytype) !Self
    {
        var preset_infos: ?[]PresetInfo = null;
        var preset_bag: ?[]ZoneInfo = null;
        var preset_generators: ?[]Generator = null;
        var instrument_infos: ?[]InstrumentInfo = null;
        var instrument_bag: ?[]ZoneInfo = null;
        var instrument_generators: ?[]Generator = null;
        var sample_headers: ?[]SampleHeader = null;

        defer
        {
            if (preset_infos) |value| allocator.free(value);
            if (preset_bag) |value| allocator.free(value);
            if (preset_generators) |value| allocator.free(value);
            if (instrument_infos) |value| allocator.free(value);
            if (instrument_bag) |value| allocator.free(value);
            if (instrument_generators) |value| allocator.free(value);
        }

        errdefer
        {
            if (sample_headers) |value| allocator.free(value);
        }

        const chunk_id = try BinaryReader.read([4]u8, reader);
        if (!mem.eql(u8, &chunk_id, "LIST"))
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const end = try BinaryReader.read(u32, reader);

        var pos: u32 = 0;

        const list_type = try BinaryReader.read([4]u8, reader);
        if (!mem.eql(u8, &list_type, "pdta"))
        {
            return ZiggySynthError.InvalidSoundFont;
        }
        pos += 4;

        while (pos < end)
        {
            const id = try BinaryReader.read([4]u8, reader);
            pos += 4;

            const size = try BinaryReader.read(u32, reader);
            pos += 4;

            if (mem.eql(u8, &id, "phdr"))
            {
                preset_infos = try PresetInfo.read_from_chunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "pbag"))
            {
                preset_bag = try ZoneInfo.read_from_chunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "pmod"))
            {
                try reader.skipBytes(size, .{});
            }
            else if (mem.eql(u8, &id, "pgen"))
            {
                preset_generators = try Generator.read_from_chunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "inst"))
            {
                instrument_infos = try InstrumentInfo.read_from_chunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "ibag"))
            {
                instrument_bag = try ZoneInfo.read_from_chunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "imod"))
            {
                try reader.skipBytes(size, .{});
            }
            else if (mem.eql(u8, &id, "igen"))
            {
                instrument_generators = try Generator.read_from_chunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "shdr"))
            {
                sample_headers = try SampleHeader.read_from_chunk(allocator, reader, size);
            }
            else
            {
                return ZiggySynthError.InvalidSoundFont;
            }

            pos += size;
        }

        _ = preset_infos orelse return ZiggySynthError.InvalidSoundFont;
        _ = preset_bag orelse return ZiggySynthError.InvalidSoundFont;
        _ = preset_generators orelse return ZiggySynthError.InvalidSoundFont;
        _ = instrument_infos orelse return ZiggySynthError.InvalidSoundFont;
        _ = instrument_bag orelse return ZiggySynthError.InvalidSoundFont;
        _ = instrument_generators orelse return ZiggySynthError.InvalidSoundFont;
        _ = sample_headers orelse return ZiggySynthError.InvalidSoundFont;

        const instrument_zones = try Zone.create(allocator, instrument_bag.?, instrument_generators.?);
        defer allocator.free(instrument_zones);

        const instrument_regions = try InstrumentRegion.create(allocator, instrument_infos.?, instrument_zones, sample_headers.?);
        errdefer allocator.free(instrument_regions);

        return Self
        {
            .sample_headers = sample_headers.?,
            .instrument_regions = instrument_regions,
        };
    }
};

const Generator = struct
{
    const Self = @This();

    generator_type: u16,
    value: i16,

    fn init(reader: anytype) !Self
    {
        const generator_type = try BinaryReader.read(u16, reader);
        const value = try BinaryReader.read(i16, reader);

        return Self
        {
            .generator_type = generator_type,
            .value = value,
        };
    }

    fn read_from_chunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 4 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 4 - 1;

        var generators = try allocator.alloc(Self, count);
        errdefer allocator.free(generators);

        var i: usize = 0;
        while (i < count) : (i += 1)
        {
            generators[i] = try Generator.init(reader);
        }

        // The last one is the terminator.
        _ = try Generator.init(reader);

        return generators;
    }
};

const GeneratorType = struct
{
    const START_ADDRESS_OFFSET: u16 = 0;
    const END_ADDRESS_OFFSET: u16 = 1;
    const START_LOOP_ADDRESS_OFFSET: u16 = 2;
    const END_LOOP_ADDRESS_OFFSET: u16 = 3;
    const START_ADDRESS_COARSE_OFFSET: u16 = 4;
    const MODULATION_LFO_TO_PITCH: u16 = 5;
    const VIBRATO_LFO_TO_PITCH: u16 = 6;
    const MODULATION_ENVELOPE_TO_PITCH: u16 = 7;
    const INITIAL_FILTER_CUTOFF_FREQUENCY: u16 = 8;
    const INITIAL_FILTER_Q: u16 = 9;
    const MODULATION_LFO_TO_FILTER_CUTOFF_FREQUENCY: u16 = 10;
    const MODULATION_ENVELOPE_TO_FILTER_CUTOFF_FREQUENCY: u16 = 11;
    const END_ADDRESS_COARSE_OFFSET: u16 = 12;
    const MODULATION_LFO_TO_VOLUME: u16 = 13;
    const UNUSED_1: u16 = 14;
    const CHORUS_EFFECTS_SEND: u16 = 15;
    const REVERB_EFFECTS_SEND: u16 = 16;
    const PAN: u16 = 17;
    const UNUSED_2: u16 = 18;
    const UNUSED_3: u16 = 19;
    const UNUSED_4: u16 = 20;
    const DELAY_MODULATION_LFO: u16 = 21;
    const FREQUENCY_MODULATION_LFO: u16 = 22;
    const DELAY_VIBRATO_LFO: u16 = 23;
    const FREQUENCY_VIBRATO_LFO: u16 = 24;
    const DELAY_MODULATION_ENVELOPE: u16 = 25;
    const ATTACK_MODULATION_ENVELOPE: u16 = 26;
    const HOLD_MODULATION_ENVELOPE: u16 = 27;
    const DECAY_MODULATION_ENVELOPE: u16 = 28;
    const SUSTAIN_MODULATION_ENVELOPE: u16 = 29;
    const RELEASE_MODULATION_ENVELOPE: u16 = 30;
    const KEY_NUMBER_TO_MODULATION_ENVELOPE_HOLD: u16 = 31;
    const KEY_NUMBER_TO_MODULATION_ENVELOPE_DECAY: u16 = 32;
    const DELAY_VOLUME_ENVELOPE: u16 = 33;
    const ATTACK_VOLUME_ENVELOPE: u16 = 34;
    const HOLD_VOLUME_ENVELOPE: u16 = 35;
    const DECAY_VOLUME_ENVELOPE: u16 = 36;
    const SUSTAIN_VOLUME_ENVELOPE: u16 = 37;
    const RELEASE_VOLUME_ENVELOPE: u16 = 38;
    const KEY_NUMBER_TO_VOLUME_ENVELOPE_HOLD: u16 = 39;
    const KEY_NUMBER_TO_VOLUME_ENVELOPE_DECAY: u16 = 40;
    const INSTRUMENT: u16 = 41;
    const RESERVED_1: u16 = 42;
    const KEY_RANGE: u16 = 43;
    const VELOCITY_RANGE: u16 = 44;
    const START_LOOP_ADDRESS_COARSE_OFFSET: u16 = 45;
    const KEY_NUMBER: u16 = 46;
    const VELOCITY: u16 = 47;
    const INITIAL_ATTENUATION: u16 = 48;
    const RESERVED_2: u16 = 49;
    const END_LOOP_ADDRESS_COARSE_OFFSET: u16 = 50;
    const COARSE_TUNE: u16 = 51;
    const FINE_TUNE: u16 = 52;
    const SAMPLE_ID: u16 = 53;
    const SAMPLE_MODES: u16 = 54;
    const RESERVED_3: u16 = 55;
    const SCALE_TUNING: u16 = 56;
    const EXCLUSIVE_CLASS: u16 = 57;
    const OVERRIDING_ROOT_KEY: u16 = 58;
    const UNUSED_5: u16 = 59;
    const UNUSED_END: u16 = 60;

    const COUNT: usize = 61;
};

const Zone = struct
{
    const Self = @This();

    const empty_generators: [0]Generator = .{};

    generators: []Generator,

    fn empty() Self
    {
        return Self
        {
            .generators = &empty_generators,
        };
    }

    fn init(info: *ZoneInfo, generators: []Generator) Self
    {
        const start = info.generator_index;
        const end = start + info.generator_count;
        var segment = generators[start..end];

        return Self
        {
            .generators = segment,
        };
    }

    fn create(allocator: Allocator, infos: []ZoneInfo, generators: []Generator) ![]Self
    {
        if (infos.len <= 1)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        // The last one is the terminator.
        const count = infos.len - 1;

        var zones = try allocator.alloc(Self, count);
        errdefer allocator.free(zones);
        
        var i: usize = 0;
        while (i < count) : (i += 1)
        {
            zones[i] = Zone.init(&infos[i], generators);
        }

        return zones;
    }
};

const ZoneInfo = struct
{
    const Self = @This();

    generator_index: usize,
    modulator_index: usize,
    generator_count: usize,
    modulator_count: usize,

    fn init(reader: anytype) !Self
    {
        const generator_index = try BinaryReader.read(u16, reader);
        const modulator_index = try BinaryReader.read(u16, reader);

        return Self
        {
            .generator_index = generator_index,
            .modulator_index = modulator_index,
            .generator_count = 0,
            .modulator_count = 0,
        };
    }

    fn read_from_chunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 4 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 4;

        var zones = try allocator.alloc(Self, count);
        errdefer allocator.free(zones);

        {
            var i: usize = 0;
            while (i < count) : (i += 1)
            {
                zones[i] = try ZoneInfo.init(reader);
            }
        }

        {
            var i: usize = 0;
            while (i < count - 1) : (i += 1)
            {
                zones[i].generator_count = zones[i + 1].generator_index - zones[i].generator_index;
                zones[i].modulator_count = zones[i + 1].modulator_index - zones[i].modulator_index;
            }
        }

        return zones;
    }
};

const Preset = struct
{
    const Self = @This();
};

const PresetRegion = struct
{
    const Self = @This();
};

const PresetInfo = struct
{
    const Self = @This();

    name: [20]u8,
    patch_number: i32,
    bank_number: i32,
    zone_start_index: usize,
    zone_end_index: usize,
    library: i32,
    genre: i32,
    morphology: i32,

    fn init(reader: anytype) !Self
    {
        const name = try BinaryReader.read([20]u8, reader);
        const patch_number = try BinaryReader.read(u16, reader);
        const bank_number = try BinaryReader.read(u16, reader);
        const zone_start_index = try BinaryReader.read(u16, reader);
        const library = try BinaryReader.read(i32, reader);
        const genre = try BinaryReader.read(i32, reader);
        const morphology = try BinaryReader.read(i32, reader);

        return Self
        {
            .name = name,
            .patch_number = patch_number,
            .bank_number = bank_number,
            .zone_start_index = zone_start_index,
            .zone_end_index = 0,
            .library = library,
            .genre = genre,
            .morphology = morphology,
        };
    }

    fn read_from_chunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 38 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 38;

        var presets = try allocator.alloc(Self, count);
        errdefer allocator.free(presets);

        {
            var i: usize = 0;
            while (i < count) : (i += 1)
            {
                presets[i] = try PresetInfo.init(reader);
            }
        }

        {
            var i: usize = 0;
            while (i < count - 1) : (i += 1)
            {
                presets[i].zone_end_index = presets[i + 1].zone_start_index - 1;
            }
        }

        return presets;
    }
};

const Instrument = struct
{
    const Self = @This();
};

const InstrumentRegion = struct
{
    const Self = @This();

    sample: *SampleHeader,
    gs: [GeneratorType.COUNT]i16,

    fn contains_global_zone(zones: []Zone) bool
    {
        if (zones[0].generators.len == 0)
        {
            return true;
        }

        if (zones[0].generators[zones[0].generators.len - 1].generator_type != GeneratorType.SAMPLE_ID)
        {
            return true;
        }

        return false;
    }

    fn count_regions(instruments: []InstrumentInfo, all_zones: []Zone) usize
    {
        var sum: usize = 0;

        // The last one is the terminator.
        var instrument_index: usize = 0;
        while (instrument_index < instruments.len - 1) : (instrument_index += 1)
        {
            const info = instruments[instrument_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            // Is the first one the global zone?
            if (InstrumentRegion.contains_global_zone(zones))
            {
                // The first one is the global zone.
                sum += zones.len - 1;
            }
            else
            {
                // No global zone.
                sum += zones.len;
            }
        }

        return sum;
    }

    fn set_parameter(gs: *[GeneratorType.COUNT]i16, generator: *const Generator) void
    {
        const index = generator.generator_type;

        // Unknown generators should be ignored.
        if (index < gs.len)
        {
            gs[index] = generator.value;
        }
    }

    fn init(global: *const Zone, local: *const Zone, samples: []SampleHeader) !Self
    {
        var gs = mem.zeroes([GeneratorType.COUNT]i16);
        gs[GeneratorType.INITIAL_FILTER_CUTOFF_FREQUENCY] = 13500;
        gs[GeneratorType.DELAY_MODULATION_LFO] = -12000;
        gs[GeneratorType.DELAY_VIBRATO_LFO] = -12000;
        gs[GeneratorType.DELAY_MODULATION_ENVELOPE] = -12000;
        gs[GeneratorType.ATTACK_MODULATION_ENVELOPE] = -12000;
        gs[GeneratorType.HOLD_MODULATION_ENVELOPE] = -12000;
        gs[GeneratorType.DECAY_MODULATION_ENVELOPE] = -12000;
        gs[GeneratorType.RELEASE_MODULATION_ENVELOPE] = -12000;
        gs[GeneratorType.DELAY_VOLUME_ENVELOPE] = -12000;
        gs[GeneratorType.ATTACK_VOLUME_ENVELOPE] = -12000;
        gs[GeneratorType.HOLD_VOLUME_ENVELOPE] = -12000;
        gs[GeneratorType.DECAY_VOLUME_ENVELOPE] = -12000;
        gs[GeneratorType.RELEASE_VOLUME_ENVELOPE] = -12000;
        gs[GeneratorType.KEY_RANGE] = 0x7F00;
        gs[GeneratorType.VELOCITY_RANGE] = 0x7F00;
        gs[GeneratorType.KEY_NUMBER] = -1;
        gs[GeneratorType.VELOCITY] = -1;
        gs[GeneratorType.SCALE_TUNING] = 100;
        gs[GeneratorType.OVERRIDING_ROOT_KEY] = -1;

        for (global.generators) |value|
        {
            set_parameter(&gs, &value);
        }

        for (local.generators) |value|
        {
            set_parameter(&gs, &value);
        }

        const id = @intCast(usize, gs[GeneratorType.SAMPLE_ID]);
        if (id >= samples.len)
        {
            return ZiggySynthError.InvalidSoundFont;
        }
        const sample = &samples[id];

        return Self
        {
            .sample = sample,
            .gs = gs,
        };
    }

    fn create(allocator: Allocator, instruments: []InstrumentInfo, all_zones: []Zone, samples: []SampleHeader) ![]Self
    {
        var regions = try allocator.alloc(Self, InstrumentRegion.count_regions(instruments, all_zones));
        errdefer allocator.free(regions);
        var region_index: usize = 0;

        // The last one is the terminator.
        var instrument_index: usize = 0;
        while (instrument_index < instruments.len - 1) : (instrument_index += 1)
        {
            const info = instruments[instrument_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            // Is the first one the global zone?
            if (InstrumentRegion.contains_global_zone(zones))
            {
                // The first one is the global zone.
                var i: usize = 0;
                while (i < zones.len - 1) : (i += 1)
                {
                    regions[region_index] = try InstrumentRegion.init(&zones[0], &zones[i + 1], samples);
                    region_index += 1;
                }
            }
            else
            {
                // No global zone.
                var i: usize = 0;
                while (i < zones.len) : (i += 1)
                {
                    regions[region_index] = try InstrumentRegion.init(&Zone.empty(), &zones[i], samples);
                    region_index += 1;
                }
            }
        }

        if (region_index != regions.len)
        {
            return ZiggySynthError.Unknown;
        }

        return regions;
    }
};

const InstrumentInfo = struct
{
    const Self = @This();

    name: [20]u8,
    zone_start_index: usize,
    zone_end_index: usize,

    fn init(reader: anytype) !Self
    {
        const name = try BinaryReader.read([20]u8, reader);
        const zone_start_index = try BinaryReader.read(u16, reader);

        return Self
        {
            .name = name,
            .zone_start_index = zone_start_index,
            .zone_end_index = 0,
        };
    }

    fn read_from_chunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 22 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 22;

        var instruments = try allocator.alloc(Self, count);
        errdefer allocator.free(instruments);

        {
            var i: usize = 0;
            while (i < count) : (i += 1)
            {
                instruments[i] = try InstrumentInfo.init(reader);
            }
        }

        {
            var i: usize = 0;
            while (i < count - 1) : (i += 1)
            {
                instruments[i].zone_end_index = instruments[i + 1].zone_start_index;
            }
        }

        return instruments;
    }
};

pub const SampleHeader = struct
{
    const Self = @This();

    name: [20]u8,
    start: i32,
    end: i32,
    start_loop: i32,
    end_loop: i32,
    sample_rate: i32,
    original_pitch: u8,
    pitch_correction: i8,
    link: u16,
    sample_type: u16,

    fn init(reader: anytype) !Self
    {
        const name = try BinaryReader.read([20]u8, reader);
        const start = try BinaryReader.read(i32, reader);
        const end = try BinaryReader.read(i32, reader);
        const start_loop = try BinaryReader.read(i32, reader);
        const end_loop = try BinaryReader.read(i32, reader);
        const sample_rate = try BinaryReader.read(i32, reader);
        const original_pitch = try BinaryReader.read(u8, reader);
        const pitch_correction = try BinaryReader.read(i8, reader);
        const link = try BinaryReader.read(u16, reader);
        const sample_type = try BinaryReader.read(u16, reader);

        return Self
        {
            .name = name,
            .start = start,
            .end = end,
            .start_loop = start_loop,
            .end_loop = end_loop,
            .sample_rate = sample_rate,
            .original_pitch = original_pitch,
            .pitch_correction = pitch_correction,
            .link = link,
            .sample_type = sample_type,
        };
    }

    fn read_from_chunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 46 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 46 - 1;

        var headers = try allocator.alloc(Self, count);
        errdefer allocator.free(headers);

        var i: usize = 0;
        while (i < count) : (i += 1)
        {
            headers[i] = try SampleHeader.init(reader);
        }

        // The last one is the terminator.
        _ = try SampleHeader.init(reader);

        return headers;
    }
};

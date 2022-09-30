const std = @import("std");
const math = std.math;
const mem = std.mem;
const Allocator = mem.Allocator;



const ZiggySynthError = error {
    InvalidSoundFont,
    Unexpected,
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



const SoundFontMath = struct
{
    const HALF_PI: f32 = math.pi / 2;
    const NON_AUDIBLE: f32 = 1.0E-3;
    const LOG_NON_AUDIBLE: f32 = @log(1.0E-3);

    fn clamp(value: f32, min: f32, max: f32) f32
    {
        if (value < min)
        {
            return min;
        }
        else if (value > max)
        {
            return max;
        }
        else
        {
            return value;
        }
    }

    fn timecentsToSeconds(x: f32) f32
    {
        return math.pow(f32, 2.0, (1.0 / 1200.0) * x);
    }

    fn centsToHertz(x: f32) f32
    {
        return 8.176 * math.pow(f32, 2.0, (1.0 / 1200.0) * x);
    }

    fn centsToMultiplyingFactor(x: f32) f32
    {
        return math.pow(f32, 2.0, (1.0 / 1200.0) * x);
    }

    fn decibelsToLinear(x: f32) f32
    {
        return math.pow(f32, 10.0, 0.05 * x);
    }

    fn linearToDecibels(x: f32) f32
    {
        return 20.0 * @log10(x);
    }

    fn keyNumberToMultiplyingFactor(cents: i32, key: i32) f32
    {
        return timecentsToSeconds(cents * (60 - key));
    }

    fn expCutoff(x: f64) f64
    {
        if (x < SoundFontMath.LOG_NON_AUDIBLE)
        {
            return 0.0;
        }
        else
        {
            return @exp(x);
        }
    }
};



pub const SoundFont = struct
{
    const Self = @This();

    allocator: Allocator,
    wave_data: []i16,
    sample_headers: []SampleHeader,
    presets: []Preset,
    preset_regions: []PresetRegion,
    instruments: []Instrument,
    instrument_regions: []InstrumentRegion,

    pub fn init(allocator: Allocator, reader: anytype) !Self
    {
        var wave_data: ?[]i16 = null;
        var sample_headers: ?[]SampleHeader = null;
        var presets: ?[]Preset = null;
        var preset_regions: ?[]PresetRegion = null;
        var instruments: ?[]Instrument = null;
        var instrument_regions: ?[]InstrumentRegion = null;

        errdefer
        {
            if (wave_data) |value| allocator.free(value);
            if (sample_headers) |value| allocator.free(value);
            if (presets) |value| allocator.free(value);
            if (preset_regions) |value| allocator.free(value);
            if (instruments) |value| allocator.free(value);
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
        presets = parameters.presets;
        preset_regions = parameters.preset_regions;
        instruments = parameters.instruments;
        instrument_regions = parameters.instrument_regions;

        return Self
        {
            .allocator = allocator,
            .wave_data = wave_data.?,
            .sample_headers = sample_headers.?,
            .presets = presets.?,
            .preset_regions = preset_regions.?,
            .instruments = instruments.?,
            .instrument_regions = instrument_regions.?,
        };
    }

    pub fn deinit(self: *Self) void
    {
        self.allocator.free(self.wave_data);
        self.allocator.free(self.sample_headers);
        self.allocator.free(self.presets);
        self.allocator.free(self.preset_regions);
        self.allocator.free(self.instruments);
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
    presets: []Preset,
    preset_regions: []PresetRegion,
    instruments: []Instrument,
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
                preset_infos = try PresetInfo.readFromChunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "pbag"))
            {
                preset_bag = try ZoneInfo.readFromChunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "pmod"))
            {
                try reader.skipBytes(size, .{});
            }
            else if (mem.eql(u8, &id, "pgen"))
            {
                preset_generators = try Generator.readFromChunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "inst"))
            {
                instrument_infos = try InstrumentInfo.readFromChunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "ibag"))
            {
                instrument_bag = try ZoneInfo.readFromChunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "imod"))
            {
                try reader.skipBytes(size, .{});
            }
            else if (mem.eql(u8, &id, "igen"))
            {
                instrument_generators = try Generator.readFromChunk(allocator, reader, size);
            }
            else if (mem.eql(u8, &id, "shdr"))
            {
                sample_headers = try SampleHeader.readFromChunk(allocator, reader, size);
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

        const instruments = try Instrument.create(allocator, instrument_infos.?, instrument_zones, instrument_regions);
        errdefer allocator.free(instruments);

        const preset_zones = try Zone.create(allocator, preset_bag.?, preset_generators.?);
        defer allocator.free(preset_zones);

        const preset_regions = try PresetRegion.create(allocator, preset_infos.?, preset_zones, instruments);
        errdefer allocator.free(preset_regions);

        const presets = try Preset.create(allocator, preset_infos.?, preset_zones, preset_regions);
        errdefer allocator.free(presets);

        return Self
        {
            .sample_headers = sample_headers.?,
            .presets = presets,
            .preset_regions = preset_regions,
            .instruments = instruments,
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

    fn readFromChunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
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

    fn readFromChunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
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



pub const Preset = struct
{
    const Self = @This();

    name: [20]u8,
    regions: []PresetRegion,

    fn init(name: [20]u8, regions: []PresetRegion) Self
    {
        return Self
        {
            .name = name,
            .regions = regions,
        };
    }

    fn create(allocator: Allocator, infos: []PresetInfo, all_zones: []Zone, all_regions: []PresetRegion) ![]Self
    {
        // The last one is the terminator.
        const preset_count = infos.len - 1;

        var presets = try allocator.alloc(Self, preset_count);
        errdefer allocator.free(presets);

        var preset_index: usize = 0;
        var region_index: usize = 0;
        while (preset_index < preset_count) : (preset_index += 1)
        {
            const info = infos[preset_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            var region_count: usize = undefined;
            // Is the first one the global zone?
            if (PresetRegion.containsGlobalZone(zones))
            {
                // The first one is the global zone.
                region_count = zones.len - 1;
            }
            else
            {
                // No global zone.
                region_count = zones.len;
            }

            const region_end = region_index + region_count;
            presets[preset_index] = Preset.init(info.name, all_regions[region_index..region_end]);
            region_index += region_count;
        }

        if (region_index != all_regions.len)
        {
            return ZiggySynthError.Unexpected;
        }

        return presets;
    }
};



pub const PresetRegion = struct
{
    const Self = @This();

    instrument: *Instrument,
    gs: [GeneratorType.COUNT]i16,

    fn containsGlobalZone(zones: []Zone) bool
    {
        if (zones[0].generators.len == 0)
        {
            return true;
        }

        if (zones[0].generators[zones[0].generators.len - 1].generator_type != GeneratorType.INSTRUMENT)
        {
            return true;
        }

        return false;
    }

    fn countRegions(infos: []PresetInfo, all_zones: []Zone) usize
    {
        // The last one is the terminator.
        const preset_count = infos.len - 1;

        var sum: usize = 0;

        var preset_index: usize = 0;
        while (preset_index < preset_count) : (preset_index += 1)
        {
            const info = infos[preset_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            // Is the first one the global zone?
            if (PresetRegion.containsGlobalZone(zones))
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

    fn setParameter(gs: *[GeneratorType.COUNT]i16, generator: *const Generator) void
    {
        const index = generator.generator_type;

        // Unknown generators should be ignored.
        if (index < gs.len)
        {
            gs[index] = generator.value;
        }
    }

    fn init(global: *const Zone, local: *const Zone, instruments: []Instrument) !Self
    {
        var gs = mem.zeroes([GeneratorType.COUNT]i16);
        gs[GeneratorType.KEY_RANGE] = 0x7F00;
        gs[GeneratorType.VELOCITY_RANGE] = 0x7F00;

        for (global.generators) |value|
        {
            setParameter(&gs, &value);
        }

        for (local.generators) |value|
        {
            setParameter(&gs, &value);
        }

        const id = @intCast(usize, gs[GeneratorType.INSTRUMENT]);
        if (id >= instruments.len)
        {
            return ZiggySynthError.InvalidSoundFont;
        }
        const instrument = &instruments[id];

        return Self
        {
            .instrument = instrument,
            .gs = gs,
        };
    }

    fn create(allocator: Allocator, infos: []PresetInfo, all_zones: []Zone, instruments: []Instrument) ![]Self
    {
        // The last one is the terminator.
        const preset_count = infos.len - 1;

        var regions = try allocator.alloc(Self, PresetRegion.countRegions(infos, all_zones));
        errdefer allocator.free(regions);
        var region_index: usize = 0;

        var preset_index: usize = 0;
        while (preset_index < preset_count) : (preset_index += 1)
        {
            const info = infos[preset_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            // Is the first one the global zone?
            if (PresetRegion.containsGlobalZone(zones))
            {
                // The first one is the global zone.
                var i: usize = 0;
                while (i < zones.len - 1) : (i += 1)
                {
                    regions[region_index] = try PresetRegion.init(&zones[0], &zones[i + 1], instruments);
                    region_index += 1;
                }
            }
            else
            {
                // No global zone.
                var i: usize = 0;
                while (i < zones.len) : (i += 1)
                {
                    regions[region_index] = try PresetRegion.init(&Zone.empty(), &zones[i], instruments);
                    region_index += 1;
                }
            }
        }

        if (region_index != regions.len)
        {
            return ZiggySynthError.Unexpected;
        }

        return regions;
    }

    pub fn getModulationLfoToPitch(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_LFO_TO_PITCH]);
    }

    pub fn getVibratoLfoToPitch(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.VIBRATO_LFO_TO_PITCH]);
    }

    pub fn getModulationEnvelopeToPitch(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_ENVELOPE_TO_PITCH]);
    }

    pub fn getInitialFilterCutoffFrequency(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.INITIAL_FILTER_CUTOFF_FREQUENCY]));
    }

    pub fn getInitialFilterQ(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.INITIAL_FILTER_Q]);
    }

    pub fn getModulationLfoToFilterCutoffFrequency(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_LFO_TO_FILTER_CUTOFF_FREQUENCY]);
    }

    pub fn getModulationEnvelopeToFilterCutoffFrequency(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_ENVELOPE_TO_FILTER_CUTOFF_FREQUENCY]);
    }

    pub fn getModulationLfoToVolume(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.MODULATION_LFO_TO_VOLUME]);
    }

    pub fn getChorusEffectsSend(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.CHORUS_EFFECTS_SEND]);
    }

    pub fn getReverbEffectsSend(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.REVERB_EFFECTS_SEND]);
    }

    pub fn getPan(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.PAN]);
    }

    pub fn getDelayModulationLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.DELAY_MODULATION_LFO]));
    }

    pub fn getFrequencyModulationLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.FREQUENCY_MODULATION_LFO]));
    }

    pub fn getDelayVibratoLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.DELAY_VIBRATO_LFO]));
    }

    pub fn getFrequencyVibratoLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.FREQUENCY_VIBRATO_LFO]));
    }

    pub fn getDelayModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.DELAY_MODULATION_ENVELOPE]));
    }

    pub fn getAttackModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.ATTACK_MODULATION_ENVELOPE]));
    }

    pub fn getHoldModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.HOLD_MODULATION_ENVELOPE]));
    }

    pub fn getDecayModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.DECAY_MODULATION_ENVELOPE]));
    }

    pub fn getSustainModulationEnvelope(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.SUSTAIN_MODULATION_ENVELOPE]);
    }

    pub fn getReleaseModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.RELEASE_MODULATION_ENVELOPE]));
    }

    pub fn getKeyNumberToModulationEnvelopeHold(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_MODULATION_ENVELOPE_HOLD]);
    }

    pub fn getKeyNumberToModulationEnvelopeDecay(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_MODULATION_ENVELOPE_DECAY]);
    }

    pub fn getDelayVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.DELAY_VOLUME_ENVELOPE]));
    }

    pub fn getAttackVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.ATTACK_VOLUME_ENVELOPE]));
    }

    pub fn getHoldVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.HOLD_VOLUME_ENVELOPE]));
    }

    pub fn getDecayVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.DECAY_VOLUME_ENVELOPE]));
    }

    pub fn getSustainVolumeEnvelope(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.SUSTAIN_VOLUME_ENVELOPE]);
    }

    pub fn getReleaseVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.centsToMultiplyingFactor(@intToFloat(f32, self.gs[GeneratorType.RELEASE_VOLUME_ENVELOPE]));
    }

    pub fn getKeyNumberToVolumeEnvelopeHold(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_VOLUME_ENVELOPE_HOLD]);
    }

    pub fn getKeyNumberToVolumeEnvelopeDecay(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_VOLUME_ENVELOPE_DECAY]);
    }

    pub fn getKeyRangeStart(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_RANGE]) & 0xFF;
    }

    pub fn getKeyRangeEnd(self: *const Self) i32
    {
        return (@intCast(i32, self.gs[GeneratorType.KEY_RANGE]) >> 8) & 0xFF;
    }

    pub fn getVelocityRangeStart(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.VELOCITY_RANGE]) & 0xFF;
    }

    pub fn getVelocityRangeEnd(self: *const Self) i32
    {
        return (@intCast(i32, self.gs[GeneratorType.VELOCITY_RANGE]) >> 8) & 0xFF;
    }

    pub fn getInitialAttenuation(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.INITIAL_ATTENUATION]);
    }

    pub fn getCoarseTune(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.COARSE_TUNE]);
    }

    pub fn getFineTune(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.FINE_TUNE]);
    }

    pub fn getScaleTuning(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.SCALE_TUNING]);
    }
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

    fn readFromChunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 38 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 38;

        if (count <= 1)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

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
                presets[i].zone_end_index = presets[i + 1].zone_start_index;
            }
        }

        return presets;
    }
};



pub const Instrument = struct
{
    const Self = @This();

    name: [20]u8,
    regions: []InstrumentRegion,

    fn init(name: [20]u8, regions: []InstrumentRegion) Self
    {
        return Self
        {
            .name = name,
            .regions = regions,
        };
    }

    fn create(allocator: Allocator, infos: []InstrumentInfo, all_zones: []Zone, all_regions: []InstrumentRegion) ![]Self
    {
        // The last one is the terminator.
        const instrument_count = infos.len - 1;

        var instruments = try allocator.alloc(Self, instrument_count);
        errdefer allocator.free(instruments);

        var instrument_index: usize = 0;
        var region_index: usize = 0;
        while (instrument_index < instrument_count) : (instrument_index += 1)
        {
            const info = infos[instrument_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            var region_count: usize = undefined;
            // Is the first one the global zone?
            if (InstrumentRegion.containsGlobalZone(zones))
            {
                // The first one is the global zone.
                region_count = zones.len - 1;
            }
            else
            {
                // No global zone.
                region_count = zones.len;
            }

            const region_end = region_index + region_count;
            instruments[instrument_index] = Instrument.init(info.name, all_regions[region_index..region_end]);
            region_index += region_count;
        }

        if (region_index != all_regions.len)
        {
            return ZiggySynthError.Unexpected;
        }

        return instruments;
    }
};



pub const InstrumentRegion = struct
{
    const Self = @This();

    sample: *SampleHeader,
    gs: [GeneratorType.COUNT]i16,

    fn containsGlobalZone(zones: []Zone) bool
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

    fn countRegions(infos: []InstrumentInfo, all_zones: []Zone) usize
    {
        // The last one is the terminator.
        const instrument_count = infos.len - 1;

        var sum: usize = 0;

        var instrument_index: usize = 0;
        while (instrument_index < instrument_count) : (instrument_index += 1)
        {
            const info = infos[instrument_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            // Is the first one the global zone?
            if (InstrumentRegion.containsGlobalZone(zones))
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

    fn setParameter(gs: *[GeneratorType.COUNT]i16, generator: *const Generator) void
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
            setParameter(&gs, &value);
        }

        for (local.generators) |value|
        {
            setParameter(&gs, &value);
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

    fn create(allocator: Allocator, infos: []InstrumentInfo, all_zones: []Zone, samples: []SampleHeader) ![]Self
    {
        // The last one is the terminator.
        const instrument_count = infos.len - 1;

        var regions = try allocator.alloc(Self, InstrumentRegion.countRegions(infos, all_zones));
        errdefer allocator.free(regions);
        var region_index: usize = 0;

        var instrument_index: usize = 0;
        while (instrument_index < instrument_count) : (instrument_index += 1)
        {
            const info = infos[instrument_index];
            const zones = all_zones[info.zone_start_index..info.zone_end_index];

            // Is the first one the global zone?
            if (InstrumentRegion.containsGlobalZone(zones))
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
            return ZiggySynthError.Unexpected;
        }

        return regions;
    }

    pub fn getSampleStart(self: *const Self) i32
    {
        return self.sample.start + self.getStartAddressOffset();
    }

    pub fn getSampleEnd(self: *const Self) i32
    {
        return self.sample.end + self.getEndAddressOffset();
    }

    pub fn getSampleStartLoop(self: *const Self) i32
    {
        return self.sample.start_loop + self.getStartLoopAddressOffset();
    }

    pub fn getSampleEndLoop(self: *const Self) i32
    {
        return self.sample.end_loop + self.getEndLoopAddressOffset();
    }

    pub fn getStartAddressOffset(self: *const Self) i32
    {
        return 32768 * @intCast(i32, self.gs[GeneratorType.START_ADDRESS_COARSE_OFFSET]) + @intCast(i32, self.gs[GeneratorType.START_ADDRESS_OFFSET]);
    }

    pub fn getEndAddressOffset(self: *const Self) i32
    {
        return 32768 * @intCast(i32, self.gs[GeneratorType.END_ADDRESS_COARSE_OFFSET]) + @intCast(i32, self.gs[GeneratorType.END_ADDRESS_OFFSET]);
    }

    pub fn getStartLoopAddressOffset(self: *const Self) i32
    {
        return 32768 * @intCast(i32, self.gs[GeneratorType.START_LOOP_ADDRESS_COARSE_OFFSET]) + @intCast(i32, self.gs[GeneratorType.START_LOOP_ADDRESS_OFFSET]);
    }

    pub fn getEndLoopAddressOffset(self: *const Self) i32
    {
        return 32768 * @intCast(i32, self.gs[GeneratorType.END_LOOP_ADDRESS_COARSE_OFFSET]) + @intCast(i32, self.gs[GeneratorType.END_LOOP_ADDRESS_OFFSET]);
    }

    pub fn getModulationLfoToPitch(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_LFO_TO_PITCH]);
    }

    pub fn getVibratoLfoToPitch(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.VIBRATO_LFO_TO_PITCH]);
    }

    pub fn getModulationEnvelopeToPitch(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_ENVELOPE_TO_PITCH]);
    }

    pub fn getInitialFilterCutoffFrequency(self: *const Self) f32
    {
        return SoundFontMath.centsToHertz(@intToFloat(f32, self.gs[GeneratorType.INITIAL_FILTER_CUTOFF_FREQUENCY]));
    }

    pub fn getInitialFilterQ(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.INITIAL_FILTER_Q]);
    }

    pub fn getModulationLfoToFilterCutoffFrequency(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_LFO_TO_FILTER_CUTOFF_FREQUENCY]);
    }

    pub fn getModulationEnvelopeToFilterCutoffFrequency(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.MODULATION_ENVELOPE_TO_FILTER_CUTOFF_FREQUENCY]);
    }

    pub fn getModulationLfoToVolume(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.MODULATION_LFO_TO_VOLUME]);
    }

    pub fn getChorusEffectsSend(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.CHORUS_EFFECTS_SEND]);
    }

    pub fn getReverbEffectsSend(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.REVERB_EFFECTS_SEND]);
    }

    pub fn getPan(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.PAN]);
    }

    pub fn getDelayModulationLfo(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.DELAY_MODULATION_LFO]));
    }

    pub fn getFrequencyModulationLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToHertz(@intToFloat(f32, self.gs[GeneratorType.FREQUENCY_MODULATION_LFO]));
    }

    pub fn getDelayVibratoLfo(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.DELAY_VIBRATO_LFO]));
    }

    pub fn getFrequencyVibratoLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToHertz(@intToFloat(f32, self.gs[GeneratorType.FREQUENCY_VIBRATO_LFO]));
    }

    pub fn getDelayModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.DELAY_MODULATION_ENVELOPE]));
    }

    pub fn getAttackModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.ATTACK_MODULATION_ENVELOPE]));
    }

    pub fn getHoldModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.HOLD_MODULATION_ENVELOPE]));
    }

    pub fn getDecayModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.DECAY_MODULATION_ENVELOPE]));
    }

    pub fn getSustainModulationEnvelope(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.SUSTAIN_MODULATION_ENVELOPE]);
    }

    pub fn getReleaseModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.RELEASE_MODULATION_ENVELOPE]));
    }

    pub fn getKeyNumberToModulationEnvelopeHold(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_MODULATION_ENVELOPE_HOLD]);
    }

    pub fn getKeyNumberToModulationEnvelopeDecay(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_MODULATION_ENVELOPE_DECAY]);
    }

    pub fn getDelayVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.DELAY_VOLUME_ENVELOPE]));
    }

    pub fn getAttackVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.ATTACK_VOLUME_ENVELOPE]));
    }

    pub fn getHoldVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.HOLD_VOLUME_ENVELOPE]));
    }

    pub fn getDecayVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.DECAY_VOLUME_ENVELOPE]));
    }

    pub fn getSustainVolumeEnvelope(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.SUSTAIN_VOLUME_ENVELOPE]);
    }

    pub fn getReleaseVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs[GeneratorType.RELEASE_VOLUME_ENVELOPE]));
    }

    pub fn getKeyNumberToVolumeEnvelopeHold(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_VOLUME_ENVELOPE_HOLD]);
    }

    pub fn getKeyNumberToVolumeEnvelopeDecay(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_NUMBER_TO_VOLUME_ENVELOPE_DECAY]);
    }

    pub fn getKeyRangeStart(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.KEY_RANGE]) & 0xFF;
    }

    pub fn getKeyRangeEnd(self: *const Self) i32
    {
        return (@intCast(i32, self.gs[GeneratorType.KEY_RANGE]) >> 8) & 0xFF;
    }

    pub fn getVelocityRangeStart(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.VELOCITY_RANGE]) & 0xFF;
    }

    pub fn getVelocityRangeEnd(self: *const Self) i32
    {
        return (@intCast(i32, self.gs[GeneratorType.VELOCITY_RANGE]) >> 8) & 0xFF;
    }

    pub fn getInitialAttenuation(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs[GeneratorType.INITIAL_ATTENUATION]);
    }

    pub fn getCoarseTune(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.COARSE_TUNE]);
    }

    pub fn getFineTune(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.FINE_TUNE]) + self.sample.pitch_correction;
    }

    pub fn getSampleModes(self: *const Self) i32
    {
        return if (self.gs[GeneratorType.SAMPLE_MODES] != 2) self.gs[GeneratorType.SAMPLE_MODES] else LoopMode.NO_LOOP;
    }

    pub fn getScaleTuning(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.SCALE_TUNING]);
    }

    pub fn getExclusiveClass(self: *const Self) i32
    {
        return @intCast(i32, self.gs[GeneratorType.EXCLUSIVE_CLASS]);
    }

    pub fn getRootKey(self: *const Self) i32
    {
        return if (self.gs[GeneratorType.OVERRIDING_ROOT_KEY] != -1) self.gs[GeneratorType.OVERRIDING_ROOT_KEY] else self.sample.original_pitch;
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

    fn readFromChunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 22 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 22;

        if (count <= 1)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

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

    fn readFromChunk(allocator: Allocator, reader: anytype, size: usize) ![]Self
    {
        if (size % 46 != 0)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

        const count = size / 46 - 1;

        if (count <= 1)
        {
            return ZiggySynthError.InvalidSoundFont;
        }

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



const LoopMode = struct
{
    const NO_LOOP: i32 = 0;
    const CONTINUOUS: i32 = 0;
    const LOOP_UNTIL_NOTE_OFF: i32 = 0;
};



pub const Synthesizer = struct
{
    const Self = @This();

    sample_rate: i32,
    block_size: i32,
};



const RegionPair = struct
{
    const Self = @This();

    preset: *PresetRegion,
    instrument: *InstrumentRegion,

    fn gs(self: *const Self, i: usize) i32
    {
        @intCast(i32, self.preset.gs[i]) + @intCast(i32, self.instrument.gs[i]);
    }

    fn getSampleStart(self: *const Self) i32
    {
        return self.instrument.getSampleStart();
    }

    fn getSampleEnd(self: *const Self) i32
    {
        return self.instrument.getSampleEnd();
    }

    fn getSampleStartLoop(self: *const Self) i32
    {
        return self.instrument.getSampleStartLoop();
    }

    fn getSampleEndLoop(self: *const Self) i32
    {
        return self.instrument.getSampleEndLoop();
    }

    fn getStartAddressOffset(self: *const Self) i32
    {
        return self.instrument.getStartAddressOffset();
    }

    fn getEndAddressOffset(self: *const Self) i32
    {
        return self.instrument.getEndAddressOffset();
    }

    fn getStartLoopAddressOffset(self: *const Self) i32
    {
        return self.instrument.getStartLoopAddressOffset();
    }

    fn getEndLoopAddressOffset(self: *const Self) i32
    {
        return self.instrument.getEndLoopAddressOffset();
    }

    fn getModulationLfoToPitch(self: *const Self) i32
    {
        return self.gs(GeneratorType.MODULATION_LFO_TO_PITCH);
    }

    fn getVibratoLfoToPitch(self: *const Self) i32
    {
        return self.gs(GeneratorType.VIBRATO_LFO_TO_PITCH);
    }

    fn getModulationEnvelopeToPitch(self: *const Self) i32
    {
        return self.gs(GeneratorType.MODULATION_ENVELOPE_TO_PITCH);
    }

    fn getInitialFilterCutoffFrequency(self: *const Self) f32
    {
        return SoundFontMath.centsToHertz(@intToFloat(f32, self.gs(GeneratorType.INITIAL_FILTER_CUTOFF_FREQUENCY)));
    }

    fn getInitialFilterQ(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.INITIAL_FILTER_Q));
    }

    fn getModulationLfoToFilterCutoffFrequency(self: *const Self) i32
    {
        return self.gs(GeneratorType.MODULATION_LFO_TO_FILTER_CUTOFF_FREQUENCY);
    }

    fn getModulationEnvelopeToFilterCutoffFrequency(self: *const Self) i32
    {
        return self.gs(GeneratorType.MODULATION_ENVELOPE_TO_FILTER_CUTOFF_FREQUENCY);
    }

    fn getModulationLfoToVolume(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.MODULATION_LFO_TO_VOLUME));
    }

    fn getChorusEffectsSend(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.CHORUS_EFFECTS_SEND));
    }

    fn getReverbEffectsSend(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.REVERB_EFFECTS_SEND));
    }

    fn getPan(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.PAN));
    }

    fn getDelayModulationLfo(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.DELAY_MODULATION_LFO)));
    }

    fn getFrequencyModulationLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToHertz(@intToFloat(f32, self.gs(GeneratorType.FREQUENCY_MODULATION_LFO)));
    }

    fn getDelayVibratoLfo(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.DELAY_VIBRATO_LFO)));
    }

    fn getFrequencyVibratoLfo(self: *const Self) f32
    {
        return SoundFontMath.centsToHertz(@intToFloat(f32, self.gs(GeneratorType.FREQUENCY_VIBRATO_LFO)));
    }

    fn getDelayModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.DELAY_MODULATION_ENVELOPE)));
    }

    fn getAttackModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.ATTACK_MODULATION_ENVELOPE)));
    }

    fn getHoldModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.HOLD_MODULATION_ENVELOPE)));
    }

    fn getDecayModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.DECAY_MODULATION_ENVELOPE)));
    }

    fn getSustainModulationEnvelope(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.SUSTAIN_MODULATION_ENVELOPE));
    }

    fn getReleaseModulationEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.RELEASE_MODULATION_ENVELOPE)));
    }

    fn getKeyNumberToModulationEnvelopeHold(self: *const Self) i32
    {
        return self.gs(GeneratorType.KEY_NUMBER_TO_MODULATION_ENVELOPE_HOLD);
    }

    fn getKeyNumberToModulationEnvelopeDecay(self: *const Self) i32
    {
        return self.gs(GeneratorType.KEY_NUMBER_TO_MODULATION_ENVELOPE_DECAY);
    }

    fn getDelayVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.DELAY_VOLUME_ENVELOPE)));
    }

    fn getAttackVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.ATTACK_VOLUME_ENVELOPE)));
    }

    fn getHoldVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.HOLD_VOLUME_ENVELOPE)));
    }

    fn getDecayVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.DECAY_VOLUME_ENVELOPE)));
    }

    fn getSustainVolumeEnvelope(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.SUSTAIN_VOLUME_ENVELOPE));
    }

    fn getReleaseVolumeEnvelope(self: *const Self) f32
    {
        return SoundFontMath.timecentsToSeconds(@intToFloat(f32, self.gs(GeneratorType.RELEASE_VOLUME_ENVELOPE)));
    }

    fn getKeyNumberToVolumeEnvelopeHold(self: *const Self) i32
    {
        return self.gs(GeneratorType.KEY_NUMBER_TO_VOLUME_ENVELOPE_HOLD);
    }

    fn getKeyNumberToVolumeEnvelopeDecay(self: *const Self) i32
    {
        return self.gs(GeneratorType.KEY_NUMBER_TO_VOLUME_ENVELOPE_DECAY);
    }

    fn getInitialAttenuation(self: *const Self) f32
    {
        return 0.1 * @intToFloat(f32, self.gs(GeneratorType.INITIAL_ATTENUATION));
    }

    fn getCoarseTune(self: *const Self) i32
    {
        return self.gs(GeneratorType.COARSE_TUNE);
    }

    fn getFineTune(self: *const Self) i32
    {
        return self.gs(GeneratorType.FINE_TUNE) + self.instrument.sample.pitch_correction;
    }

    fn getSampleModes(self: *const Self) i32
    {
        return self.instrument.getSampleModes();
    }

    fn getScaleTuning(self: *const Self) i32
    {
        return self.gs(GeneratorType.SCALE_TUNING);
    }

    fn getExclusiveClass(self: *const Self) i32
    {
        return self.instrument.getExclusiveClass();
    }

    fn getRootKey(self: *const Self) i32
    {
        return self.instrument.getRootKey();
    }
};



const RegionEx = struct
{
    fn start_volume_envelope(envelope: *VolumeEnvelope, region: *RegionPair, key: i32) void
    {
        // If the release time is shorter than 10 ms, it will be clamped to 10 ms to avoid pop noise.

        const delay = region.getDelayVolumeEnvelope();
        const attack = region.getAttackVolumeEnvelope();
        const hold = region.getHoldVolumeEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToVolumeEnvelopeHold(), key);
        const decay = region.getDecayVolumeEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToVolumeEnvelopeDecay(), key);
        const sustain = SoundFontMath.decibelsToLinear(-region.getSustainVolumeEnvelope());
        const release = @maximum(region.getReleaseVolumeEnvelope(), 0.01);

        envelope.start(delay, attack, hold, decay, sustain, release);
    }

    fn start_modulation_envelope(envelope: *ModulationEnvelope, region: *RegionPair, key: i32, velocity: i32) void
    {
         // According to the implementation of TinySoundFont, the attack time should be adjusted by the velocity.

         const delay = region.getDelayModulationEnvelope();
         const attack = region.getAttackModulationEnvelope() * (@intToFloat(f32, 145 - velocity) / 144.0);
         const hold = region.getHoldModulationEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToModulationEnvelopeHold(), key);
         const decay = region.getDecayModulationEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToModulationEnvelopeDecay(), key);
         const sustain = 1.0 - region.getSustainModulationEnvelope() / 100.0;
         const release = region.getReleaseModulationEnvelope();

         envelope.start(delay, attack, hold, decay, sustain, release);
    }
};



const Voice = struct
{
    const Self = @This();
};



const VoiceCollection = struct
{
    const Self = @This();
};



const Oscillator = struct
{
    const Self = @This();
};



const BiQuadFilter = struct
{
    const Self = @This();
};



const VolumeEnvelope = struct
{
    const Self = @This();

    synthesizer: *Synthesizer,

    attack_slope: f64,
    decay_slope: f64,
    release_slope: f64,

    attack_start_time: f64,
    hold_start_time: f64,
    decay_start_time: f64,
    release_start_time: f64,

    sustain_level: f32,
    release_level: f32,

    processed_sample_count: i32,
    stage: i32,
    value: f32,

    priority: f32,

    fn init(synthesizer: *Synthesizer) Self
    {
        return Self
        {
            .synthesizer = synthesizer,
            .attack_slope = 0.0,
            .decay_slope = 0.0,
            .release_slope = 0.0,
            .attack_start_time = 0.0,
            .hold_start_time = 0.0,
            .decay_start_time = 0.0,
            .release_start_time = 0.0,
            .sustain_level = 0.0,
            .release_level = 0.0,
            .processed_sample_count = 0,
            .stage = 0,
            .value = 0.0,
            .priority = 0.0,
        };
    }

    fn start(self: *Self, delay: f32, attack: f32, hold: f32, decay: f32, sustain: f32, release: f32) void
    {
        self.attack_slope = 1.0 / attack;
        self.decay_slope = -9.226 / decay;
        self.release_slope = -9.226 / release;

        self.attack_start_time = delay;
        self.hold_start_time = self.attack_start_time + attack;
        self.decay_start_time = self.hold_start_time + hold;
        self.release_start_time = 0.0;

        self.sustain_level = SoundFontMath.clamp(sustain, 0.0, 1.0);
        self.release_level = 0.0;

        self.processed_sample_count = 0;
        self.stage = EnvelopeStage.DELAY;
        self.value = 0.0;

        self.process(0);
    }

    fn release_voice(self: *Self) void
    {
        self.stage = EnvelopeStage.RELEASE;
        self.release_start_time = @intToFloat(f64, self.processed_sample_count) / @intToFloat(f64, self.synthesizer.sample_rate);
        self.release_level = self.value;
    }

    fn process(self: *Self, sample_count: i32) bool
    {
        self.processed_sample_count += sample_count;

        const current_time = @intToFloat(f64, self.processed_sample_count) / @intToFloat(f64, self.synthesizer.sample_rate);

        while (self.stage <= EnvelopeStage.HOLD)
        {
            const end_time = switch (self.stage)
            {
                EnvelopeStage.DELAY => self.attack_start_time,
                EnvelopeStage.ATTACK => self.hold_start_time,
                EnvelopeStage.HOLD => self.decay_start_time,
                else => unreachable,
            };

            if (current_time < end_time)
            {
                break;
            }
            else
            {
                self.stage += 1;
            }
        }

        if (self.stage == EnvelopeStage.DELAY)
        {
            self.value = 0.0;
            self.priority = 4.0 + self.value;
            return true;
        }
        else if (self.stage == EnvelopeStage.ATTACK)
        {
            self.value = self.attack_slope * (current_time - self.attack_start_time);
            self.priority = 3.0 + self.value;
            return true;
        }
        else if (self.stage == EnvelopeStage.HOLD)
        {
            self.value = 1.0;
            self.priority = 2.0 + self.value;
            return true;
        }
        else if (self.stage == EnvelopeStage.DECAY)
        {
            self.value = @maximum(SoundFontMath.expCutoff(self.decay_slope * (current_time - self.decay_start_time)), self.sustain_level);
            self.priority = 1.0 + self.value;
            return self.value > SoundFontMath.NON_AUDIBLE;
        }
        else if (self.stage == EnvelopeStage.RELEASE)
        {
            self.value = self.release_level * SoundFontMath.exp_cutoff(self.release_slope * (current_time - self.release_start_time));
            self.priority = self.value;
            return self.value > SoundFontMath.NON_AUDIBLE;
        }
        else
        {
            unreachable;
        }
    }

    fn get_value(self: *Self) f32
    {
        return self.value;
    }
};



const ModulationEnvelope = struct
{
    const Self = @This();

    synthesizer: *Synthesizer,

    attack_slope: f64,
    decay_slope: f64,
    release_slope: f64,

    attack_start_time: f64,
    hold_start_time: f64,
    decay_start_time: f64,

    decay_end_time: f64,
    release_end_time: f64,

    sustain_level: f32,
    release_level: f32,

    processed_sample_count: i32,
    stage: i32,
    value: f32,

    fn init(synthesizer: *Synthesizer) Self
    {
        return Self
        {
            .synthesizer = synthesizer,
            .attack_slope = 0.0,
            .decay_slope = 0.0,
            .release_slope = 0.0,
            .attack_start_time = 0.0,
            .hold_start_time = 0.0,
            .decay_start_time = 0.0,
            .decay_end_time = 0.0,
            .release_end_time = 0.0,
            .sustain_level = 0.0,
            .release_level = 0.0,
            .processed_sample_count = 0,
            .stage = 0,
            .priority = 0.0,
        };
    }

    fn start(self: *Self, delay: f32, attack: f32, hold: f32, decay: f32, sustain: f32, release: f32) void
    {
        self.attack_slope = 1.0 / attack;
        self.decay_slope = 1.0 / decay;
        self.release_slope = 1.0 / release;

        self.attack_start_time = delay;
        self.hold_start_time = self.attack_start_time + attack;
        self.decay_start_time = self.hold_start_time + hold;

        self.decay_end_time = self.decay_start_time + decay;
        self.release_end_time = release;

        self.sustain_level = SoundFontMath.clamp(sustain, 0.0, 1.0);
        self.release_level = 0.0;

        self.processed_sample_count = 0;
        self.stage = EnvelopeStage.DELAY;
        self.value = 0.0;

        self.process(0);
    }

    fn release_voice(self: *Self) void
    {
        self.stage = EnvelopeStage.RELEASE;
        self.release_end_time += @intToFloat(f64, self.processed_sample_count) / @intToFloat(f64, self.synthesizer.sample_rate);
        self.release_level = self.value;
    }

    fn process(self: *Self, sample_count: i32) void
    {
        self.processed_sample_count += sample_count;

        const current_time = @intToFloat(f64, self.processed_sample_count) / @intToFloat(f64, self.synthesizer.sample_rate);

        while (self.stage <= EnvelopeStage.HOLD)
        {
            const end_time = switch (self.stage)
            {
                EnvelopeStage.DELAY => self.attack_start_time,
                EnvelopeStage.ATTACK => self.hold_start_time,
                EnvelopeStage.HOLD => self.decay_start_time,
                else => unreachable,
            };

            if (current_time < end_time)
            {
                break;
            }
            else
            {
                self.stage += 1;
            }
        }

        if (self.stage == EnvelopeStage.DELAY)
        {
            self.value = 0.0;
            return true;
        }
        else if (self.stage == EnvelopeStage.ATTACK)
        {
            self.value = self.attack_slope * (current_time - self.attack_start_time);
            return true;
        }
        else if (self.stage == EnvelopeStage.HOLD)
        {
            self.value = 1.0;
            return true;
        }
        else if (self.stage == EnvelopeStage.DECAY)
        {
            self.value = @maximum((self.decay_slope * (self.decay_end_time - current_time)), self.sustain_level);
            return self.value > SoundFontMath.NON_AUDIBLE;
        }
        else if (self.stage == EnvelopeStage.RELEASE)
        {
            self.value = @maximum((self.release_level * self.release_slope * (self.release_end_time - current_time)), 0.0);
            return self.value > SoundFontMath.NON_AUDIBLE;
        }
        else
        {
            unreachable;
        }
    }

    fn get_value(self: *Self) f32
    {
        return self.value;
    }
};



const EnvelopeStage = struct
{
    const DELAY: i32 = 0;
    const ATTACK: i32 = 1;
    const HOLD: i32 = 2;
    const DECAY: i32 = 3;
    const RELEASE: i32 = 4;
};



const Lfo = struct
{
    const Self = @This();
};



const Channel = struct
{
    const Self = @This();
};

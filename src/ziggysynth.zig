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
    channels: [16]Channel,
    minimum_voice_length: i32,
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
    fn startOscillator(oscillator: *Oscillator, data: []i16, region: *RegionPair) void
    {
        const sample_rate = region.instrument.sample_sample_rate;
        const loop_mode = region.getSampleModes();
        const start = region.getSampleStart();
        const end = region.getSampleEnd();
        const start_loop = region.getSampleStartLoop();
        const end_loop = region.getSampleEndLoop();
        const root_key = region.getRootKey();
        const coarse_tune = region.getCoarseTune();
        const fine_tune = region.getFineTune();
        const scale_tuning = region.getScaleTuning();

        oscillator.start(data, loop_mode, sample_rate, start, end, start_loop, end_loop, root_key, coarse_tune, fine_tune, scale_tuning);
    }

    fn startVolumeEnvelope(envelope: *VolumeEnvelope, region: *RegionPair, key: i32) void
    {
        // If the release time is shorter than 10 ms, it will be clamped to 10 ms to avoid pop noise.

        const delay = region.getDelayVolumeEnvelope();
        const attack = region.getAttackVolumeEnvelope();
        const hold = region.getHoldVolumeEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToVolumeEnvelopeHold(), key);
        const decay = region.getDecayVolumeEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToVolumeEnvelopeDecay(), key);
        const sustain = SoundFontMath.decibelsToLinear(-region.getSustainVolumeEnvelope());
        const release = @maximum(region.getReleaseVolumeEnvelope(), 0.01);

        envelope.startUnit(delay, attack, hold, decay, sustain, release);
    }

    fn startModulationEnvelope(envelope: *ModulationEnvelope, region: *RegionPair, key: i32, velocity: i32) void
    {
         // According to the implementation of TinySoundFont, the attack time should be adjusted by the velocity.

         const delay = region.getDelayModulationEnvelope();
         const attack = region.getAttackModulationEnvelope() * (@intToFloat(f32, 145 - velocity) / 144.0);
         const hold = region.getHoldModulationEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToModulationEnvelopeHold(), key);
         const decay = region.getDecayModulationEnvelope() * SoundFontMath.keyNumberToMultiplyingFactor(region.getKeyNumberToModulationEnvelopeDecay(), key);
         const sustain = 1.0 - region.getSustainModulationEnvelope() / 100.0;
         const release = region.getReleaseModulationEnvelope();

         envelope.startUnit(delay, attack, hold, decay, sustain, release);
    }

    fn startVibrato(lfo: *Lfo, region: *RegionPair) void
    {
        lfo.startUnit(region.getDelayVibratoLfo(), region.getFrequencyVibratoLfo());
    }

    fn startModulation(lfo: *Lfo, region: *RegionPair) void
    {
        lfo.startUnit(region.getDelayModulationLfo(), region.getFrequencyModulationLfo());
    }
};



const Voice = struct
{
    const Self = @This();

    const PLAYING: i32 = 0;
    const RELEASE_REQUESTED: i32 = 1;
    const RELEASED: i32 = 2;

    synthesizer: *Synthesizer,

    vol_env: VolumeEnvelope,
    mod_env: ModulationEnvelope,

    vib_lfo: Lfo,
    mod_lfo: Lfo,

    oscillator: Oscillator,
    filter: BiQuadFilter,

    block: []f32,

    // A sudden change in the mix gain will cause pop noise.
    // To avoid this, we save the mix gain of the previous block,
    // and smooth out the gain if the gap between the current and previous gain is too large.
    // The actual smoothing process is done in the WriteBlock method of the Synthesizer class.

    previous_mix_gain_left: f32,
    previous_mix_gain_right: f32,
    current_mix_gain_left: f32,
    current_mix_gain_right: f32,

    previous_reverb_send: f32,
    previous_chorus_send: f32,
    current_reverb_send: f32,
    current_chorus_send: f32,

    exclusive_class: i32,
    channel: i32,
    key: i32,
    velocity: i32,

    note_gain: f32,

    cutoff: f32,
    resonance: f32,

    vib_lfo_to_pitch: f32,
    mod_lfo_to_pitch: f32,
    mod_env_to_pitch: f32,

    mod_lfo_to_cutoff: i32,
    mod_env_to_cutoff: i32,
    dynamic_cutoff: bool,

    mod_lfo_to_volume: f32,
    dynamic_volume: bool,

    instrument_pan: f32,
    instrument_reverb: f32,
    instrument_chorus: f32,

    // Some instruments require fast cutoff change, which can cause pop noise.
    // This is used to smooth out the cutoff frequency.
    smoothed_cutoff: f32,

    voice_state: i32,
    voice_length: i32,

    fn init(synthesizer: *Synthesizer, block: []f32) Self
    {
        return Self
        {
            .synthesizer = synthesizer,
            .vol_env = VolumeEnvelope.init(synthesizer),
            .mod_env = ModulationEnvelope.init(synthesizer),
            .vib_lfo = Lfo.init(synthesizer),
            .mod_lfo = Lfo.init(synthesizer),
            .oscillator = Oscillator.init(synthesizer),
            .filter = BiQuadFilter.init(synthesizer),
            .block = block,
            .previous_mix_gain_left = 0.0,
            .previous_mix_gain_right = 0.0,
            .current_mix_gain_left = 0.0,
            .current_mix_gain_right = 0.0,
            .previous_reverb_send = 0.0,
            .previous_chorus_send = 0.0,
            .current_reverb_send = 0.0,
            .current_chorus_send = 0.0,
            .exclusive_class = 0,
            .channel = 0,
            .key = 0,
            .velocity = 0,
            .note_gain = 0.0,
            .cutoff = 0.0,
            .resonance = 0.0,
            .vib_lfo_to_pitch = 0.0,
            .mod_lfo_to_pitch = 0.0,
            .mod_env_to_pitch = 0.0,
            .mod_lfo_to_cutoff = 0,
            .mod_env_to_cutoff = 0,
            .dynamic_cutoff = false,
            .mod_lfo_to_volume = 0.0,
            .dynamic_volume = false,
            .instrument_pan = 0.0,
            .instrument_reverb = 0.0,
            .instrument_chorus = 0.0,
            .smoothed_cutoff = 0.0,
            .voice_state = 0,
            .voice_length = 0,
        };
    }

    fn startUnit(self: *Self, data: []i16, region: *RegionPair, channel: i32, key: i32, velocity: i32) void
    {
        self.exclusive_class = region.getExclusiveClass();
        self.channel = channel;
        self.key = key;
        self.velocity = velocity;

        if (velocity > 0)
        {
            // According to the Polyphone's implementation, the initial attenuation should be reduced to 40%.
            // I'm not sure why, but this indeed improves the loudness variability.
            const sample_attenuation = 0.4 * region.getInitialAttenuation();
            const filter_attenuation = 0.5 * region.getInitialFilterQ();
            const decibels = 2.0 * SoundFontMath.linearToDecibels(@intToFloat(f32, velocity) / 127.0) - sample_attenuation - filter_attenuation;
            self.note_gain = SoundFontMath.decibelsToLinear(decibels);
        }
        else
        {
            self.note_gain = 0.0;
        }

        self.cutoff = region.getInitialFilterCutoffFrequency();
        self.resonance = SoundFontMath.decibelsToLinear(region.getInitialFilterQ());

        self.vib_lfo_to_pitch = 0.01 * @intToFloat(f32, region.getVibratoLfoToPitch());
        self.mod_lfo_to_pitch = 0.01 * @intToFloat(f32, region.getModulationLfoToPitch());
        self.mod_env_to_pitch = 0.01 * @intToFloat(f32, region.getModulationEnvelopeToPitch());

        self.mod_lfo_to_cutoff = region.getModulationLfoToFilterCutoffFrequency();
        self.mod_env_to_cutoff = region.getModulationEnvelopeToFilterCutoffFrequency();
        self.dynamic_cutoff = self.mod_lfo_to_cutoff != 0 or self.mod_env_to_cutoff != 0;

        self.mod_lfo_to_volume = region.getModulationLfoToVolume();
        self.dynamic_volume = self.mod_lfo_to_volume > 0.05;

        self.instrument_pan = SoundFontMath.clamp(region.getPan(), -50.0, 50.0);
        self.instrument_reverb = 0.01 * region.getReverbEffectsSend();
        self.instrument_chorus = 0.01 * region.getChorusEffectsSend();

        RegionEx.startVolumeEnvelope(&self.vol_env, region, key, velocity);
        RegionEx.startModulationEnvelope(&self.mod_env, region, key, velocity);
        RegionEx.startVibrato(&self.vib_lfo, region, key, velocity);
        RegionEx.startModulation(&self.mod_lfo, region, key, velocity);
        RegionEx.startOscillator(&self.oscillator, data, region);
        self.filter.clearBuffer();
        self.filter.setLowPassFilter(self.cutoff, self.resonance);

        self.smoothed_cutoff = self.cutoff;

        self.voice_state = Voice.PLAYING;
        self.voice_length = 0;
    }

    fn end(self: *Self) void
    {
        if (self.voice_state == Voice.PLAYING)
        {
            self.voice_state = Voice.RELEASE_REQUESTED;
        }
    }

    fn kill(self: *Self) void
    {
        self.note_gain = 0.0;
    }

    fn processUnit(self: *Self) bool
    {
        if (self.note_gain < SoundFontMath.NON_AUDIBLE)
        {
            return false;
        }

        const channel_info = &self.synthesizer.channels[self.channel];

        self.releaseIfNecessary(channel_info);

        if (!self.vol_env.processUnit(self.block_size))
        {
            return false;
        }

        self.mod_env.processUnit(self.block_size);
        self.vib_lfo.processUnit();
        self.mod_lfo.processUnit();

        const vib_pitch_change = (0.01 * channel_info.getModulation() + self.vib_lfo_to_pitch) * self.vib_lfo.getValue();
        const mod_pitch_change = self.mod_lfo_to_pitch * self.mod_lfo.getValue() + self.mod_env_to_pitch * self.mod_env.getValue();
        const channel_pitch_change = channel_info.getTune() + channel_info.getPitchBend();
        const pitch = @intToFloat(f32, self.key) + vib_pitch_change + mod_pitch_change + channel_pitch_change;
        if (!self.oscillator.processUnit(self.block, pitch))
        {
            return false;
        }

        if (self.dynamic_cutoff)
        {
            const cents = @intToFloat(f32, self.mod_lfo_to_cutoff) * self.mod_lfo.getValue() + @intToFloat(f32, self.mod_env_to_cutoff) * self.mod_env.getValue();
            const factor = SoundFontMath.centsToMultiplyingFactor(cents);
            const new_cutoff = factor * self.cutoff;

            // The cutoff change is limited within x0.5 and x2 to reduce pop noise.
            const lower_limit = 0.5 * self.smoothed_cutoff;
            const upper_limit = 2.0 * self.smoothed_cutoff;
            self.smoothed_cutoff = SoundFontMath.clamp(new_cutoff, lower_limit, upper_limit);

            self.filter.setLowPassFilter(self.smoothed_cutoff, self.resonance);
        }
        self.filter.processUnit(self.block);

        self.previous_mix_gain_left = self.current_mix_gain_left;
        self.previous_mix_gain_right = self.current_mix_gain_right;
        self.previous_reverb_send = self.current_reverb_send;
        self.previous_chorus_send = self.current_chorus_send;

        // According to the GM spec, the following value should be squared.
        const ve = channel_info.getVolume() * channel_info.getExpression();
        const channel_gain = ve * ve;

        var mix_gain = self.note_gain * channel_gain * self.vol_env.getValue();
        if (self.dynamic_volume)
        {
            const decibels = self.mod_lfo_to_volume * self.mod_lfo.getValue();
            mix_gain *= SoundFontMath.decibelsToLinear(decibels);
        }

        const angle = (math.pi / 200.0) * (channel_info.getPan() + self.instrument_pan + 50.0);
        if (angle <= 0.0)
        {
            self.current_mix_gain_left = mix_gain;
            self.current_mix_gain_right = 0.0;
        }
        else if (angle >= SoundFontMath.HALF_PI)
        {
            self.current_mix_gain_left = 0.0;
            self.current_mix_gain_right = mix_gain;
        }
        else
        {
            self.current_mix_gain_left = mix_gain * @cos(angle);
            self.current_mix_gain_right = mix_gain * @sin(angle);
        }

        self.current_reverb_send = SoundFontMath.clamp(channel_info.getReverbSend() + self.instrument_reverb, 0.0, 1.0);
        self.current_chorus_send = SoundFontMath.clamp(channel_info.getChorusSend() + self.instrument_chorus, 0.0, 1.0);

        if (self.voice_length == 0)
        {
            self.previous_mix_gain_left = self.current_mix_gain_left;
            self.previous_mix_gain_right = self.current_mix_gain_right;
            self.previous_reverb_send = self.current_reverb_send;
            self.previous_chorus_send = self.current_chorus_send;
        }

        self.voice_length += self.block_size;

        return true;
    }

    fn releaseIfNecessary(self: *Self, channel_info: *Channel) void
    {
        if (self.voice_length < self.synthesizer.minimum_voice_length)
        {
            return;
        }

        if (self.voice_state == Voice.RELEASE_REQUESTED and !channel_info.getHoldPedal())
        {
            self.vol_env.releaseUnit();
            self.mod_env.releaseUnit();
            self.oscillator.releaseUnit();

            self.voice_state = Voice.RELEASED;
        }
    }

    fn getPriority(self: *const Self) f32
    {
        if (self.note_gain < SoundFontMath.NON_AUDIBLE)
        {
            return 0.0;
        }
        else
        {
            return self.vol_env.getPriority();
        }
    }
};



const VoiceCollection = struct
{
    const Self = @This();

    synthesizer: *Synthesizer,
    block_buffer: []f32,
    voices: []Voice,
    active_voice_count: i32,

    fn init(allocator: Allocator, synthesizer: *Synthesizer) !Self
    {
        var block_buffer = try allocator.alloc(f32, synthesizer.block_length * synthesizer.maximum_polyphony);
        errdefer allocator.free(block_buffer);

        var voices = try allocator.alloc(Voice, synthesizer.maximum_polyphony);
        errdefer allocator.free(voices);

        var i: usize = 0;
        while (i < voices.len) : (i += 1)
        {
            const buffer_start = synthesizer.block_length * i;
            const buffer_end = buffer_start + synthesizer.block_length;
            var block = block_buffer[buffer_start..buffer_end];
            voices[i] = Voice.init(synthesizer, block);
        }

        return Self
        {
            .synthesizer = synthesizer,
            .block_buffer = block_buffer,
            .voices = voices,
            .active_voice_count = 0,
        };
    }

    fn requestNew(self: *Self, region: *InstrumentRegion, channel: i32) ?*Voice
    {
        // If an exclusive class is assigned to the region, find a voice with the same class.
        // If found, reuse it to avoid playing multiple voices with the same class at a time.
        var exclusive_class = region.getExclusiveClass();
        if (exclusive_class != 0)
        {
            var i: usize = 0;
            while (i < self.active_voice_count) : (i += 1)
            {
                var voice = &self.voices[i];
                if (voice.getExclusiveClass() == exclusive_class and voice.channel == channel)
                {
                    return voice;
                }
            }
        }

        // If the number of active voices is less than the limit, use a free one.
        if (self.active_voice_count < self.voices.len)
        {
            var free = &self.voices[self.active_voice_count];
            self.active_voice_count += 1;
            return free;
        }

        // Too many active voices...
        // Find one which has the lowest priority.
        var candidate: ?*Voice = null;
        var lowest_priority: f32 = 1000000.0;
        var i: usize = 0;
        while (i < self.active_voice_count) : (i += 1)
        {
            var voice = self.voices[i];
            var priority = voice.getPriority();
            if (priority < lowest_priority)
            {
                lowest_priority = priority;
                candidate = voice;
            }
            else if (priority == lowest_priority)
            {
                // Same priority...
                // The older one should be more suitable for reuse.
                if (voice.voice_length > candidate.?.voice_length)
                {
                    candidate = voice;
                }
            }
        }
        return candidate;
    }

    fn processUnit(self: *Self) void
    {
        var i: usize = 0;

        while (true)
        {
            if (i == self.active_voice_count)
            {
                return;
            }

            if (self.voices[i].processUnit())
            {
                i += 1;
            }
            else
            {
                self.active_voice_count -= 1;

                var tmp = self.voices[i];
                self.voices[i] = self.voices[self.active_voice_count];
                self.voices[self.active_voice_count] = tmp;
            }
        }
    }
};



const Oscillator = struct
{
    const Self = @This();

    // In this class, fixed-point numbers are used for speed-up.
    // A fixed-point number is expressed by Int64, whose lower 24 bits represent the fraction part,
    // and the rest represent the integer part.
    // For clarity, fixed-point number variables have a suffix "_fp".

    const FRAC_BITS = 24;
    const FRAC_UNIT: i64 = 1 << Oscillator.FRAC_BITS;
    const FP_TO_SAMPLE: f32 = 1.0 / (32768.0 * Oscillator.FRAC_UNIT);

    synthesizer: *Synthesizer,

    data: ?[]i16,
    loop_mode: i32,
    sample_rate: i32,
    start: i32,
    end: i32,
    start_loop: i32,
    end_loop: i32,
    root_key: i32,

    tune: f32,
    pitch_change_scale: f32,
    sample_rate_ratio: f32,

    looping: bool,

    position_fp: i64,

    fn init(synthesizer: *Synthesizer) Self
    {
        return Self
        {
            .synthesizer = synthesizer,
            .data = null,
            .loop_mode = 0,
            .sample_rate = 0,
            .start = 0,
            .end = 0,
            .start_loop = 0,
            .end_loop = 0,
            .root_key = 0,
            .tune = 0.0,
            .pitch_change_scale = 0.0,
            .sample_rate_ratio = 0.0,
            .looping = false,
            .position_fp = 0,
        };
    }

    fn startUnit(self: *Self, data: []i16, loop_mode: i32, sample_rate: i32, start: i32, end: i32, start_loop: i32, end_loop: i32, root_key: i32, coarse_tune: i32, fine_tune: i32, scale_tuning: i32) void
    {
        self.data = data;
        self.loop_mode = loop_mode;
        self.sample_sample_rate = sample_rate;
        self.start = start;
        self.end = end;
        self.start_loop = start_loop;
        self.end_loop = end_loop;
        self.root_key = root_key;

        self.tune = coarse_tune + 0.01 * fine_tune;
        self.pitch_change_scale = 0.01 * scale_tuning;
        self.sample_rate_ratio = @intToFloat(f32, sample_rate) / @intToFloat(f32, self.synthesizer_sample_rate);

        if (self.loop_mode == LoopMode.NO_LOOP)
        {
            self.looping = false;
        }
        else
        {
            self.looping = true;
        }

        self.position_fp = @intCast(i64, start) << Oscillator.FRAC_BITS;
    }

    fn releaseUnit(self: *Self) void
    {
        if (self.loop_mode == LoopMode.LOOP_UNTIL_NOTE_OFF)
        {
            self.looping = false;
        }
    }

    fn processUnit(self: *Self, block: []f32, pitch: f32) bool
    {
        const pitch_change = self.pitch_change_scale * (pitch - self.root_key) + self.tune;
        const pitch_ratio = self.sample_rate_ratio * math.pow(f32, 2.0, pitch_change / 12.0);
        return self.fillBlock(block, pitch_ratio);
    }

    fn fillBlock(self: *Self, block: []f32, pitch_ratio: f64) bool
    {
        const pitch_ratio_fp = @floatToInt(i64, @intToFloat(f64, Oscillator.FRAC_UNIT) * pitch_ratio);

        if (self.looping)
        {
            return self.fillBlock_continuous(block, pitch_ratio_fp);
        }
        else
        {
            return self.fillBlock_noLoop(block, pitch_ratio_fp);
        }
    }

    fn fillBlock_noLoop(self: *Self, block: []f32, pitch_ratio_fp: i64) bool
    {
        const data_r = self.data.?;
        const block_length = block.len();

        var t: usize = 0;
        while (t < block_length) : (t += 1)
        {
            const index = @intCast(usize, self.position_fp >> Oscillator.FRAC_BITS);

            if (index >= self.end)
            {
                if (t > 0)
                {
                    var u = t;
                    while (u < block_length) : (u += 1)
                    {
                        block[u] = 0.0;
                    }
                    return true;
                }
                else
                {
                    return false;
                }
            }

            const x1 = @intCast(i64, data_r[index]);
            const x2 = @intCast(i64, data_r[index + 1]);
            const a_fp = self.position_fp & (Oscillator.FRAC_UNIT - 1);
            block[t] = Oscillator.FP_TO_SAMPLE * ((x1 << Oscillator.FRAC_BITS) + a_fp * (x2 - x1));

            self.position_fp += pitch_ratio_fp;
        }

        return true;
    }

    fn fillBlock_continuous(self: *Self, block: []f32, pitch_ratio_fp: i64) bool
    {
        const data_r = self.data.?;
        const block_length = block.len();

        const end_loop_fp = @intCast(i64, self.end_loop) << Oscillator.FRAC_BITS;

        const loop_length = @intCast(i64, self.end_loop - self.start_loop);
        const loop_length_fp = loop_length << Oscillator.FRAC_BITS;

        var t: usize = 0;
        while (t < block_length) : (t += 1)
        {
            if (self.position_fp >= end_loop_fp)
            {
                self.position_fp -= loop_length_fp;
            }

            const index1 = @intCast(usize, self.position_fp >> Oscillator.FRAC_BITS);
            var index2 = index1 + 1;

            if (index2 >= self.end_loop)
            {
                index2 -= loop_length;
            }

            const x1 = @intCast(i64, data_r[index1]);
            const x2 = @intCast(i64, data_r[index2]);
            const a_fp = self.position_fp & (Oscillator.FRAC_UNIT - 1);
            block[t] = Oscillator.FP_TO_SAMPLE * ((x1 << Oscillator.FRAC_BITS) + a_fp * (x2 - x1));

            self.position_fp += pitch_ratio_fp;
        }

        return true;
    }
};



const BiQuadFilter = struct
{
    const Self = @This();

    const RESONANCE_PEAK_OFFSET: f32 = 1.0 - 1.0 / @sqrt(2.0);

    synthesizer: *Synthesizer,

    active: bool,

    a0: f32,
    a1: f32,
    a2: f32,
    a3: f32,
    a4: f32,

    x1: f32,
    x2: f32,
    y1: f32,
    y2: f32,

    fn init(synthesizer: *Synthesizer) Self
    {
        return Self
        {
            .synthesizer = synthesizer,
            .active = false,
            .a0 = 0.0,
            .a1 = 0.0,
            .a2 = 0.0,
            .a3 = 0.0,
            .a4 = 0.0,
            .x1 = 0.0,
            .x2 = 0.0,
            .y1 = 0.0,
            .y2 = 0.0,
        };
    }

    fn clearBuffer(self: *Self) void
    {
        self.x1 = 0.0;
        self.x2 = 0.0;
        self.y1 = 0.0;
        self.y2 = 0.0;
    }

    fn setLowPassFilter(self: *Self, cutoff_frequency: f32, resonance: f32) void
    {
        if (cutoff_frequency < 0.499 * self.sample_rate)
        {
            self.active = true;

            // This equation gives the Q value which makes the desired resonance peak.
            // The error of the resultant peak height is less than 3%.
            const q = resonance - BiQuadFilter.RESONANCE_PEAK_OFFSET / (1.0 + 6.0 * (resonance - 1.0));

            const w = 2.0 * math.pi * cutoff_frequency / @intToFloat(f32, self.sample_rate);
            const cosw = @cos(w);
            const alpha = @sin(w) / (2.0 * q);

            const b0 = (1.0 - cosw) / 2.0;
            const b1 = 1.0 - cosw;
            const b2 = (1.0 - cosw) / 2.0;
            const a0 = 1.0 + alpha;
            const a1 = -2.0 * cosw;
            const a2 = 1.0 - alpha;

            self.setCoefficients(a0, a1, a2, b0, b1, b2);
        }
        else
        {
            self.active = false;
        }
    }

    fn processUnit(self: *Self, block: []f32) void
    {
        const block_length = block.len;

        if (self.active)
        {
            var t: usize = 0;
            while (t < block_length) : (t += 1)
            {
                const input = block[t];
                const output = self.a0 * input + self.a1 * self.x1 + self.a2 * self.x2 - self.a3 * self.y1 - self.a4 * self.y2;

                self.x2 = self.x1;
                self.x1 = input;
                self.y2 = self.y1;
                self.y1 = output;

                block[t] = output;
            }
        }
        else
        {
            self.x2 = block[block_length - 2];
            self.x1 = block[block_length - 1];
            self.y2 = self.x2;
            self.y1 = self.x1;
        }
    }

    fn set_coefficients(self: *Self, a0: f32, a1: f32, a2: f32, b0: f32, b1: f32, b2: f32) void
    {
        self.a0 = b0 / a0;
        self.a1 = b1 / a0;
        self.a2 = b2 / a0;
        self.a3 = a1 / a0;
        self.a4 = a2 / a0;
    }
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

    fn startUnit(self: *Self, delay: f32, attack: f32, hold: f32, decay: f32, sustain: f32, release: f32) void
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

    fn releaseUnit(self: *Self) void
    {
        self.stage = EnvelopeStage.RELEASE;
        self.release_start_time = @intToFloat(f64, self.processed_sample_count) / @intToFloat(f64, self.synthesizer.sample_rate);
        self.release_level = self.value;
    }

    fn processUnit(self: *Self, sample_count: i32) bool
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

    fn getValue(self: *Self) f32
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

    fn startUnit(self: *Self, delay: f32, attack: f32, hold: f32, decay: f32, sustain: f32, release: f32) void
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

    fn releaseUnit(self: *Self) void
    {
        self.stage = EnvelopeStage.RELEASE;
        self.release_end_time += @intToFloat(f64, self.processed_sample_count) / @intToFloat(f64, self.synthesizer.sample_rate);
        self.release_level = self.value;
    }

    fn processUnit(self: *Self, sample_count: i32) void
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

    fn getValue(self: *Self) f32
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

    synthesizer: *Synthesizer,

    active: bool,

    delay: f64,
    period: f64,

    processed_sample_count: i32,
    value: f32,

    fn init(synthesizer: *Synthesizer) Self
    {
        return Self
        {
            .synthesizer = synthesizer,
            .active = false,
            .delay = 0.0,
            .period = 0.0,
            .processed_sample_count = 0,
            .value = 0.0,
        };
    }

    fn startUnit(self: *Self, delay: f32, frequency: f32) void
    {
        if (frequency > 1.0E-3)
        {
            self.active = true;

            self.delay = delay;
            self.period = 1.0 / frequency;

            self.processed_sample_count = 0;
            self.value = 0.0;
        }
        else
        {
            self.active = false;
            self.value = 0.0;
        }
    }

    fn processUnit(self: *Self) void
    {
        if (!self.active)
        {
            return;
        }

        self.processed_sample_count += self.synthesizer.block_size;

        const current_time = @intToFloat(f64, self.processed_sample_count) / @intToFloat(f64, self.sample_rate);

        if (current_time < self.delay)
        {
            self.value = 0.0;
        }
        else
        {
            const phase = ((current_time - self.delay) % self.period) / self.period;
            if (phase < 0.25)
            {
                self.value = (4.0 * phase);
            }
            else if (phase < 0.75)
            {
                self.value = (4.0 * (0.5 - phase));
            }
            else
            {
                self.value = (4.0 * (phase - 1.0));
            }
        }
    }

    fn getValue(self: *Self) f32
    {
        return self.value;
    }
};



const Channel = struct
{
    const Self = @This();

    is_percussion_channel: bool,

    bank_number: i32,
    patch_number: i32,

    modulation: i16,
    volume: i16,
    pan: i16,
    expression: i16,
    hold_pedal: bool,

    reverb_send: u8,
    chorus_send: u8,

    rpn: i16,
    pitch_bend_range: i16,
    coarse_tune: i16,
    fine_tune: i16,

    pitch_bend: f32,

    fn init(is_percussion_channel: bool) Self
    {
        var channel = Self
        {
            .is_percussion_channel = is_percussion_channel,
            .bank_number = 0,
            .patch_number = 0,
            .modulation = 0,
            .volume = 0,
            .pan = 0,
            .expression = 0,
            .hold_pedal = false,
            .reverb_send = 0,
            .chorus_send = 0,
            .rpn = 0,
            .pitch_bend_range = 0,
            .coarse_tune = 0,
            .fine_tune = 0,
            .pitch_bend = 0.0,
        };

        channel.reset();

        return channel;
    }

    fn reset(self: *Self) void
    {
        self.bank_number = if (self.is_percussion_channel) 128 else 0;
        self.patch_number = 0;

        self.modulation = 0;
        self.volume = 100 << 7;
        self.pan = 64 << 7;
        self.expression = 127 << 7;
        self.hold_pedal = false;

        self.reverb_send = 40;
        self.chorus_send = 0;

        self.rpn = -1;
        self.pitch_bend_range = 2 << 7;
        self.coarse_tune = 0;
        self.fine_tune = 8192;

        self.pitch_bend = 0.0;
    }

    fn resetAllControllers(self: *Self) void
    {
        self.modulation = 0;
        self.expression = 127 << 7;
        self.hold_pedal = false;

        self.rpn = -1;

        self.pitch_bend = 0.0;
    }

    fn setBank(self: *Self, value: i32) void
    {
        self.bank_number = value;

        if (self.is_percussion_channel)
        {
            self.bank_number += 128;
        }
    }

    fn setPatch(self: *Self, value: i32) void
    {
        self.patch_number = value;
    }

    fn setModulationCoarse(self: *Self, value: i32) void
    {
        self.modulation = (self.modulation & 0x7F) | (value << 7);
    }

    fn setModulationFine(self: *Self, value: i32) void
    {
        self.modulation = ((self.modulation & 0xFF80) | value);
    }

    fn setVolumeCoarse(self: *Self, value: i32) void
    {
        self.volume = (self.volume & 0x7F) | (value << 7);
    }

    fn setVolumeFine(self: *Self, value: i32) void
    {
        self.volume = ((self.volume & 0xFF80) | value);
    }

    fn setPanCoarse(self: *Self, value: i32) void
    {
        self.pan = (self.pan & 0x7F) | (value << 7);
    }

    fn setPanFine(self: *Self, value: i32) void
    {
        self.pan = ((self.pan & 0xFF80) | value);
    }

    fn setExpressionCoarse(self: *Self, value: i32) void
    {
        self.expression = (self.expression & 0x7F) | (value << 7);
    }

    fn setExpressionFine(self: *Self, value: i32) void
    {
        self.expression = ((self.expression & 0xFF80) | value);
    }

    fn setHoldPedal(self: *Self, value: i32) void
    {
        self.hold_pedal = value >= 64;
    }

    fn setReverbSend(self: *Self, value: i32) void
    {
        self.reverb_send = value;
    }

    fn setChorusSend(self: *Self, value: i32) void
    {
        self.chorus_send = value;
    }

    fn setRpnCoarse(self: *Self, value: i32) void
    {
        self.rpn = (self.rpn & 0x7F) | (value << 7);
    }

    fn setRpnFine(self: *Self, value: i32) void
    {
        self.rpn = ((self.rpn & 0xFF80) | value);
    }

    fn dataEntryCoarse(self: *Self, value: i32) void
    {
        if (self.rpn == 0)
        {
            self.pitch_bend_range = (self.pitch_bend_range & 0x7F) | (value << 7);
        }
        else if (self.rpn == 1)
        {
            self.fine_tune = (self.fine_tune & 0x7F) | (value << 7);
        }
        else if (self.rpn == 2)
        {
            self.coarse_tune = (value - 64);
        }
    }

    fn dataEntryFine(self: *Self, value: i32) void
    {
        if (self.rpn == 0)
        {
            self.pitch_bend_range = ((self.pitch_bend_range & 0xFF80) | value);
        }
        else if (self.rpn == 1)
        {
            self.fine_tune = ((self.fine_tune & 0xFF80) | value);
        }
    }

    fn setPitchBend(self: *Self, value1: i32, value2: i32) void
    {
        self.pitch_bend = (1.0 / 8192.0) * ((value1 | (value2 << 7)) - 8192.0);
    }

    fn getBankNumber(self: *const Self) i32
    {
        return self.bank_number;
    }

    fn getPatchNumber(self: *const Self) i32
    {
        return self.patch_number;
    }

    fn getModulation(self: *const Self) f32
    {
        return (50.0 / 16383.0) * self.modulation;
    }

    fn getVolume(self: *const Self) f32
    {
        return (1.0 / 16383.0) * self.volume;
    }

    fn getPan(self: *const Self) f32
    {
        return (100.0 / 16383.0) * @intToFloat(f32, self.pan) - 50.0;
    }

    fn getExpression(self: *const Self) f32
    {
        return (1.0 / 16383.0) * @intToFloat(f32, self.expression);
    }

    fn getHoldPedal(self: *const Self) bool
    {
        return self.hold_pedal;
    }

    fn getReverbSend(self: *const Self) f32
    {
        return (1.0 / 127.0) * @intToFloat(f32, self.reverb_send);
    }

    fn getChorusSend(self: *const Self) f32
    {
        return (1.0 / 127.0) * @intToFloat(f32, self.chorus_send);
    }

    fn getPitchBendRange(self: *const Self) f32
    {
        return @intToFloat(f32, self.pitch_bend_range >> 7) + 0.01 * @intToFloat(f32, self.pitch_bend_range & 0x7F);
    }

    fn getTune(self: *const Self) f32
    {
        return @intToFloat(f32, self.coarse_tune) + (1.0 / 8192.0) * @intToFloat(f32, self.fine_tune - 8192);
    }

    fn getPitchBend(self: *const Self) f32
    {
        return self.get_pitch_bend_range() * self.pitch_bend;
    }
};

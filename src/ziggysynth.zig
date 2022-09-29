const std = @import("std");
const mem = std.mem;
const Allocator = mem.Allocator;

const ZiggySynthError = error {
    InvalidSoundFont,
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

    pub fn init(allocator: Allocator, reader: anytype) !Self
    {
        var wave_data: ?[]i16 = null;
        var sample_headers: ?[]SampleHeader = null;

        errdefer
        {
            if (wave_data) |value| allocator.free(value);
            if (sample_headers) |value| allocator.free(value);
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

        return Self
        {
            .allocator = allocator,
            .wave_data = wave_data.?,
            .sample_headers = sample_headers.?,
        };
    }

    pub fn deinit(self: Self) void
    {
        self.allocator.free(self.wave_data);
        self.allocator.free(self.sample_headers);
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

        return Self
        {
            .sample_headers = sample_headers.?,
        };
    }
};

const Generator = struct
{
    const Self = @This();

    generator_type: u16,
    value: u16,

    fn init(reader: anytype) !Self
    {
        const generator_type = try BinaryReader.read(u16, reader);
        const value = try BinaryReader.read(u16, reader);

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
                instruments[i].zone_end_index = instruments[i + 1].zone_start_index - 1;
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

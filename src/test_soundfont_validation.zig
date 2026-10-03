const std = @import("std");
const SoundFont = @import("ziggysynth.zig").SoundFont;
const Allocator = std.mem.Allocator;

const Options = struct {
    wave_data: ?[]const u8 = null,
    duplicate: ?[4]u8 = null,
    info_type: [4]u8 = "INFO".*,
    info_id: ?[4]u8 = null,
    start: i32 = 0,
    end: i32 = 63,
    start_loop: i32 = 0,
    end_loop: i32 = 32,
    start_coarse_offset: i16 = 0,
    start_offset: i16 = 0,
    instrument_id: i16 = 0,
    sample_id: i16 = 0,
    preset_zone_end: u16 = 1,
    instrument_zone_end: u16 = 1,
};

fn appendChunk(allocator: Allocator, buffer: *std.ArrayList(u8), id: [4]u8, data: []const u8) !void {
    try buffer.appendSlice(allocator, &id);
    var size: [4]u8 = undefined;
    std.mem.writeInt(u32, &size, @intCast(data.len), .little);
    try buffer.appendSlice(allocator, &size);
    try buffer.appendSlice(allocator, data);
}

fn appendParameter(allocator: Allocator, buffer: *std.ArrayList(u8), id: [4]u8, data: []const u8, duplicate: ?[4]u8) !void {
    try appendChunk(allocator, buffer, id, data);
    if (duplicate) |value| {
        if (std.mem.eql(u8, &value, &id)) try appendChunk(allocator, buffer, id, data);
    }
}

// A small, complete SF2 exercises the public loader and all its cleanup paths.
fn makeSoundFont(allocator: Allocator, options: Options) ![]u8 {
    var info: std.ArrayList(u8) = .empty;
    defer info.deinit(allocator);
    try info.appendSlice(allocator, &options.info_type);
    if (options.info_id) |id| try appendChunk(allocator, &info, id, "test");

    var sdta: std.ArrayList(u8) = .empty;
    defer sdta.deinit(allocator);
    try sdta.appendSlice(allocator, "sdta");
    const default_wave_data: [128]u8 = @splat(0);
    try appendParameter(allocator, &sdta, "smpl".*, options.wave_data orelse &default_wave_data, options.duplicate);

    var phdr: [76]u8 = @splat(0);
    std.mem.writeInt(u16, phdr[62..64], options.preset_zone_end, .little);
    var pbag: [8]u8 = @splat(0);
    std.mem.writeInt(u16, pbag[4..6], 1, .little);
    var pgen: [8]u8 = @splat(0);
    std.mem.writeInt(u16, pgen[0..2], 41, .little); // instrument
    std.mem.writeInt(i16, pgen[2..4], options.instrument_id, .little);
    var inst: [44]u8 = @splat(0);
    std.mem.writeInt(u16, inst[42..44], options.instrument_zone_end, .little);
    var ibag: [8]u8 = @splat(0);
    std.mem.writeInt(u16, ibag[4..6], 3, .little);
    var igen: [16]u8 = @splat(0);
    std.mem.writeInt(u16, igen[0..2], 4, .little); // startAddrsCoarseOffset
    std.mem.writeInt(i16, igen[2..4], options.start_coarse_offset, .little);
    std.mem.writeInt(u16, igen[4..6], 0, .little); // startAddrsOffset
    std.mem.writeInt(i16, igen[6..8], options.start_offset, .little);
    std.mem.writeInt(u16, igen[8..10], 53, .little); // sampleID
    std.mem.writeInt(i16, igen[10..12], options.sample_id, .little);
    var shdr: [138]u8 = @splat(0); // two samples and the terminator
    std.mem.writeInt(i32, shdr[20..24], options.start, .little);
    std.mem.writeInt(i32, shdr[24..28], options.end, .little);
    std.mem.writeInt(i32, shdr[28..32], options.start_loop, .little);
    std.mem.writeInt(i32, shdr[32..36], options.end_loop, .little);
    std.mem.writeInt(i32, shdr[36..40], 44100, .little);

    var pdta: std.ArrayList(u8) = .empty;
    defer pdta.deinit(allocator);
    try pdta.appendSlice(allocator, "pdta");
    try appendParameter(allocator, &pdta, "phdr".*, &phdr, options.duplicate);
    try appendParameter(allocator, &pdta, "pbag".*, &pbag, options.duplicate);
    try appendParameter(allocator, &pdta, "pgen".*, &pgen, options.duplicate);
    try appendParameter(allocator, &pdta, "inst".*, &inst, options.duplicate);
    try appendParameter(allocator, &pdta, "ibag".*, &ibag, options.duplicate);
    try appendParameter(allocator, &pdta, "igen".*, &igen, options.duplicate);
    try appendParameter(allocator, &pdta, "shdr".*, &shdr, options.duplicate);

    var body: std.ArrayList(u8) = .empty;
    defer body.deinit(allocator);
    try body.appendSlice(allocator, "sfbk");
    try appendChunk(allocator, &body, "LIST".*, info.items);
    try appendChunk(allocator, &body, "LIST".*, sdta.items);
    try appendChunk(allocator, &body, "LIST".*, pdta.items);

    var result: std.ArrayList(u8) = .empty;
    errdefer result.deinit(allocator);
    try appendChunk(allocator, &result, "RIFF".*, body.items);
    return result.toOwnedSlice(allocator);
}

fn loadSoundFont(allocator: Allocator, data: []const u8) !void {
    var reader = std.Io.Reader.fixed(data);
    var sound_font = try SoundFont.init(allocator, &reader);
    defer sound_font.deinit();
}

fn expectInvalid(options: Options) !void {
    const data = try makeSoundFont(std.testing.allocator, options);
    defer std.testing.allocator.free(data);
    try std.testing.expectError(error.InvalidSoundFont, loadSoundFont(std.testing.allocator, data));
}

test "SoundFont rejects odd, empty, short and compressed sample data" {
    try expectInvalid(.{ .wave_data = "\x11\x22\x33" });
    try expectInvalid(.{ .wave_data = "" });
    try expectInvalid(.{ .wave_data = "\x11\x22" });
    try expectInvalid(.{ .wave_data = "OggS" });
}

test "SoundFont rejects duplicate allocating chunks without leaking" {
    const ids = [_][4]u8{ "smpl".*, "phdr".*, "pbag".*, "pgen".*, "inst".*, "ibag".*, "igen".*, "shdr".* };
    for (ids) |id| try expectInvalid(.{ .duplicate = id });
}

test "SoundFont validates INFO type and subchunk ids" {
    try expectInvalid(.{ .info_type = "oops".* });
    try expectInvalid(.{ .info_id = "oops".* });
    const data = try makeSoundFont(std.testing.allocator, .{ .info_id = "INAM".* });
    defer std.testing.allocator.free(data);
    try loadSoundFont(std.testing.allocator, data);
}

test "SoundFont rejects empty preset and instrument zones" {
    try expectInvalid(.{ .preset_zone_end = 0 });
    try expectInvalid(.{ .instrument_zone_end = 0 });
}

test "SoundFont rejects negative and out of range instrument and sample ids" {
    try expectInvalid(.{ .instrument_id = -1 });
    try expectInvalid(.{ .instrument_id = 1 });
    try expectInvalid(.{ .sample_id = -1 });
    try expectInvalid(.{ .sample_id = 2 });
}

test "SoundFont validates sample addresses including generator offsets" {
    try expectInvalid(.{ .start = -1 });
    try expectInvalid(.{ .end = -1 });
    try expectInvalid(.{ .end = 64 });
    try expectInvalid(.{ .start = 63 });
    try expectInvalid(.{ .start_loop = -1 });
    try expectInvalid(.{ .end_loop = -1 });
    try expectInvalid(.{ .end_loop = 64 });
    try expectInvalid(.{ .start_offset = -1 });
    try expectInvalid(.{ .start = std.math.maxInt(i32), .start_coarse_offset = 32767 });
}

test "SoundFont sanity checks preserve rustysynth's acceptance of invalid loop order" {
    // Rustysynth handles these in its oscillator, not its SoundFont validation.
    // Porting oscillator behavior is outside this error-checking change.
    for ([_]Options{
        .{ .start_loop = 0, .end_loop = 0 },
        .{ .start_loop = 32, .end_loop = 16 },
    }) |options| {
        const data = try makeSoundFont(std.testing.allocator, options);
        defer std.testing.allocator.free(data);
        try loadSoundFont(std.testing.allocator, data);
    }
}

test "SoundFont cleans up truncated input" {
    const data = try makeSoundFont(std.testing.allocator, .{});
    defer std.testing.allocator.free(data);
    for (0..data.len) |length| {
        try std.testing.expectError(error.EndOfStream, loadSoundFont(std.testing.allocator, data[0..length]));
    }
}

test "SoundFont cleans up every initialization allocation failure" {
    const data = try makeSoundFont(std.testing.allocator, .{});
    defer std.testing.allocator.free(data);
    try std.testing.checkAllAllocationFailures(std.testing.allocator, loadSoundFont, .{data});
}

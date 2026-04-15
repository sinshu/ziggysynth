const std = @import("std");
const ziggysynth = @import("ziggysynth.zig");
const debug = std.debug;
const fs = std.fs;
const heap = std.heap;
const mem = std.mem;
const Allocator = mem.Allocator;
const SoundFont = ziggysynth.SoundFont;
const Synthesizer = ziggysynth.Synthesizer;
const SynthesizerSettings = ziggysynth.SynthesizerSettings;
const MidiFile = ziggysynth.MidiFile;
const MidiFileSequencer = ziggysynth.MidiFileSequencer;

pub fn main(init: std.process.Init) !void {
    var da = heap.DebugAllocator(.{}){};
    const allocator = da.allocator();
    defer debug.assert(da.deinit() == .ok);

    if (@sizeOf(usize) == 4) {
        std.debug.print("Running on x86\n", .{});
    }
    if (@sizeOf(usize) == 8) {
        std.debug.print("Running on x64\n", .{});
    }

    std.debug.print("Simple chord...", .{});
    try simple_chord(init.io, allocator);
    std.debug.print("OK\n", .{});

    std.debug.print("MIDI file synthesis...", .{});
    try flourish(init.io, allocator);
    std.debug.print("OK\n", .{});
}

fn simple_chord(io: std.Io, allocator: Allocator) !void {
    // Load the SoundFont.
    var sf2 = try std.Io.Dir.cwd().openFile(io, "TimGM6mb.sf2", .{});
    defer sf2.close(io);
    var sf2_buffer: [1024]u8 = undefined;
    var sf2_reader = sf2.reader(io, &sf2_buffer);
    var sound_font = try SoundFont.init(allocator, &sf2_reader.interface);
    defer sound_font.deinit();

    // Create the synthesizer.
    var settings = SynthesizerSettings.init(44100);
    var synthesizer = try Synthesizer.init(allocator, &sound_font, &settings);
    defer synthesizer.deinit();

    // Play some notes (middle C, E, G).
    synthesizer.noteOn(0, 60, 100);
    synthesizer.noteOn(0, 64, 100);
    synthesizer.noteOn(0, 67, 100);

    // The output buffer (3 seconds).
    const sample_count: usize = @intCast(3 * settings.sample_rate);
    const left: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(left);
    const right: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(right);

    // Render the waveform.
    synthesizer.render(left, right);

    // Write the waveform as a PMC file.
    try write_pcm(io, allocator, left, right, "simple_chord.pcm");
}

fn flourish(io: std.Io, allocator: Allocator) !void {
    // Load the SoundFont.
    var sf2 = try std.Io.Dir.cwd().openFile(io, "TimGM6mb.sf2", .{});
    defer sf2.close(io);
    var sf2_buffer: [1024]u8 = undefined;
    var sf2_reader = sf2.reader(io, &sf2_buffer);
    var sound_font = try SoundFont.init(allocator, &sf2_reader.interface);
    defer sound_font.deinit();

    // Create the synthesizer.
    var settings = SynthesizerSettings.init(44100);
    var synthesizer = try Synthesizer.init(allocator, &sound_font, &settings);
    defer synthesizer.deinit();

    // Load the MIDI file.
    var mid = try std.Io.Dir.cwd().openFile(io, "flourish.mid", .{});
    defer mid.close(io);
    var mid_buffer: [1024]u8 = undefined;
    var mid_reader = mid.reader(io, &mid_buffer);
    var midi_file = try MidiFile.init(allocator, &mid_reader.interface);
    defer midi_file.deinit();

    // Create the sequencer.
    var sequencer = MidiFileSequencer.init(&synthesizer);

    // Play the MIDI file.
    sequencer.play(&midi_file, false);

    // The output buffer.
    const sample_count = @as(f64, @floatFromInt(settings.sample_rate)) * midi_file.getLength();
    const left: []f32 = try allocator.alloc(f32, @intFromFloat(sample_count));
    defer allocator.free(left);
    const right: []f32 = try allocator.alloc(f32, @intFromFloat(sample_count));
    defer allocator.free(right);

    // Render the waveform.
    sequencer.render(left, right);

    // Write the waveform as a PMC file.
    try write_pcm(io, allocator, left, right, "flourish.pcm");
}

fn write_pcm(io: std.Io, allocator: Allocator, left: []f32, right: []f32, path: []const u8) !void {
    var max: f32 = 0.0;
    for (0..left.len) |t| {
        if (@abs(left[t]) > max) {
            max = @abs(left[t]);
        }
        if (@abs(right[t]) > max) {
            max = @abs(right[t]);
        }
    }
    const a = 0.99 / max;

    var buf: []i16 = try allocator.alloc(i16, 2 * left.len);
    defer allocator.free(buf);
    for (0..left.len) |t| {
        const offset = 2 * t;
        buf[offset + 0] = @as(i16, @intFromFloat(a * left[t] * 32768.0));
        buf[offset + 1] = @as(i16, @intFromFloat(a * right[t] * 32768.0));
    }

    var pcm = try std.Io.Dir.cwd().createFile(io, path, .{});
    defer pcm.close(io);
    var pcm_buffer: [1024]u8 = undefined;
    var pcm_writer = pcm.writer(io, &pcm_buffer);
    try pcm_writer.interface.writeAll(@as([*]u8, @ptrCast(buf.ptr))[0..(4 * left.len)]);
}

test {
    _ = @import("test_timgm6mb_sample.zig");
    _ = @import("test_timgm6mb_preset.zig");
    _ = @import("test_timgm6mb_instrument.zig");
    _ = @import("test_musescore_sample.zig");
    _ = @import("test_musescore_preset.zig");
    _ = @import("test_musescore_instrument.zig");
}

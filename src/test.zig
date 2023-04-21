const std = @import("std");
const ziggysynth = @import("ziggysynth.zig");
const debug = std.debug;
const fs = std.fs;
const heap = std.heap;
const io = std.io;
const mem = std.mem;
const Allocator = mem.Allocator;
const SoundFont = ziggysynth.SoundFont;
const Synthesizer = ziggysynth.Synthesizer;
const SynthesizerSettings = ziggysynth.SynthesizerSettings;
const MidiFile = ziggysynth.MidiFile;
const MidiFileSequencer = ziggysynth.MidiFileSequencer;

pub fn main() !void {
    const stdout_file = io.getStdOut().writer();
    var bw = io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var gpa = heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer debug.assert(!gpa.deinit());

    try stdout.print("Simple chord...", .{});
    try bw.flush();
    try simple_chord(allocator);
    try stdout.print("OK\n", .{});
    try bw.flush();

    try stdout.print("MIDI file synthesis...", .{});
    try bw.flush();
    try flourish(allocator);
    try stdout.print("OK\n", .{});
    try bw.flush();
}

fn simple_chord(allocator: Allocator) !void {
    // Load the SoundFont.
    var sf2 = try fs.cwd().openFile("TimGM6mb.sf2", .{});
    defer sf2.close();
    var sound_font = try SoundFont.init(allocator, sf2.reader());
    defer sound_font.deinit();

    // Create the synthesizer.
    var settings = SynthesizerSettings.init(44100);
    var synthesizer = try Synthesizer.init(allocator, sound_font, settings);
    defer synthesizer.deinit();

    // Play some notes (middle C, E, G).
    synthesizer.noteOn(0, 60, 100);
    synthesizer.noteOn(0, 64, 100);
    synthesizer.noteOn(0, 67, 100);

    // The output buffer (3 seconds).
    const sample_count = @intCast(usize, 3 * settings.sample_rate);
    var left: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(left);
    var right: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(right);

    // Render the waveform.
    synthesizer.render(left, right);

    // Write the waveform as a PMC file.
    try write_pcm(allocator, left, right, "simple_chord.pcm");
}

fn flourish(allocator: Allocator) !void {
    // Load the SoundFont.
    var sf2 = try fs.cwd().openFile("TimGM6mb.sf2", .{});
    defer sf2.close();
    var sound_font = try SoundFont.init(allocator, sf2.reader());
    defer sound_font.deinit();

    // Create the synthesizer.
    var settings = SynthesizerSettings.init(44100);
    var synthesizer = try Synthesizer.init(allocator, sound_font, settings);
    defer synthesizer.deinit();

    // Load the MIDI file.
    var mid = try fs.cwd().openFile("flourish.mid", .{});
    defer mid.close();
    var midi_file = try MidiFile.init(allocator, mid.reader());
    defer midi_file.deinit();

    // Create the sequencer.
    var sequencer = MidiFileSequencer.init(&synthesizer);

    // Play the MIDI file.
    sequencer.play(midi_file, false);

    // The output buffer.
    const sample_count = @floatToInt(usize, @intToFloat(f64, settings.sample_rate) * midi_file.getLength());
    var left: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(left);
    var right: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(right);

    // Render the waveform.
    sequencer.render(left, right);

    // Write the waveform as a PMC file.
    try write_pcm(allocator, left, right, "flourish.pcm");
}

fn write_pcm(allocator: Allocator, left: []f32, right: []f32, path: []const u8) !void {
    var max: f32 = 0.0;
    {
        var t: usize = 0;
        while (t < left.len) : (t += 1) {
            if (@fabs(left[t]) > max) {
                max = @fabs(left[t]);
            }
            if (@fabs(right[t]) > max) {
                max = @fabs(right[t]);
            }
        }
    }
    const a = 0.99 / max;

    var buf: []i16 = try allocator.alloc(i16, 2 * left.len);
    defer allocator.free(buf);
    {
        var t: usize = 0;
        while (t < left.len) : (t += 1) {
            const offset = 2 * t;
            buf[offset + 0] = @floatToInt(i16, a * left[t] * 32768.0);
            buf[offset + 1] = @floatToInt(i16, a * right[t] * 32768.0);
        }
    }

    var pcm = try fs.cwd().createFile(path, .{});
    defer pcm.close();
    var writer = pcm.writer();
    try writer.writeAll(@ptrCast([*]u8, buf.ptr)[0..(4 * left.len)]);
}

test {
    _ = @import("test_timgm6mb_sample.zig");
    _ = @import("test_timgm6mb_preset.zig");
    _ = @import("test_timgm6mb_instrument.zig");
    _ = @import("test_musescore_sample.zig");
    _ = @import("test_musescore_preset.zig");
    _ = @import("test_musescore_instrument.zig");
}

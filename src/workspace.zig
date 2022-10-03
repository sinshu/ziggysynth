const std = @import("std");
const ziggysynth = @import("ziggysynth.zig");
const mem = std.mem;
const Allocator = mem.Allocator;
const AutoHashMap = std.AutoHashMap;

pub fn main() !void
{
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer std.debug.assert(!gpa.deinit());

    var file = try std.fs.cwd().openFile("TimGM6mb.sf2", .{});
    defer file.close();
    var sf = try ziggysynth.SoundFont.init(allocator, file.reader());
    defer sf.deinit();

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("========== START ==========\n", .{});

    var settings = ziggysynth.SynthesizerSettings.init(44100);
    var synthesizer = try ziggysynth.Synthesizer.init(allocator, sf, settings);
    defer synthesizer.deinit();

    // Play some notes (middle C, E, G).
    synthesizer.noteOn(0, 60, 100);
    synthesizer.noteOn(0, 64, 100);
    synthesizer.noteOn(0, 67, 100);

    // The output buffer (3 seconds).
    const sample_count = 3 * @intCast(usize, settings.sample_rate);
    var left: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(left);
    var right: []f32 = try allocator.alloc(f32, sample_count);
    defer allocator.free(right);

    synthesizer.render(left, right);

    try write_pcm(allocator, left, right, "out.pcm");

    try stdout.print("========== END ==========\n", .{});

    try bw.flush(); // don't forget to flush!
}

fn write_pcm(allocator: Allocator, left: []f32, right: []f32, path: []const u8) !void
{
    var max: f32 = 0.0;
    {
        var t: usize = 0;
        while (t < left.len) : (t += 1)
        {
            if (@fabs(left[t]) > max) { max = @fabs(left[t]); }
            if (@fabs(right[t]) > max) { max = @fabs(right[t]); }
        }
    }
    const a = 0.99 / max;

    var buf: []i16 = try allocator.alloc(i16, 2 * left.len);
    defer allocator.free(buf);
    {
        var t: usize = 0;
        while (t < left.len) : (t += 1)
        {
            const offset = 2 * t;
            buf[offset + 0] = @floatToInt(i16, a * left[t] * 32768.0);
            buf[offset + 1] = @floatToInt(i16, a * right[t] * 32768.0);
        }
    }

    var pcm = try std.fs.cwd().createFile(path, .{});
    defer pcm.close();
    var writer = pcm.writer();
    try writer.writeAll(@ptrCast([*]u8, buf.ptr)[0..(4 * left.len)]);
}

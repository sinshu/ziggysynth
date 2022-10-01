const std = @import("std");
const ziggysynth = @import("ziggysynth.zig");

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

    synthesizer.processMidiMessage(0,0,0,0);

    try stdout.print("========== END ==========\n", .{});

    try bw.flush(); // don't forget to flush!
}

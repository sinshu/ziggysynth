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

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    var i: usize = 0;
    while (i < sf.sample_headers.len) : (i += 1)
    {
        const name = sf.sample_headers[i].name;
        try stdout.print("{s}\n", .{name});
    }

    try bw.flush(); // don't forget to flush!
}

const std = @import("std");

test "first test"
{
    var s = "hello";
    var sub = s[0..4];
    std.debug.assert(std.mem.eql(u8, sub, "hell"));
}

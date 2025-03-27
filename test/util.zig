const std = @import("std");
const zexp = @import("zexp");

pub fn unit_test(buf: *std.ArrayList(u8), t: type, value: t, expect: []const u8) !void {
    try zexp.sexp_of(t)(buf.writer().any(), value);
    try std.testing.expectEqualStrings(expect, buf.items);
    buf.clearRetainingCapacity();
}

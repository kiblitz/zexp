const std = @import("std");
const zexp = @import("zexp");

// Hack including inline because [gpa] must remain on stack
pub inline fn make_buffer() std.ArrayList(u8) {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    return std.ArrayList(u8).init(allocator);
}

pub fn unit_test(buf: *std.ArrayList(u8), value: anytype, expect: []const u8) !void {
    try zexp.sexp_of(buf.writer().any(), value);
    try std.testing.expectEqualStrings(expect, buf.items);
    buf.clearRetainingCapacity();
}

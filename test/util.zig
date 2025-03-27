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

pub const simple_untagged_enum = enum {
    foo,
    bar,
    qux,
    corge,
    thud,
    fred,
};

pub const simple_named_tagged_enum = union(simple_untagged_enum) {
    foo: i32,
    bar: bool,
    qux,
    corge,
    thud: []const u8,
    fred,
};

pub const simple_anonymous_tagged_enum = union(enum) {
    foo: i32,
    bar: bool,
    qux,
    corge,
    thud: []const u8,
    fred,
};

pub const simple_struct = struct {
    foo: i32,
    bar: bool,
    qux: ?bool,
    corge: ?f64,
    thud: []const u8,
    fred: [3]i8,
};

pub const simple_struct_inst = simple_struct{
    .foo = 7,
    .bar = false,
    .qux = null,
    .corge = 3.14159265,
    .thud = "gl",
    .fred = [3]i8{ 1, 2, 3 },
};

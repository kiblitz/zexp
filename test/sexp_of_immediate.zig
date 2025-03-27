const std = @import("std");

const util = @import("util.zig");

test "numerical -- signed int" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buf = std.ArrayList(u8).init(allocator);

    try util.unit_test(
        &buf,
        i32,
        3,
        "3",
    );
    try util.unit_test(
        &buf,
        i32,
        -19,
        "-19",
    );
    try util.unit_test(
        &buf,
        i32,
        std.math.maxInt(i32),
        "2147483647",
    );
    try util.unit_test(
        &buf,
        i32,
        std.math.minInt(i32),
        "-2147483648",
    );
}

test "numerical -- unsigned int" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buf = std.ArrayList(u8).init(allocator);

    try util.unit_test(
        &buf,
        u32,
        3,
        "3",
    );
}

test "numerical -- floating point" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buf = std.ArrayList(u8).init(allocator);

    try util.unit_test(
        &buf,
        f32,
        0,
        "0",
    );
    try util.unit_test(
        &buf,
        f16,
        2.71,
        "2.71",
    );
    try util.unit_test(
        &buf,
        f64,
        -3.14159265,
        "-3.14159265",
    );
}

test "bool" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var buf = std.ArrayList(u8).init(allocator);

    try util.unit_test(
        &buf,
        bool,
        true,
        "true",
    );
    try util.unit_test(
        &buf,
        bool,
        false,
        "false",
    );
}

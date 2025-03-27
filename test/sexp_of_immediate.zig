const std = @import("std");

const util = @import("util.zig");

test "numerical -- signed int" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        3,
        "3",
    );
    try util.unit_test(
        &buf,
        -19,
        "-19",
    );
    try util.unit_test(
        &buf,
        std.math.maxInt(i32),
        "2147483647",
    );
    try util.unit_test(
        &buf,
        std.math.minInt(i32),
        "-2147483648",
    );
}

test "numerical -- unsigned int" {
    var buf = util.make_buffer();
    defer buf.deinit();

    try util.unit_test(
        &buf,
        @as(u32, 3),
        "3",
    );
}

test "numerical -- floating point" {
    var buf = util.make_buffer();
    defer buf.deinit();

    try util.unit_test(
        &buf,
        @as(f32, 0),
        "0",
    );
    try util.unit_test(
        &buf,
        2.71,
        "2.71",
    );
    try util.unit_test(
        &buf,
        -3.14159265,
        "-3.14159265",
    );
}

test "bool" {
    var buf = util.make_buffer();
    defer buf.deinit();

    try util.unit_test(
        &buf,
        true,
        "true",
    );
    try util.unit_test(
        &buf,
        false,
        "false",
    );
}

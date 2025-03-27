const std = @import("std");

const util = @import("util.zig");

test "optional -- none" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        null,
        "()",
    );
    try util.unit_test(
        &buf,
        @as(?i32, null),
        "()",
    );
}

test "optional -- some immediate" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        @as(?i32, 3),
        "(3)",
    );
    try util.unit_test(
        &buf,
        @as(?i32, -19),
        "(-19)",
    );
    try util.unit_test(
        &buf,
        @as(?i32, std.math.maxInt(i32)),
        "(2147483647)",
    );
    try util.unit_test(
        &buf,
        @as(?f64, 3.14159),
        "(3.14159)",
    );
    try util.unit_test(
        &buf,
        @as(?bool, false),
        "(false)",
    );
}

test "optional -- some enum" {
    var buf = util.make_buffer();

    const simple_enum = enum {
        foo,
        bar,
        qux,
        corge,
        fred,
    };

    try util.unit_test(
        &buf,
        @as(?simple_enum, simple_enum.bar),
        "(bar)",
    );
    try util.unit_test(
        &buf,
        @as(?simple_enum, simple_enum.fred),
        "(fred)",
    );
}

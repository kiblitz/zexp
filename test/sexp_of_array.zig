const std = @import("std");

const util = @import("util.zig");

test "array -- empty" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        [0]bool{},
        "()",
    );
    try util.unit_test(
        &buf,
        @as([3]i32, undefined),
        "(0 0 0)",
    );
}

test "array -- immediate" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        [3]i32{ 2001, 25, 1 },
        "(2001 25 1)",
    );
    try util.unit_test(
        &buf,
        [4]bool{ true, false, true, true },
        "(true false true true)",
    );
}

test "array -- tagged enum" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        [4]?util.simple_anonymous_tagged_enum{
            .qux,
            .{ .thud = "hi" },
            null,
            .{ .foo = 25 },
        },
        "(((qux)) ((thud (104 105))) () ((foo 25)))",
    );
}

test "array -- optional" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        [4]?i32{ 1, 10, null, 100 },
        "((1) (10) () (100))",
    );
    try util.unit_test(
        &buf,
        [1]?bool{null},
        "(())",
    );
}

test "vector -- immediate" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        @as(
            @Vector(4, i32),
            .{ 13, 37, 25, -4 },
        ),
        "(13 37 25 -4)",
    );
}

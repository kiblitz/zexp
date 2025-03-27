const std = @import("std");

const util = @import("util.zig");

test "enum" {
    var buf = util.make_buffer();

    const simple_enum = enum {
        foo,
        bar,
        qux,
        corge,
        thud,
    };

    try util.unit_test(
        &buf,
        simple_enum.foo,
        "foo",
    );
    try util.unit_test(
        &buf,
        simple_enum.qux,
        "qux",
    );
}

test "tagged enum -- named" {
    var buf = util.make_buffer();

    const untagged_enum = enum {
        foo,
        bar,
        qux,
        corge,
        thud,
    };

    const simple_enum = union(untagged_enum) {
        foo: i32,
        bar: bool,
        qux,
        corge,
        thud,
    };

    try util.unit_test(
        &buf,
        simple_enum{ .foo = 7 },
        "(foo 7)",
    );
    try util.unit_test(
        &buf,
        simple_enum{ .bar = true },
        "(bar true)",
    );
    try util.unit_test(
        &buf,
        simple_enum.qux,
        "qux",
    );
}

test "tagged enum -- anonymous" {
    var buf = util.make_buffer();

    const simple_enum = union(enum) {
        foo: i32,
        bar: bool,
        qux,
        corge,
        thud,
    };

    try util.unit_test(
        &buf,
        simple_enum{ .foo = 7 },
        "(foo 7)",
    );
    try util.unit_test(
        &buf,
        simple_enum{ .bar = true },
        "(bar true)",
    );
    try util.unit_test(
        &buf,
        simple_enum.qux,
        "qux",
    );
}

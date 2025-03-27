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
        simple_enum,
        simple_enum.foo,
        "foo",
    );
    try util.unit_test(
        &buf,
        simple_enum,
        simple_enum.qux,
        "qux",
    );
}

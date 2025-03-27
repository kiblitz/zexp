const std = @import("std");

const util = @import("util.zig");

test "enum" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        util.simple_untagged_enum.foo,
        "foo",
    );
    try util.unit_test(
        &buf,
        util.simple_untagged_enum.qux,
        "qux",
    );
}

test "tagged enum -- named" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        util.simple_named_tagged_enum{ .foo = 7 },
        "(foo 7)",
    );
    try util.unit_test(
        &buf,
        util.simple_named_tagged_enum{ .bar = true },
        "(bar true)",
    );
    try util.unit_test(
        &buf,
        util.simple_named_tagged_enum.qux,
        "qux",
    );
}

test "tagged enum -- anonymous" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        util.simple_anonymous_tagged_enum{ .foo = 7 },
        "(foo 7)",
    );
    try util.unit_test(
        &buf,
        util.simple_anonymous_tagged_enum{ .bar = true },
        "(bar true)",
    );
    try util.unit_test(
        &buf,
        util.simple_anonymous_tagged_enum.qux,
        "qux",
    );
}

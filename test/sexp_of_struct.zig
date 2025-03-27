const std = @import("std");

const util = @import("util.zig");

test "struct -- flat" {
    var buf = util.make_buffer();

    const simple_struct = util.simple_struct{
        .foo = 7,
        .bar = false,
        .qux = null,
        .corge = 3.14159265,
        .thud = "gl",
        .fred = [3]i8{ 1, 2, 3 },
    };

    try util.unit_test(
        &buf,
        simple_struct,
        "((foo 7)(bar false)(qux ())(corge (3.14159265))(thud (103 108))(fred (1 2 3)))",
    );
}

test "struct -- deep" {
    var buf = util.make_buffer();

    const deep_struct = util.deep_struct{
        .foo = .{
            .qux = 4,
            .corge = false,
        },
        .bar = .{
            .thud = .fred,
        },
    };

    try util.unit_test(
        &buf,
        deep_struct,
        "((foo ((qux 4)(corge (false))))(bar ((thud fred))))",
    );
}

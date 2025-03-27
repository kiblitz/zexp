const std = @import("std");

const util = @import("util.zig");

test "pointer -- single" {
    var buf = util.make_buffer();

    const i = 3;
    const b = false;

    try util.unit_test(
        &buf,
        &i,
        "(3)",
    );
    try util.unit_test(
        &buf,
        &b,
        "(false)",
    );
}

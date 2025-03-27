const std = @import("std");

const util = @import("util.zig");

test "struct" {
    var buf = util.make_buffer();

    try util.unit_test(
        &buf,
        util.simple_struct_inst,
        "((foo 7)(bar false)(qux ())(corge (3.14159265))(thud (103 108))(fred (1 2 3)))",
    );
}

const std = @import("std");
const zexp = @import("zexp");

const util = @import("util.zig");

test "int" {
    try std.testing.expectEqual(
        10,
        try zexp.of_sexp(
            .stack,
            u32,
            "10",
        ),
    );
    try std.testing.expectEqual(
        -19,
        try zexp.of_sexp(
            .stack,
            i32,
            "-19",
        ),
    );
    try std.testing.expectEqual(
        std.math.maxInt(i32),
        try zexp.of_sexp(
            .stack,
            i32,
            "2147483647",
        ),
    );
    try std.testing.expectEqual(
        std.math.minInt(i32),
        try zexp.of_sexp(
            .stack,
            i32,
            "-2147483648",
        ),
    );
}

test "int failure" {
    try std.testing.expectError(
        error.IntegerDeserializationFailed,
        zexp.of_sexp(
            .stack,
            i32,
            "",
        ),
    );
    try std.testing.expectError(
        error.InvalidCharacter,
        zexp.of_sexp(
            .stack,
            i32,
            "false",
        ),
    );
}

test "bool" {
    try std.testing.expectEqual(
        true,
        try zexp.of_sexp(
            .stack,
            bool,
            "true",
        ),
    );
    try std.testing.expectEqual(
        true,
        try zexp.of_sexp(
            .stack,
            bool,
            "false",
        ),
    );
}

test "bool failure" {
    try std.testing.expectError(
        error.BoolDeserializationFailed,
        zexp.of_sexp(
            .stack,
            bool,
            "1",
        ),
    );
}

test "incomplete parsing" {
    try std.testing.expectError(
        error.IncompleteParsingOfEncoding,
        zexp.of_sexp(
            .stack,
            bool,
            "true ",
        ),
    );
}

const std = @import("std");

fn sexp_of_type(comptime Spec: type) type {
    return fn (std.io.AnyWriter, Spec) anyerror!void;
}

pub fn sexp_of(buf: std.io.AnyWriter, v: anytype) anyerror!void {
    const typed_sexp_of =
        switch (@typeInfo(@TypeOf(v))) {
            .int => sexp_of_numeric,
            .float => sexp_of_numeric,
            .comptime_int => sexp_of_numeric,
            .comptime_float => sexp_of_numeric,
            .bool => sexp_of_bool,
            .optional => sexp_of_optional,
            .null => sexp_of_optional,
            .@"enum" => sexp_of_enum,
            else =>
            // TODO -- Add unit tests
            //
            // This is not possible in the possible version of zig since this is not
            // a runtime error but a compiletime error.
            //
            // See issue #513
            @compileError("Cannot sexpify types: " ++ @typeName(@TypeOf(v))),
        };

    return typed_sexp_of(buf, v);
}

fn sexp_of_numeric(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "{d}", .{v});
}

fn sexp_of_bool(buf: std.io.AnyWriter, v: bool) !void {
    switch (v) {
        true => try std.fmt.format(buf, "true", .{}),
        false => try std.fmt.format(buf, "false", .{}),
    }
}

fn sexp_of_enum(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "{s}", .{@tagName(v)});
}

fn sexp_of_optional(buf: std.io.AnyWriter, maybe_v: anytype) !void {
    if (maybe_v) |v| {
        try std.fmt.format(buf, "(", .{});
        try sexp_of(buf, v);
        try std.fmt.format(buf, ")", .{});
    } else {
        try std.fmt.format(buf, "()", .{});
    }
}

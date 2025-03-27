const std = @import("std");

pub fn sexp_of(buf: std.io.AnyWriter, v: anytype) anyerror!void {
    const typed_sexp_of =
        // TODO -- Add unit tests for compilation errors
        //
        // This is not possible in the possible version of zig since this is
        // not a runtime error but a compiletime error.
        //
        // See issue #513
        switch (@typeInfo(@TypeOf(v))) {
            .bool => sexp_of_bool,
            .int => sexp_of_numeric,
            .float => sexp_of_numeric,
            .comptime_int => sexp_of_numeric,
            .comptime_float => sexp_of_numeric,
            .pointer =>
            // NOTE -- we assume NON-OVERLAPPING. Behaviour dependent on
            // memory overlap will be LOST.
            |pointer_payload| switch (pointer_payload.size) {
                .slice => sexp_of_array,
                .one => sexp_of_pointer,
                else => @compileError(
                    "Cannot sexpify [many] or [c] pointers: " ++ @typeName(@TypeOf(v)),
                ),
            },
            .array => sexp_of_array,
            .vector => sexp_of_vector,
            .optional => sexp_of_optional,
            .null => sexp_of_optional,
            .@"enum" => sexp_of_enum,
            .@"union" => |union_payload| if (union_payload.tag_type) |_|
                sexp_of_tagged_enum
            else
                @compileError("Cannot sexpify non-tagged union"),
            .@"struct" => sexp_of_struct,
            else => @compileError(
                "Cannot sexpify types: " ++ @typeName(@TypeOf(v)),
            ),
        };

    try typed_sexp_of(buf, v);
}

fn sexp_of_bool(buf: std.io.AnyWriter, v: bool) !void {
    switch (v) {
        true => try std.fmt.format(buf, "true", .{}),
        false => try std.fmt.format(buf, "false", .{}),
    }
}

fn sexp_of_numeric(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "{d}", .{v});
}

fn sexp_of_pointer(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "(", .{});
    try sexp_of(buf, v.*);
    try std.fmt.format(buf, ")", .{});
}

fn sexp_of_array(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "(", .{});
    for (0.., v) |i, elem| {
        if (i > 0)
            try std.fmt.format(buf, " ", .{});
        try sexp_of(buf, elem);
    }
    try std.fmt.format(buf, ")", .{});
}

fn sexp_of_vector(buf: std.io.AnyWriter, v: anytype) !void {
    const len = @typeInfo(@TypeOf(v)).vector.len;
    try std.fmt.format(buf, "(", .{});
    for (0..len) |i| {
        if (i > 0)
            try std.fmt.format(buf, " ", .{});
        try sexp_of(buf, v[i]);
    }
    try std.fmt.format(buf, ")", .{});
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

fn sexp_of_enum(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "{s}", .{@tagName(v)});
}

fn sexp_of_tagged_enum(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "({s}", .{@tagName(v)});
    switch (v) {
        inline else => |tag| if (@TypeOf(tag) != void) {
            try std.fmt.format(buf, " ", .{});
            try sexp_of(buf, tag);
        },
    }
    try std.fmt.format(buf, ")", .{});
}

fn sexp_of_struct(buf: std.io.AnyWriter, v: anytype) !void {
    try std.fmt.format(buf, "(", .{});
    inline for (std.meta.fields(@TypeOf(v))) |field| {
        try std.fmt.format(buf, "({s} ", .{field.name});
        try sexp_of(buf, @field(v, field.name));
        try std.fmt.format(buf, ")", .{});
    }
    try std.fmt.format(buf, ")", .{});
}

const std = @import("std");

fn sexp_of_type(comptime Spec: type) type {
    return fn (std.io.AnyWriter, Spec) anyerror!void;
}

pub fn sexp_of(comptime Spec: type) sexp_of_type(Spec) {
    switch (@typeInfo(Spec)) {
        .int => return sexp_of_numeric(Spec),
        .float => return sexp_of_numeric(Spec),
        .bool => return sexp_of_bool,
        .optional => |optional| return sexp_of_optional(optional.child),
        else =>
        // TODO -- Add unit tests
        //
        // This is not possible in the possible version of zig since this is not
        // a runtime error but a compiletime error.
        //
        // See issue #513
        @compileError("Cannot sexpify types: " ++ @typeName(Spec)),
    }

    return struct {
        fn call(t: Spec) []const u8 {
            _ = t;
            return error.Uninitialized;
        }
    }.call;
}

fn sexp_of_numeric(comptime Spec: type) sexp_of_type(Spec) {
    return struct {
        fn f(buf: std.io.AnyWriter, v: Spec) !void {
            try std.fmt.format(buf, "{d}", .{v});
        }
    }.f;
}

fn sexp_of_bool(buf: std.io.AnyWriter, v: bool) !void {
    switch (v) {
        true => try std.fmt.format(buf, "true", .{}),
        false => try std.fmt.format(buf, "false", .{}),
    }
}

fn sexp_of_optional(comptime Child: type) sexp_of_type(?Child) {
    const sexp_of_child = sexp_of(Child);
    return struct {
        fn f(buf: std.io.AnyWriter, maybe_v: ?Child) !void {
            if (maybe_v) |v| {
                try std.fmt.format(buf, "(", .{});
                try sexp_of_child(buf, v);
                try std.fmt.format(buf, ")", .{});
            } else {
                try std.fmt.format(buf, "()", .{});
            }
        }
    }.f;
}

const std = @import("std");

pub fn sexp_of(comptime Spec: type) fn (std.io.AnyWriter, Spec) anyerror!void {
    switch (@typeInfo(Spec)) {
        .int => return sexp_of_numeric(Spec),
        .float => return sexp_of_numeric(Spec),
        .bool => return sexp_of_bool,
        else => |t| @compileLog("idk " ++ @tagName(t)),
    }

    return struct {
        fn call(t: Spec) []const u8 {
            _ = t;
            return error.Uninitialized;
        }
    }.call;
}

fn sexp_of_numeric(comptime Spec: type) fn (std.io.AnyWriter, Spec) anyerror!void {
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

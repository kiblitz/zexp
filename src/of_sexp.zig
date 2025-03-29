const std = @import("std");

pub const AllocationMode = union(enum) {
    stack,
    allocate: std.mem.Allocator,
};

fn ReturnType(allocation_mode: AllocationMode, comptime T: type) type {
    return switch (allocation_mode) {
        .stack => T,
        .allocate => *T,
    };
}

fn ParseResult(comptime T: type) type {
    return struct {
        value: T,
        rest_of_encoding: []const u8,
    };
}

pub fn of_sexp(comptime allocation_mode: AllocationMode, comptime T: type, sexp: []const u8) !ReturnType(allocation_mode, T) {
    const ptr =
        switch (allocation_mode) {
            .stack => null,
            .allocate => |allocator| try allocator.create(T),
        };

    const parse_result =
        try switch (@typeInfo(T)) {
            .bool => of_sexp_bool(sexp),
            .int => of_sexp_int(T, sexp),
            else => @compileError("Cannot un-sexpify type: " ++ @typeName(T)),
        };

    if (parse_result.rest_of_encoding.len > 0)
        return error.IncompleteParsingOfEncoding;

    switch (allocation_mode) {
        .stack => return parse_result.value,
        .allocate => {
            ptr.* = parse_result.value;
            return ptr.?;
        },
    }
}

pub fn of_sexp_bool(sexp: []const u8) !ParseResult(bool) {
    const true_parse_result = str_starts_with(sexp, "true");
    if (true_parse_result.value) return true_parse_result;

    const false_parse_result = str_starts_with(sexp, "false");
    if (false_parse_result.value) return false_parse_result;

    return error.BoolDeserializationFailed;
}

pub fn of_sexp_int(comptime T: type, sexp: []const u8) !ParseResult(T) {
    if (sexp.len == 0) return error.IntegerDeserializationFailed;

    const is_signed = @typeInfo(T).int.signedness == .signed;
    const neg = if (sexp[0] == '-') true else false;
    if (is_signed and neg and sexp.len == 1) return error.IntegerDeserializationFailed;

    var acc: T = 0;
    const i =
        try struct {
            fn call(_acc: *T, _neg: bool, _sexp: []const u8) !usize {
                var i: usize = if (_neg) 1 else 0;
                while (i < _sexp.len) {
                    const char = _sexp[i];
                    if (char == ' ' or char == '(' or char == ')') {
                        return i + 1;
                    }

                    const digit = try std.fmt.charToDigit(char, 10);
                    _acc.* = try std.math.mul(T, _acc.*, 10);
                    _acc.* =
                        if (is_signed and _neg)
                            try std.math.sub(T, _acc.*, digit)
                        else
                            try std.math.add(T, _acc.*, digit);

                    i = i + 1;
                }
                return _sexp.len;
            }
        }.call(&acc, neg, sexp);

    return ParseResult(T){
        .value = acc,
        .rest_of_encoding = sexp[i..],
    };
}

fn str_starts_with(str: []const u8, prefix: []const u8) ParseResult(bool) {
    const fail_result =
        ParseResult(bool){
            .value = false,
            .rest_of_encoding = str,
        };

    if (str.len < prefix.len) return fail_result;

    for (0..prefix.len) |i| {
        if (str[i] != prefix[i]) return fail_result;
    }

    return .{
        .value = true,
        .rest_of_encoding = str[prefix.len..],
    };
}

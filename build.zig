const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const root_source_file = b.path("src/zexp.zig");

    const zexp_mod = b.addModule("zexp", .{
        .root_source_file = root_source_file,
        .target = target,
        .optimize = optimize,
    });

    const zexp_unit_tests = b.addTest(.{
        .root_module = zexp_mod,
    });
    const run_zexp_unit_tests = b.addRunArtifact(zexp_unit_tests);

    const zexp_tests = b.addTest(.{
        .root_source_file = b.path("test/test.zig"),
    });
    zexp_tests.root_module.addImport("zexp", zexp_mod);
    const run_zexp_tests = b.addRunArtifact(zexp_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_zexp_unit_tests.step);
    test_step.dependOn(&run_zexp_tests.step);
}

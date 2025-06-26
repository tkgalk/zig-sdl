const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // SDL2 wrapper library
    const sdl_lib = b.addStaticLibrary(.{
        .name = "sdl2",
        .root_source_file = .{ .cwd_relative = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Add SDL2 system library
    sdl_lib.linkSystemLibrary("SDL2");
    sdl_lib.linkLibC();

    // Install the library
    b.installArtifact(sdl_lib);

    // Create module for other projects to use
    const sdl_module = b.addModule("sdl2", .{
        .root_source_file = .{ .cwd_relative = "src/main.zig" },
    });

    // Example/test executable
    const example = b.addExecutable(.{
        .name = "example",
        .root_source_file = .{ .cwd_relative = "examples/basic_window.zig" },
        .target = target,
        .optimize = optimize,
    });

    example.root_module.addImport("sdl2", sdl_module);
    example.linkSystemLibrary("SDL2");
    example.linkLibC();

    const run_example = b.addRunArtifact(example);
    const run_step = b.step("run", "Run the example");
    run_step.dependOn(&run_example.step);

    // Tests
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .cwd_relative = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    unit_tests.linkSystemLibrary("SDL2");
    unit_tests.linkLibC();

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    // Documentation
    const docs = b.addInstallDirectory(.{
        .source_dir = sdl_lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Generate documentation");
    docs_step.dependOn(&docs.step);
}

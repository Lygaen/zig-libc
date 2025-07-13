const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const options = b.addOptions();
    options.addOption(bool, "trace", b.option(bool, "trace", "Wether to enable tracing or not") orelse false);

    const libc_mod = b.addModule("zig_libc", .{
        .link_libc = false,
        .link_libcpp = false,
        .root_source_file = b.path("./src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    libc_mod.addOptions("options", options);

    if (target.result.os.tag == .windows) {
        libc_mod.linkSystemLibrary("ntdll", .{});
        libc_mod.linkSystemLibrary("kernel32", .{});
    }

    const libc_out = b.addLibrary(.{
        .name = "zig_libc",
        .root_module = libc_mod,
        .linkage = .static,
    });
    b.installArtifact(libc_out);
    libc_out.installHeadersDirectory(b.path("include/"), "", .{});

    addTests(b, libc_out, target, optimize) catch |err| {
        std.log.err("An error happened while adding tests {}", .{err});
        b.default_step.dependOn(&b.addFail("Could not add tests !").step);
    };
}

fn addTests(b: *std.Build, lib: *std.Build.Step.Compile, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) !void {
    const tests_dir = try std.fs.cwd().openDir("./tests/", .{
        .iterate = true,
    });

    var iterator = tests_dir.iterate();

    const test_step = b.step("test", "Run unit tests");

    while (try iterator.next()) |entry| {
        if (entry.kind != .file)
            continue;

        const exe = b.addExecutable(.{
            .name = std.fs.path.stem(entry.name),
            .link_libc = false,
            .target = target,
            .optimize = optimize,
        });
        exe.addCSourceFile(.{
            .file = b.path(b.pathJoin(&.{ "tests/", entry.name })),
        });
        exe.addIncludePath(b.path("include/"));
        exe.linkLibrary(lib);

        const install_artifact = b.addInstallArtifact(exe, .{});
        test_step.dependOn(&install_artifact.step);

        const run = b.addRunArtifact(exe);
        run.addCheck(.{ .expect_term = .{ .Exited = 0 } });

        if (b.args) |args|
            run.addArgs(args);

        test_step.dependOn(&run.step);
    }
}

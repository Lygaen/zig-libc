const std = @import("std");

const emit_headers = @import("emit_headers.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libc_mod = b.addModule("zig-libc", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = false,
        .link_libcpp = false,
    });

    const libc_lib = b.addLibrary(.{
        .name = "zig-libc",
        .root_module = libc_mod,
    });
    b.installArtifact(libc_lib);

    emit_headers.generateHeaders(b) catch |err| {
        const msg = std.fmt.allocPrint(b.allocator, "Generate headers failed with {}", .{err}) catch unreachable;
        defer b.allocator.free(msg);
        b.default_step.dependOn(&b.addFail(msg).step);
    };

    const libc_check = b.addLibrary(.{
        .name = "zig-libc-check",
        .root_module = libc_mod,
    });
    const check = b.step("check", "Check if libc compiles");
    check.dependOn(&libc_check.step);
}

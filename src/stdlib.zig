const std = @import("std");
const builtin = @import("builtin");

const globals = @import("globals.zig");

pub export fn abort() callconv(.c) noreturn {
    globals.trace("aborting program", @src(), .{});
    @panic("Program aborted");
}

var AT_EXIT_CALLBACKS = [_]?*const fn () callconv(.c) void{null} ** 32;

export fn atexit(callback: *const fn () callconv(.c) void) callconv(.c) c_int {
    //TODO make it thread-safe with a mutex
    for (&AT_EXIT_CALLBACKS) |*ptr| {
        if (ptr.* == null) {
            ptr.* = callback;
            return 0;
        }
    }
    return 1;
}

pub export fn exit(exit_code: c_int) callconv(.c) noreturn {
    for (AT_EXIT_CALLBACKS) |optional| {
        if (optional) |callback| {
            callback();
        }
    }

    _Exit(exit_code);
}

pub export fn _Exit(exit_code: c_int) callconv(.c) noreturn {
    std.process.exit(@intCast(exit_code));
}

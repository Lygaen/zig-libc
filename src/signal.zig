const std = @import("std");
const allocator = @import("root").allocator;
const builtin = @import("builtin");

const c = @cImport({
    @cInclude("./include/signal.h");
    @cInclude("./include/stddef.h");
});

const CCallback = [*c]fn (c_int) callconv(.c) void;

pub export fn signal(sig: c_int, handler: CCallback) CCallback {
    const action = std.posix.Sigaction{
        .handler = .{ .handler = handler },
        .mask = std.posix.empty_sigset,
        .flags = 0,
    };

    const oact = std.posix.Sigaction{};
    std.posix.sigaction(sig, action, &oact);

    if (oact.handler.handler) |h| {
        return h;
    }
    return null;
}

pub export fn raise(sig: c_int) callconv(.c) c_int {
    std.posix.raise(@truncate(sig)) catch return 1;

    return 0;
}

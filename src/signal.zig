const std = @import("std");
const allocator = @import("root").allocator;
const builtin = @import("builtin");

const c = @cImport({
    @cInclude("./include/signal.h");
    @cInclude("./include/stddef.h");
});

const CCallback = [*c]fn (c_int) callconv(.c) void;

pub export fn signal(sig: c_int, handler: CCallback) CCallback {
    _ = sig; // autofix
    _ = handler; // autofix
    return c.SIG_ERR;
}

pub export fn raise(sig: c_int) callconv(.c) c_int {
    _ = sig; // autofix
    return 1;
}

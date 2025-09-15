const c = @cImport(
    @cInclude("./include/signal.h"),
);

pub export fn signal(sig: c_int, handler: fn () callconv(.c) c_int) fn () callconv(.c) c_int {
    _ = sig; // autofix
    _ = handler; // autofix
    return;
}

pub export fn raise(sig: c_int) callconv(.c) c_int {
    _ = sig; // autofix

}

/// Macro: int
pub export const sig_atomic_t = c_int;
pub export const SIGABRT = 0;
pub export const SIGFPE = 1;
pub export const SIGILL = 2;
pub export const SIGINT = 3;
pub export const SIGSEGV = 4;
pub export const SIGTERM = 5;

pub export const SIG_ERR = 1;
pub export const SIG_DFL = 0;
pub export const SIG_IGN = 1;

pub export fn signal(sig: c_int, handler: fn () callconv(.c) c_int) fn () callconv(.c) c_int {
    _ = sig; // autofix
    _ = handler; // autofix
    return SIG_ERR;
}

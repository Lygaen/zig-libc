//! The header <assert.h> defines the assert macro and refers to another macro,
//!          NDEBUG
//! which is not defined by <assert.h>

const std = @import("std");

pub export fn __assert_impl(
    cond: bool,
    assert_str: [*c]c_char,
    file: [*c]c_char,
    line: c_int,
) callconv(.c) void {
    if (cond)
        return;

    std.debug.print("{s}:{} Assertion {s} failed", .{ file, line, assert_str });
}

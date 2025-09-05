//! The header <assert.h> defines the assert macro and refers to another macro,
//!          NDEBUG
//! which is not defined by <assert.h>

const std = @import("std");

/// The assert macro puts diagnostics into programs.
/// When it is executed, if expression is false (that is, compares equal to 0),
/// the assert macro writes information about the particular call that failed
/// (including the text of the argument, the name of the source file, and the
/// source line number EM the latter are respectively the values of the
/// preprocessing macros __FILE__ and __LINE__ ) on the standard error file
/// in an implementation-defined format. It then calls the abort function.
/// The assert macro returns no value.
/// Macro: __assert_impl(NDEBUG ? true : x, #x, __FILE__, __LINE__)
pub export const @"assert(x)" = 0;

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

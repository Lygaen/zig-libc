//! Sizes of integral types
//! The values given below shall be replaced by
//! constant expressions suitable for use in #if
//! preprocessing directives. Their implementation-defined
//! values shall be equal or greater in magnitude
//! (absolute value) to those shown, with the same sign.
//!
//! If the value of an object of type char sign-extends
//! when used in an expression, the value of CHAR_MIN shall
//! be the same as that of SCHAR_MIN and the value of CHAR_MAX
//! shall be the same as that of SCHAR_MAX. If the value of
//! an object of type char does not sign-extend when used in
//! an expression, the value of CHAR_MIN shall be 0 and the
//! value of CHAR_MAX shall be the same as that of UCHAR_MAX.

const std = @import("std");
const builtin = @import("builtin");

pub const c = @cImport(
    @cInclude("./include/limits.h"),
);

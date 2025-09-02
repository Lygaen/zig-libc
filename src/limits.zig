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

/// maximum number of bits for smallest object that is
/// not a bit-field (byte)
/// Macro: __CHAR_BIT__
pub export const CHAR_BIT = @bitSizeOf(c_char);

/// maximum value for an object of type char
/// Macro: __CHAR_MAX__
pub export const CHAR_MAX = std.math.maxInt(c_char);
/// minimum value for an object of type char
/// Macro: __CHAR_MIN__
pub export const CHAR_MIN = std.math.minInt(c_char);

/// maximum value for an object of type signed char
/// Macro: __SCHAR_MAX__
pub export const SCHAR_MAX = std.math.pow(comptime_int, 2, builtin.target.cTypeBitSize(.char) - 1) - 1;

/// minimum value for an object of type signed char
pub export const SCHAR_MIN = (-1 - SCHAR_MAX);
/// maximum value for an object of type unsigned char
/// Macro: (SCHAR_MAX * 2U + 1U)
pub export const UCHAR_MAX = (SCHAR_MAX * 2 + 1);

/// maximum value for an object of type short int
/// Macro: __SHRT_MAX__
pub export const SHRT_MAX = std.math.maxInt(c_short);
/// minimum value for an object of type short int
pub export const SHRT_MIN = (-1 - SHRT_MAX);

/// maximum value for an object of type unsigned short int
pub export const USHRT_MAX = (SHRT_MAX * 2 + 1);

/// maximum value for an object of type int
/// Macro: __INT_MAX__
pub export const INT_MAX = std.math.maxInt(c_int);
/// minimum value for an object of type int
pub export const INT_MIN = (-1 - INT_MAX);

/// maximum value for an object of type unsigned int
/// Macro: (INT_MAX * 2U + 1U)
pub export const UINT_MAX = (INT_MAX * 2 + 1);

/// maximum value for an object of type long int
/// Macro: __LONG_MAX__
pub export const LONG_MAX = std.math.maxInt(c_long);
/// minimum value for an object of type long int
pub export const LONG_MIN = (-1 - LONG_MAX);

/// maximum value for an object of type unsigned long int
/// Macro: (LONG_MAX * 2UL + 1UL)
pub export const ULONG_MAX = (LONG_MAX * 2 + 1);

/// maximum number of bytes in a multibyte character,
/// for any supported locale
pub export const MB_LEN_MAX = @compileLog("UNDEF");

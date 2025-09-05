//! The header <ctype.h> declares several functions useful for
//! testing and mapping characters. In all cases the
//! argument is an int , the value of which shall be
//! representable as an unsigned char or shall equal the value
//! of the macro EOF. If the argument has any other value,
//! the behavior is undefined. The behavior of these functions
//! is affected by the current locale. Those functions that
//! have no implementation-defined aspects in the C locale
//! are noted below. The term printing character refers to
//! a member of an implementation-defined set of characters,
//! each of which occupies one printing position on a display
//! device; the term control character refers to a member of
//! an implementation-defined set of characters that are not
//! printing characters.

const std = @import("std");
const ascii = std.ascii;

/// The isalnum function tests for any character
/// for which isalpha or isdigit is true.
pub export fn isalnum(c: c_int) c_int {
    return @intFromBool(ascii.isAlphanumeric(c));
}

/// The isalpha function tests for any character
/// for which isupper or islower is true, or any
/// of an implementation-defined set of characters
/// for which none of iscntrl, isdigit, ispunct,
/// or isspace is true. In the C locale, isalpha
/// returns true only for the characters for which
/// isupper or islower is true.
pub export fn isalpha(c: c_int) c_int {
    return @intFromBool(ascii.isAlphabetic(c));
}

/// The iscntrl function tests for any control character.
pub export fn iscntrl(c: c_int) c_int {
    return @intFromBool(ascii.isControl(c));
}

/// The isdigit function tests for any decimal-digit character.
pub export fn isdigit(c: c_int) c_int {
    return @intFromBool(ascii.isDigit(c));
}

/// The isgraph function tests for any printing character except space (' ').
pub export fn isgraph(c: c_int) c_int {
    return @intFromBool((@as(c_uint, @bitCast(c)) -% '!') < '^');
}

/// The islower function tests for any lower-case letter or any of
/// an implementation-defined set of characters for which none of iscntrl,
/// isdigit, ispunct, or isspace is true. In the C locale, islower returns
/// true only for the characters defined as lower-case letters.
pub export fn islower(c: c_int) c_int {
    return @intFromBool(ascii.isLower(c));
}

/// The isprint function tests for any printing character including space (' ').
pub export fn isprint(c: c_int) c_int {
    return @intFromBool(ascii.isPrint(c));
}

/// The ispunct function tests for any printing character except space (' ')
/// or a character for which isalnum is true.
pub export fn ispunct(c: c_int) c_int {
    return @intFromBool((isgraph(c) == 1) and (isalnum(c) == 0));
}

/// The isspace function tests for the standard white-space characters
/// or for any of an implementation-defined set of characters for which
/// isalnum is false. The standard white-space characters are the
/// following: space (' '), form feed ('\f'), new-line ('\n'), carriage
/// return ('\r'), horizontal tab ('\t'), and vertical tab ('\v'). In
/// the C locale, isspace returns true only for the standard white-space
/// characters.
pub export fn isspace(c: c_int) c_int {
    return @intFromBool(ascii.isWhitespace(c));
}

/// The isupper function tests for any upper-case letter or any of an
/// implementation-defined set of characters for which none of iscntrl,
/// isdigit, ispunct, or isspace is true. In the C locale, isupper
/// returns true only for the characters defined as upper-case letters.
pub export fn isupper(c: c_int) c_int {
    return @intFromBool(ascii.isUpper(c));
}

/// The isxdigit function tests for any hexadecimal-digit character.
pub export fn isxdigit(c: c_int) c_int {
    return @intFromBool(ascii.isHex(c));
}

/// The tolower function converts an upper-case letter to the
/// corresponding lower-case letter.
/// If the argument is an upper-case letter, the tolower function
/// returns the corresponding lower-case letter if there is one;
/// otherwise the argument is returned unchanged. In the C locale,
/// tolower maps only the characters for which isupper is true to
/// the corresponding characters for which islower is true.
pub export fn tolower(c: c_int) c_int {
    return ascii.toLower(c);
}

/// The toupper function converts a lower-case letter to the
/// corresponding upper-case letter.
/// If the argument is a lower-case letter, the toupper function
/// returns the corresponding upper-case letter if there is one;
/// otherwise the argument is returned unchanged. In the C locale,
/// toupper maps only the characters for which islower is true to
/// the corresponding characters for which isupper is true.
pub export fn toupper(c: c_int) c_int {
    return ascii.toUpper(c);
}

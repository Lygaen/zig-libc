//! The header <locale.h> declares two functions,
//! one type, and defines several macros.

const std = @import("std");

/// Type which contains members related to the formatting of numeric values.
/// The structure shall contain at least the following members,
/// in any order. The semantics of the members and their normal
/// ranges is explained in 4.4.2.1 In the C locale (C89).
///
/// The members of the structure with type char * are strings,
/// any of which (except decimal_point) can point to, to indicate
/// that the value is not available in the current locale or is
/// of zero length. The members with type char are nonnegative
/// numbers, any of which can be CHAR_MAX to indicate that the
/// value is not available in the current locale.
///
/// The elements of grouping and mon_grouping are interpreted
/// according to the following: No further grouping is to be
/// performed. The previous element is to be repeatedly used
/// for the remainder of the digits. The value is the number
/// of digits that comprise the current group. The next element
/// is examined to determine the size of the next group of
/// digits to the left of the current group.
///
/// The value of p_sign_posn and n_sign_posn is interpreted
/// according to the following: Parentheses surround the
/// quantity and currency_symbol. The sign string precedes
/// the quantity and currency_symbol. The sign string succeeds
/// the quantity and currency_symbol. The sign string immediately
/// precedes the currency_symbol. The sign string immediately
/// succeeds the currency_symbol.
pub export const lconv = struct {
    /// The decimal-point character used
    /// to format non-monetary quantities.
    decimal_point: [*c]c_char,
    /// The character used to separate groups
    /// of digits to the left of the decimal-point
    /// character in formatted non-monetary quantities.
    thousands_sep: [*c]c_char,
    /// A string whose elements indicate the size
    /// of each group of digits in formatted
    /// non-monetary quantities.
    grouping: [*c]c_char,
    /// The international currency symbol
    /// applicable to the current locale.
    /// The first three characters contain the
    /// alphabetic international currency symbol in
    /// accordance with those specified in ISO 4217
    /// Codes for the Representation of Currency and Funds.
    /// The fourth character (immediately preceding the
    /// null character) is the character used to separate
    /// the international currency symbol from the
    /// monetary quantity.
    int_curr_symbol: [*c]c_char,
    /// The local currency symbol applicable to
    /// the current locale.
    currency_symbol: [*c]c_char,
    /// The decimal-point used to format monetary
    /// quantities.
    mon_decimal_point: [*c]c_char,
    /// The separator for groups of digits to the left of
    /// the decimal-point in formatted monetary quantities.
    mon_thousands_sep: [*c]c_char,
    /// A string whose elements indicate the size of
    /// each group of digits in formatted monetary quantities.
    mon_grouping: [*c]c_char,
    /// The string used to indicate a nonnegative-valued
    /// formatted monetary quantity.
    positive_sign: [*c]c_char,
    /// The string used to indicate a negative-valued
    /// formatted monetary quantity.
    negative_sign: [*c]c_char,
    /// The number of fractional digits (those to the right of the
    /// decimal-point) to be displayed in a internationally formatted
    /// monetary quantity.
    int_frac_digits: c_char,
    /// The number of fractional digits (those to the
    /// right of the decimal-point) to be displayed in a formatted
    /// monetary quantity.
    frac_digits: c_char,
    /// Set to 1 or 0 if the currency_symbol
    /// respectively precedes or succeeds the value for a
    /// nonnegative formatted monetary quantity.
    p_cs_precedes: c_char,
    /// Set to 1 or 0 if the currency_symbol respectively
    /// is or is not separated by a space from the value
    /// for a nonnegative formatted monetary quantity.
    p_sep_by_space: c_char,
    /// Set to 1 or 0 if the currency_symbol respectively
    /// precedes or succeeds the value for a negative
    /// formatted monetary quantity.
    n_cs_precedes: c_char,
    /// Set to 1 or 0 if the currency_symbol respectively
    /// is or is not separated by a space from the value
    /// for a negative formatted monetary quantity.
    n_sep_by_space: c_char,
    /// Set to a value indicating the positioning of the
    /// positive_sign for a nonnegative formatted monetary
    /// quantity.
    p_sign_posn: c_char,
    /// Set to a value indicating the positioning of the
    /// negative_sign for a negative formatted monetary
    /// quantity.
    n_sign_posn: c_char,

    const c: @This() = .{
        .decimal_point = ".",
        .thousands_sep = "",
        .grouping = "",
        .int_curr_symbol = "",
        .currency_symbol = "",
        .mon_decimal_point = "",
        .mon_thousands_sep = "",
        .mon_grouping = "",
        .positive_sign = "",
        .negative_sign = "",
        .int_frac_digits = std.math.maxInt(c_char),
        .frac_digits = std.math.maxInt(c_char),
        .p_cs_precedes = std.math.maxInt(c_char),
        .p_sep_by_space = std.math.maxInt(c_char),
        .n_cs_precedes = std.math.maxInt(c_char),
        .n_sep_by_space = std.math.maxInt(c_char),
        .p_sign_posn = std.math.maxInt(c_char),
        .n_sign_posn = std.math.maxInt(c_char),
    };
};

const c = @cImport(
    @cInclude("./include/locale.h"),
);

/// The setlocale function selects the appropriate portion
/// of the program's locale as specified by the category and
/// locale arguments. The setlocale function may be used to
/// change or query the program's entire current locale or
/// portions thereof.
///
/// A value of "C" for locale specifies the minimal environment
/// for C translation; a value of "" for locale specifies the
/// implementation-defined native environment. Other
/// implementation-defined strings may be passed as the second
/// argument to setlocale.
///
/// At program startup, the equivalent of
///
/// setlocale(LC_ALL, "C");
///
/// is executed.
/// The implementation shall behave as if no library function
/// calls the setlocale function.
///
/// If a pointer to a string is given for locale and the selection
/// can be honored, the setlocale function returns the string
/// associated with the specified category for the new locale.
/// If the selection cannot be honored, the setlocale function
/// returns a null pointer and the program's locale is not changed.
///
/// A null pointer for locale causes the setlocale function to return
/// the string associated with the category for the program's current
/// locale; the program's locale is not changed. The string returned
/// by the setlocale function is such that a subsequent call with
/// that string and its associated category will restore that part
/// of the program's locale. The string returned shall not be modified
/// by the program, but may be overwritten by a subsequent call to the
/// setlocale function.
pub export fn setlocale(category: c_int, locale: [*c]c_char) [*c]c_char {
    _ = category;
    _ = locale;
    // TODO: change from No-op
    return "";
}

var __locale: lconv = .c;
/// The localeconv function sets the components of an object
/// with type struct lconv with values appropriate for the
/// formatting of numeric quantities (monetary and otherwise)
/// according to the rules of the current locale.
///
/// The implementation shall behave as if no library function
/// calls the localeconv function.
///
/// The localeconv function returns a pointer to the filled-in object.
/// The structure pointed to by the return value shall not be modified
/// by the program, but may be overwritten by a subsequent call to the
/// localeconv function. In addition, calls to the setlocale function
/// with categories LC_ALL, LC_MONETARY, or LC_NUMERIC may overwrite
/// the contents of the structure.
pub export fn localeconv() [*c]lconv {
    return &__locale;
}

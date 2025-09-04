//! This header is part of types support library,
//! in particular, it provides additional basic
//! types and convenience macros.
//!
//! Some are also defined in other headers,
//! as noted in their respective sections.

/// Macro which is the signed integral type
/// of the result of subtracting two pointers
/// Macro: __PTR_TYPE__
pub export const ptrdiff_t = isize;

/// Macro which is the unsigned integral type of
/// the result of the sizeof operator
/// Macro: unsigned ptrdiff_t
pub export const size_t = usize;

/// Macro which is an integral type whose range of
/// values can represent distinct codes for all
/// members of the largest extended character set
/// specified among the supported locales; the null
/// character shall have the code value zero and
/// each member of the basic character set defined in
/// 2.2.1 (C89 standard)shall have a code value equal
/// to its value when used as the lone character in
/// an integer character constant.
/// Macro: short
pub export const wchar_t = c_short;
/// Macro which expands to an implementation-defined
/// null pointer constant
pub export const NULL = 0;

/// Macro which expands to an integral constant expression
/// that has type size_t, the value of which is the offset
/// in bytes, to the structure member (designated by
/// member), from the beginning of its structure
/// (designated by type). The member shall be
/// such that given `static type t;` then the expression
/// &(t.member) evaluates to an address constant.
/// If the specified member is a bit-field, the behavior
/// is undefined.
/// Macro: __builtin_offsetof(type, member)
pub export const @"offsetof(type, member)" = undefined;

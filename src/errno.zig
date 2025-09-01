//! The header <errno.h> defines several macros,
//! all relating to the reporting of error conditions.
//!
//! The value of errno is zero at program startup, but is
//! never set to zero by any library function. The value of
//! errno may be set to nonzero by a library function call
//! whether or not there is an error, provided the use of
//! errno is not documented in the description of the
//! function in the Standard.
//!
//! Additional macro definitions, beginning with E and
//! a digit or E and an upper-case letter, may also be
//! specified by the implementation.

/// Represents a domain error for a math function.
pub const EDOM = 33;
/// Represents a range error for a math function.
pub const ERANGE = 34;

/// Variable which expands to a modifiable lvalue that
/// has type int, the value of which is set to a positive
/// error number by several library functions. It is
/// unspecified whether errno is a macro or an identifier
/// declared with external linkage. If a macro definition
/// is suppressed in order to access an actual object,
/// or a program defines an external identifier with the
/// name errno, the behavior is undefined.
pub var errno: c_int = 0;

//! The header <stdarg.h> declares a type and defines three
//! macros, for advancing through a list of arguments whose
//! number and types are not known to the called function
//! when it is translated. A function may be called with a
//! variable number of arguments of varying types.
//! Its parameter list contains one or more parameters.
//! The rightmost parameter plays a special role in the
//! access mechanism, and will be designated parmN in this
//! description.

/// The va_start macro shall be invoked before any access to
/// the unnamed arguments. The va_start macro initializes v
/// for subsequent use by va_arg and va_end.
/// The parameter l is the identifier of the rightmost
/// parameter in the variable parameter list in the function
/// definition (the one just before the, ...).
/// If the parameter l is declared with the register
/// storage class, with a function or array type,
/// or with a type that is not compatible with the type
/// that results after application of the default argument
/// promotions, the behavior is undefined.
/// The va_start macro returns no value.
/// Macro: __builtin_va_start(v,l)
pub export const @"va_start(v,l)" = 0;

/// The va_end macro facilitates a normal return from
/// the function whose variable argument list was
/// referred to by the expansion of va_start that
/// initialized the va_list v. The va_end macro may
/// modify ap so that it is no longer usable (without
/// an intervening invocation of va_start). If there
/// is no corresponding invocation of the va_start macro,
/// or if the va_end macro is not invoked before the return,
/// the behavior is undefined.
/// The va_end macro returns no value.
/// Macro: __builtin_va_end(v)
pub export const @"va_end(v)" = 0;

/// The va_arg macro expands to an expression that has
/// the type and value of the next argument in the call.
/// The parameter v shall be the same as the va_list v
/// initialized by va_start. Each invocation of va_arg
/// modifies v so that the values of successive arguments
/// are returned in turn. The parameter type is a type
/// name specified such that the type of a pointer to an
/// object that has the specified type can be obtained
/// simply by postfixing a * to t. If there is no actual
/// next argument, or if t is not compatible with the type
/// of the actual next argument (as promoted according to
/// the default argument promotions), the behavior is
/// undefined.
/// The first invocation of the va_arg macro after that of the
/// va_start macro returns the value of the argument after
/// that specified by l. Successive invocations return
/// the values of the remaining arguments in succession.
/// Macro: __builtin_va_arg(v,t)
pub export const @"va_arg(v,t)" = 0;

/// Macro which is a type suitable for holding information
/// needed by the macros va_start, va_arg, and va_end.
/// If access to the varying arguments is desired, the
/// called function shall declare an object (referred to as v
/// in this header) having type va_list. The object v may be
/// passed as an argument to another function; if that function
/// invokes the va_arg macro with parameter v, the value of v
/// in the calling function is indeterminate and shall be
/// passed to the va_end macro prior to any further reference to v.
/// Macro: __builtin_va_list
pub export const va_list = 0;

//! The header <stdarg.h> declares a type and defines three
//! macros, for advancing through a list of arguments whose
//! number and types are not known to the called function
//! when it is translated. A function may be called with a
//! variable number of arguments of varying types.
//! Its parameter list contains one or more parameters.
//! The rightmost parameter plays a special role in the
//! access mechanism, and will be designated parmN in this
//! description.
//!
const c = @cImport(
    @cInclude("./include/stdarg.h"),
);

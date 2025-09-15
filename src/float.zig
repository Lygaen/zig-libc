//! The characteristics of floating types are
//! defined in terms of a model that describes a
//! representation of floating-point numbers and
//! values that provide information about an
//! implementation's floating-point arithmetic.
//!
//! Of the values in the <float.h> header,
//! FLT_RADIX shall be a constant expression
//! suitable for use in #if preprocessing
//! directives; all other values need not be
//! constant expressions. All except FLT_RADIX
//! and FLT_ROUNDS have separate names for all
//! three floating-point types. The
//! floating-point model representation is
//! provided for all values except FLT_ROUNDS.
//!
//! TODO: For the time being, doesn't implement
//! any LDBL_* macros.

pub const c = @cImport(
    @cInclude("./include/float.h"),
);

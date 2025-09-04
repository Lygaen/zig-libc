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

/// radix of exponent representation
pub export const FLT_RADIX = 2;

/// The rounding mode for floating-point
/// addition is characterized by the value of
/// FLT_ROUNDS : -1 indeterminable, 0 toward
/// zero, 1 to nearest, 2 toward positive infinity,
/// 3 toward negative infinity.
/// All other values for FLT_ROUNDS characterize
/// implementation-defined rounding behavior.
/// Implementation here assumes to nearest.
pub export const FLT_ROUNDS = 1;

/// number of base-FLT_RADIX digits in the floating-point mantissa
pub export const FLX_MANT_DIG = 24;
pub export const DBL_MANT_DIG = 53;
//pub export const LDBL_MANT_DIG = 0;

/// number of decimal digits of precision
pub export const FLT_DIG = 6;
pub export const DBL_DIG = 15;
//pub export const LDBL_DIG = 0;

/// minimum negative integer such that FLT_RADIX
/// raised to that power minus 1 is a normalized
/// floating-point number
pub export const FLT_MIN_EXP = (-125);
pub export const DBL_MIN_EXP = (-1021);
//pub export const LDBL_MIN_EXP = 0;

/// minimum negative integer such that 10 raised
/// to that power is in the range of normalized
/// floating-point numbers
pub export const FLT_MIN_10_EXP = (-37);
pub export const DBL_MIN_10_EXP = (-307);
//pub export const LDBL_MIN_10_EXP = 0;

/// maximum integer such that FLT_RADIX raised to
/// that power minus 1 is a representable finite
/// floating-point number
pub export const FLT_MAX_EXP = 128;
pub export const DBL_MAX_EXP = 1024;
//pub export const LDBL_MAX_EXP = 0;

/// maximum integer such that 10 raised to that
/// power is in the range of representable finite
/// floating-point numbers
pub export const FLT_MAX_10_EXP = 38;
pub export const DBL_MAX_10_EXP = 308;
//pub export const LDBL_MAX_10_EXP = 0;

/// maximum representable finite floating-point number
/// Macro: 3.40282346638528859812e+38F
pub export const FLT_MAX = 3.40282346638528859812e+38;
pub export const DBL_MAX = 1.79769313486231570815e+308;
//pub export const LDBL_MAX = 0;

/// minimum positive floating-point number x
pub export const FLT_EPSILON = 0;
pub export const DBL_EPSILON = 0;
//pub export const LDBL_EPSILON = 0;

/// minimum normalized positive floating-point number
/// Macro: 1.1920928955078125e-07F
pub export const FLT_MIN = 1.1920928955078125e-07;
pub export const DBL_MIN = 2.22507385850720138309e-308;
//pub export const LDBL_MIN = 0;

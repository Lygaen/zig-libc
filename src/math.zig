//! The header <math.h> declares several mathematical functions and defines one macro.
//! The functions take double-precision arguments and return double-precision values.
//!
//! For all functions, a domain error occurs if an input argument is outside the domain
//! over which the mathematical function is defined. The description of each function
//! lists any required domain errors; an implementation may define additional domain
//! errors, provided that such errors are consistent with the mathematical definition of
//! the function. On a domain error, the function returns an implementation-defined value;
//! the value of the macro EDOM is stored in errno.
//!
//! Similarly, a range error occurs if the result of the function cannot be represented as
//! a double value. If the result overflows (the magnitude of the result is so large that
//! it cannot be represented in an object of the specified type), the function returns the
//! value of the macro HUGE_VAL, with the same sign as the correct value of the function;
//! the value of the macro ERANGE is stored in errno. If the result underflows (the
//! magnitude of the result is so small that it cannot be represented in an object of the
//! specified type), the function returns zero; whether the integer expression errno acquires
//! the value of the macro ERANGE is implementation-defined.

const std = @import("std");
const math = std.math;

const errno = @import("errno.zig");

const c = @cImport(
    @cInclude("./include/math.h"),
);

pub export const HUGE_VAL = c.HUGE_VAL;

/// The acos function computes the principal value of the arc cosine of x.
/// A domain error occurs for arguments not in the range [-1, +1].
/// The acos function returns the arc cosine in the range [0, PI] radians.
/// Signature: double acos(double x)
pub export fn acos(x: f64) callconv(.c) f64 {
    const res = math.acos(x);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    return res;
}

/// The asin function computes the principal value of the arc sine of x.
/// A domain error occurs for arguments not in the range [-1, +1].
/// The asin function returns the arc sine in the range [-PI/2, +PI/2] radians.
/// Signature: double asin(double x)
pub export fn asin(x: f64) callconv(.c) f64 {
    const res = math.asin(x);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    return res;
}

/// The atan function computes the principal value of the arc tangent of x.
/// The atan function returns the arc tangent in the range [-PI/2, +PI/2] radians.
pub export fn atan(x: f64) callconv(.c) f64 {
    return math.atan(x);
}

/// The atan2 function computes the principal value of the arc tangent of y/x,
/// using the signs of both arguments to determine the quadrant of the return value.
/// A domain error may occur if both arguments are zero.
/// The atan2 function returns the arc tangent of y/x , in the range [-PI, +PI] radians.
pub export fn atan2(y: f64, x: f64) callconv(.c) f64 {
    const res = math.atan2(y, x);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    return res;
}

/// The cos function computes the cosine of x (measured in radians).
/// A large magnitude argument may yield a result with little or no significance.
/// The cos function returns the cosine value.
pub export fn cos(x: f64) callconv(.c) f64 {
    return math.cos(x);
}

/// The sin function computes the sine of x (measured in radians).
/// A large magnitude argument may yield a result with little or no significance.
/// The sin function returns the sine value.
pub export fn sin(x: f64) callconv(.c) f64 {
    return math.sin(x);
}

/// The tan function returns the tangent of x (measured in radians).
/// A large magnitude argument may yield a result with little or no significance.
/// The tan function returns the tangent value.
pub export fn tan(x: f64) callconv(.c) f64 {
    return math.tan(x);
}

/// The cosh function computes the hyperbolic cosine of x.
/// A range error occurs if the magnitude of x is too large.
/// The cosh function returns the hyperbolic cosine value.
pub export fn cosh(x: f64) callconv(.c) f64 {
    const res = math.cosh(x);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The sinh function computes the hyperbolic sine of x.
/// A range error occurs if the magnitude of x is too large.
/// The sinh function returns the hyperbolic sine value.
pub export fn sinh(x: f64) callconv(.c) f64 {
    const res = math.sinh(x);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The tanh function computes the hyperbolic tangent of x .
/// The tanh function returns the hyperbolic tangent value.
pub export fn tanh(x: f64) callconv(.c) f64 {
    const res = math.tanh(x);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The exp function computes the exponential function of x.
/// A range error occurs if the magnitude of x is too large.
/// The exp function returns the exponential value.
pub export fn exp(x: f64) callconv(.c) f64 {
    const res = math.exp(x);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The frexp function breaks a floating-point number into a normalized
/// fraction and an integral power of 2. It stores the integer in the
/// int object pointed to by exp. The frexp function returns the value x,
/// such that x is a double with magnitude in the interval [1/2, 1) or zero,
/// and value equals x times 2 raised to the power *exp.
/// If value is zero, both parts of the result are zero.
pub export fn frexp(value: f64, exponent: [*c]c_int) callconv(.c) f64 {
    const res = math.frexp(value);

    if (math.isNan(res.significand)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res.significand)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    exponent.* = res.exponent;
    return res.significand;
}

/// The ldexp function multiplies a floating-point number by an integral power of 2.
/// A range error may occur.
/// The ldexp function returns the value of x times 2 raised to the power exp .
pub export fn ldexp(x: f64, exponent: c_int) callconv(.c) f64 {
    const res = math.ldexp(x, exponent);

    if (math.isInf(res.significand)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The log function computes the natural logarithm of x.
/// A domain error occurs if the argument is negative.
/// A range error occurs if the argument is zero and the logarithm
/// of zero cannot be represented.
/// The log function returns the natural logarithm.
pub export fn log(x: f64) callconv(.c) f64 {
    const res = @log(x);

    if (math.isNan(res) or math.isInf(res)) // TODO: errno set to ERANGE
        return HUGE_VAL;

    return res;
}

/// The log10 function computes the base-ten logarithm of x.
/// A domain error occurs if the argument is negative.
/// A range error occurs if the argument is zero and the
/// logarithm of zero cannot be represented.
/// The log10 function returns the base-ten logarithm.
pub export fn log10(x: f64) callconv(.c) f64 {
    const res = @log10(x);

    if (math.isNan(res.significand)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res.significand)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The modf function breaks the argument value into integral and fractional parts,
/// each of which has the same sign as the argument. It stores the integral part
/// as a double in the object pointed to by iptr.
/// The modf function returns the signed fractional part of value.
pub export fn modf(value: f64, ipart: [*c]c_int) callconv(.c) f64 {
    const res = math.modf(value);

    if (math.isNan(res.fpart)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res.fpart)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    ipart.* = res.ipart;
    return res.fpart;
}

/// The pow function computes x raised to the power y.
/// A domain error occurs if x is negative and y is not an integer.
/// A domain error occurs if the result cannot be represented when
/// x is zero and y is less than or equal to zero. A range error may occur.
/// The pow function returns the value of x raised to the power y.
pub export fn pow(x: f64, y: f64) callconv(.c) f64 {
    const res = math.pow(f64, x, y);

    if (math.isNan(res)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The sqrt function computes the nonnegative square root of x.
/// A domain error occurs if the argument is negative.
/// The sqrt function returns the value of the square root.
pub export fn sqrt(x: f64) callconv(.c) f64 {
    const res = math.sqrt(x);

    if (math.isNan(res.fpart)) {
        errno.errno = errno.c.EDOM;
        return HUGE_VAL;
    }

    if (math.isInf(res.fpart)) {
        errno.errno = errno.c.ERANGE;
        return HUGE_VAL;
    }

    return res;
}

/// The ceil function computes the smallest integral value not less than x.
/// The ceil function returns the smallest integral value not less than x, expressed as a double.
pub export fn ceil(x: f64) callconv(.c) f64 {
    return math.ceil(x);
}

/// The fabs function computes the absolute value of a floating-point number x.
/// The fabs function returns the absolute value of x.
pub export fn fabs(x: f64) callconv(.c) f64 {
    return @abs(x);
}

/// The floor function computes the largest integral value not greater than x.
/// The floor function returns the largest integral value not greater than x, expressed as a double.
pub export fn floor(x: f64) callconv(.c) f64 {
    return math.floor(x);
}

/// The fmod function computes the floating-point remainder of x/y.
/// The fmod function returns the value x i y, for some integer i such that,
/// if y is nonzero, the result has the same sign as x and magnitude less than
/// the magnitude of y. If y is zero, whether a domain error occurs or
/// the fmod function returns zero is implementation-defined.
pub export fn fmod(x: f64, y: f64) callconv(.c) f64 {
    return math.mod(f64, x, y);
}

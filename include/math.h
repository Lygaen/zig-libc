#ifndef __MATH_H__
#define __MATH_H__

#define HUGE_VAL 1e5000

double acos(double x);

double asin(double x);

double atan(double x);

double atan2(double y, double x);

double cos(double x);

double sin(double x);

double tan(double x);

double cosh(double x);

double sinh(double x);

double tanh(double x);

double exp(double x);

double frexp(double value, int *exponent);

double ldexp(double x, int exponent);

double log(double x);

double log10(double x);

double modf(double value, int *ipart);

double pow(double x, double y);

double sqrt(double x);

double ceil(double x);

double fabs(double x);

double floor(double x);

double fmod(double x, double y);

#endif // __MATH_H__

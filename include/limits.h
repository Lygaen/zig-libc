#ifndef __LIMITS_H__
#define __LIMITS_H__

#include "__config.h"

#define SCHAR_MIN (-1 - SCHAR_MAX)
#if CHAR_MAX == SCHAR_MAX
#define CHAR_MIN SCHAR_MIN
#else
#define CHAR_MIN 0
#endif

#define UCHAR_MAX (SCHAR_MAX * 2U + 1U)

#define SHRT_MIN (-1 - SHRT_MAX)
#define USHRT_MAX (SHRT_MAX * 2 + 1)

#define INT_MIN (-1 - INT_MAX)
#define UINT_MAX (INT_MAX * 2U + 1U)


#define LONG_MIN (-1 - LONG_MAX)
#define ULONG_MAX (LONG_MAX * 2UL + 1UL)

#define MB_LEN_MAX 6

#endif // __LIMITS_H__

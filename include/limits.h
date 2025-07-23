#include "stddef.h"

// TODO: Do not rely on LLVM/Clang
// informations
#define CHAR_BIT __CHAR_BIT__
#define SCHAR_MAX __SCHAR_MAX__
#define SHRT_MAX __SHRT_MAX__
#define INT_MAX __INT_MAX__
#define LONG_MAX __LONG_MAX__
// #define LONG_LONG_MAX __LONG_LONG_MAX__

#define SCHAR_MIN (-SCHAR_MAX -1)
#define UCHAR_MAX (SCHAR_MAX * 2 + 1)

#define __IS_SIGNED(type) (((type)-1) < 0 )

#if __IS_SIGNED(char)
#define CHAR_MIN SCHAR_MIN
#define CHAR_MAX SCHAR_MAX
#else
#define CHAR_MIN 0
#define CHAR_MAX UCHAR_MAX
#endif

#define MB_LEN_MAX sizeof(wchar_t)

#define SHRT_MIN (-SHRT_MAX-1)
#define USHRT_MAX (SHRT_MAX * 2U + 1U)

#define INT_MIN (-INT_MAX - 1)
#define UINT_MAX (INT_MAX * 2U + 1U)

#define LONG_MIN (-LONG_MAX -1L)
#define ULONG_MAX (LONG_MAX * 2UL + 1UL)

// #define LONG_LONG_MIN (-LONG_LONG_MAX -1L)
// #define ULONG_LONG_MAX (LONG_LONG_MAX * 2ULL + 1ULL)

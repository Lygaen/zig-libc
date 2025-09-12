#ifndef __STDDEF_H__
#define __STDDEF_H__

#include "__config.h"

#define ptrdiff_t PTR_DIFF_TYPE

#define size_t SIZE_TYPE

#define wchar_t WCHAR_TYPE

#define NULL 0

#define offsetof(type, member) __builtin_offsetof(type, member)

#endif // __STDDEF_H__

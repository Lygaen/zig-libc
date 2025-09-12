#ifndef __ASSERT_H__
#define __ASSERT_H__

#define assert(x) __assert_impl(NDEBUG ? true : x, #x, __FILE__, __LINE__)

void __assert_impl(bool cond, char *assert_str, char *file, int line);

#endif // __ASSERT_H__

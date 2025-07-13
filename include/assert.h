#include "stdlib.h"

#ifdef NDEBUG
#define assert(condition) ((void)0)
#else
#define assert(condition) if(!condition) abort()
#endif

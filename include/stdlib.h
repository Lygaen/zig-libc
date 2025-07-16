#include "stddef.h"

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

// Allocation strategies
void *aligned_alloc(size_t alignement, size_t memory_size);
void *calloc(size_t element_count, size_t element_size);
void free(void* pointer);
void *malloc(size_t memory_size);
void* realloc(void* pointer, size_t memory_size);
// ---

// Exit strategies
void abort();

int atexit(void (*callback) (void));
void exit(int exit_code);

int at_quick_exit(void (*callback) (void));
void quick_exit(int exit_code);

void _Exit(int exit_code);
// ---

// System things
char* getenv(const char* name);
int system(const char* command);
// ---

// Algorithms
int abs(int value);
long labs(long value);
long long llabs(long long value);

typedef struct {
    int quot;
    int rem;
} div_t;
div_t div(int dividend, int divisor);

typedef struct {
    long quot;
    long rem;
} ldiv_t;
ldiv_t ldiv(long dividend, long divisor);

typedef struct {
    long long quot;
    long long rem;
} lldiv_t;
lldiv_t lldiv(long long dividend, long long divisor);

void* bsearch(const void* searchedValue, const void* array_ptr,
    size_t element_count, size_t element_size,
    int (*comparatorFunction)(const void *, const void *));
void qsort( void * array, size_t elementCount, size_t elementSize,
            int (*compareFunction)( const void*, const void* ) );

#define RAND_MAX 2147483647
int rand();
void srand( unsigned int seed );

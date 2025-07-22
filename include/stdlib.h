#include "stddef.h"

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

// String conversion functions
double strtod(const char *ptr, char **endptr);
double atof(const char* ptr);

long int strtol(const char *ptr, char **endptr, int base);
int atoi(const char* ptr);
long atol(const char* ptr);

unsigned long int strtoul(const char *ptr, char **endptr,
                  int base);

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

void* bsearch(const void* searched_value, const void* array_ptr,
    size_t element_count, size_t element_size,
    int (*comparator_function)(const void *, const void *));
void qsort(void * array, size_t element_count, size_t element_size,
            int (*compare_function)(const void*, const void*));

#define RAND_MAX 2147483647 // TODO: use INT_MAX
int rand();
void srand( unsigned int seed );

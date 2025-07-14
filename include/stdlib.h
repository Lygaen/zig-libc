#include "stddef.h"

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

//Find a way to implement without problems :(
//void *aligned_alloc(size_t alignement, size_t memory_size);
void *calloc(size_t element_count, size_t element_size);
void free(void* pointer);
void *malloc(size_t memory_size);
void* realloc(void* pointer, size_t memory_size);


void abort();

int atexit(void (*callback) (void));
void exit(int exit_code);

int at_quick_exit(void (*callback) (void));
void quick_exit(int exit_code);

void _Exit(int exit_code);


char* getenv(const char* name);
int system(const char* command);

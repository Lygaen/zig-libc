#include <stdlib.h>

int main(int argc, char** argv) {
    void* ptr = calloc(1, 10);
    ptr = realloc(ptr, 5);
    free(ptr);
    return 0;
}

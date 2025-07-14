#include <stdlib.h>

int main(int argc, char** argv) {
    void *ptr = malloc(10);
    free(ptr);

    ptr = calloc(sizeof(char), 10);
    for(int i = 0; i < 10; i++) {
        if(((char*)ptr)[i] != 0)
            return 1;
    }
    free(ptr);

    ptr = malloc(10);
    ptr = realloc(ptr, 5);
    free(ptr);

    return 0;
}

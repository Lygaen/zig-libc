#include <stddef.h>
#include <stdarg.h>
#include <assert.h>

void multiple(int num, ...) {
    va_list list;
    va_start(list, num);

    for(int i = 0; i < num; i++) {
        assert(va_arg(list, int) == i);
    }

    va_end(list);
}

int main() {
    assert(sizeof(void*) == sizeof(size_t));

    multiple(3, 0, 1, 2);
    multiple(4, 0, 1, 2, 3);
    multiple(0);
    multiple(-1);

    return 0;
}

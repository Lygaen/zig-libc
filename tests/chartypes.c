#include <assert.h>
#include <ctype.h>

const char* ALPHA_LOWER = "abcdefghijklmnopqrstuvwxyz";
const char* ALPHA_UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const char* XDIGITS = "0123456789ABCDFE";
int main() {
    for(int i = 0; i < 26; i++) {
        assert(isalpha(ALPHA_LOWER[i]));
        assert(isalnum(ALPHA_LOWER[i]));
        assert(isalpha(ALPHA_UPPER[i]));
        assert(isalnum(ALPHA_UPPER[i]));

        assert(islower(ALPHA_LOWER[i]));
        assert(!islower(ALPHA_UPPER[i]));
        assert(!isupper(ALPHA_LOWER[i]));
        assert(isupper(ALPHA_UPPER[i]));

        assert(ALPHA_UPPER[i] == toupper(ALPHA_LOWER[i]));
        assert(ALPHA_LOWER[i] == tolower(ALPHA_UPPER[i]));
    }

    for(int i = 0; i < 16; i++) {
        assert(isdigit(XDIGITS[i]) == i < 10);

        assert(isxdigit(XDIGITS[i]));
    }

    assert(isspace('\t'));
    assert(isspace(' '));
    return 0;
}

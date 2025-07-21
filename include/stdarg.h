// See https://clang.llvm.org/docs/LanguageExtensions.html#variadic-function-builtins
typedef __builtin_va_list va_list;

#define va_start(list, param) __builtin_va_start(list, param)
#define va_arg(list, type) __builtin_va_arg(list, type)
#define va_end(list) __builtin_va_end(list)

// TODO: va_copy ?

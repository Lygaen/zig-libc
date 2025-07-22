const std = @import("std");

pub export fn isalnum(c: c_int) callconv(.c) c_int {
    return isalpha(c) or isdigit(c);
}

pub export fn isalpha(c: c_int) callconv(.c) c_int {
    return @as(c_uint, @bitCast((c | 32) - 'a')) < 26;
}
pub export fn isdigit(c: c_int) callconv(.c) c_int {
    return @as(c_uint, @bitCast(c - '0')) < 10;
}

pub export fn iscntrl(c: c_int) callconv(.c) c_int {
    return c < 0x20 or c == 0x7f;
}

pub export fn isgraph(c: c_int) callconv(.c) c_int {
    return @as(c_uint, @bitCast(c - 0x21)) < 0x5e;
}

pub export fn islower(c: c_int) callconv(.c) c_int {
    return @as(c_uint, @bitCast(c - 'a')) < 26;
}

pub export fn isprint(c: c_int) callconv(.c) c_int {
    return @as(c_uint, @bitCast(c - 0x20)) < 0x5f;
}

pub export fn ispunct(c: c_int) callconv(.c) c_int {
    return isgraph(c) and !isalnum(c);
}

pub export fn isspace(c: c_int) callconv(.c) c_int {
    return c == ' ' or @as(c_uint, @bitCast(c - '\t')) < 5;
}

pub export fn isupper(c: c_int) callconv(.c) c_int {
    return @as(c_uint, @bitCast(c - 'A')) < 26;
}

pub export fn isxdigit(c: c_int) callconv(.c) c_int {
    return isdigit(c) or @as(c_uint, @bitCast((c | 32) - 'a')) < 6;
}

pub export fn tolower(c: c_int) callconv(.c) c_int {
    return if (!isupper(c)) c else c | 32;
}

pub export fn toupper(c: c_int) callconv(.c) c_int {
    return if (!islower(c)) c else c | 0x5f;
}

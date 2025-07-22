const std = @import("std");

pub export fn isalnum(c: c_int) callconv(.c) c_int {
    return @intFromBool(isalpha(c) == 1 or isdigit(c) == 1);
}

pub export fn isalpha(c: c_int) callconv(.c) c_int {
    return @intFromBool(@as(c_uint, @bitCast((c | 32) - 'a')) < 26);
}
pub export fn isdigit(c: c_int) callconv(.c) c_int {
    return @intFromBool(@as(c_uint, @bitCast(c - '0')) < 10);
}

pub export fn iscntrl(c: c_int) callconv(.c) c_int {
    return @intFromBool(c < 0x20 or c == 0x7f);
}

pub export fn isgraph(c: c_int) callconv(.c) c_int {
    return @intFromBool(@as(c_uint, @bitCast(c - 0x21)) < 0x5e);
}

pub export fn islower(c: c_int) callconv(.c) c_int {
    return @intFromBool(@as(c_uint, @bitCast(c - 'a')) < 26);
}

pub export fn isprint(c: c_int) callconv(.c) c_int {
    return @intFromBool(@as(c_uint, @bitCast(c - 0x20)) < 0x5f);
}

pub export fn ispunct(c: c_int) callconv(.c) c_int {
    return @intFromBool(isgraph(c) == 1 and isalnum(c) == 0);
}

pub export fn isspace(c: c_int) callconv(.c) c_int {
    return @intFromBool(c == ' ' or @as(c_uint, @bitCast(c - '\t')) < 5);
}

pub export fn isupper(c: c_int) callconv(.c) c_int {
    return @intFromBool(@as(c_uint, @bitCast(c - 'A')) < 26);
}

pub export fn isxdigit(c: c_int) callconv(.c) c_int {
    return @intFromBool(isdigit(c) == 1 or @as(c_uint, @bitCast((c | 32) - 'a')) < 6);
}

pub export fn tolower(c: c_int) callconv(.c) c_int {
    return if (isupper(c) == 0) c else c | 32;
}

pub export fn toupper(c: c_int) callconv(.c) c_int {
    return if (islower(c) == 0) c else c | 0x5f;
}

const globals = @import("globals.zig");

const c = @cImport({
    @cInclude("locale.h");
    @cInclude("limits.h");
});

const DEFAULT_C_LOCALE: c.lconv = .{
    .decimal_point = @constCast("."),
    .int_frac_digits = c.CHAR_MAX,
    .frac_digits = c.CHAR_MAX,
    .p_cs_precedes = c.CHAR_MAX,
    .p_sep_by_space = c.CHAR_MAX,
    .n_cs_precedes = c.CHAR_MAX,
    .n_sep_by_space = c.CHAR_MAX,
    .p_sign_posn = c.CHAR_MAX,
    .n_sign_posn = c.CHAR_MAX,
};

pub var conv: c.lconv = DEFAULT_C_LOCALE;

pub export fn localeconv() callconv(.c) [*c]c.lconv {
    return &conv;
}

pub export fn setlocale(category: c_int, locale: [*c]const u8) callconv(.c) [*c]u8 {
    _ = category;
    _ = locale;
    globals.trace("STUB - setlocale not implemented", @src(), .{});
    return null;
}

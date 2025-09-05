const std = @import("std");

pub const assert = @import("assert.zig");
pub const ctype = @import("ctype.zig");
pub const errno = @import("errno.zig");
pub const float = @import("float.zig");
pub const limits = @import("limits.zig");
pub const math = @import("math.zig");
pub const stdarg = @import("stdarg.zig");
pub const stddef = @import("stddef.zig");

const c = struct {
    extern fn main(argc: c_int, argv: [*:null]?[*c]u8) callconv(.c) c_int;
};

pub fn main() !u8 {
    const allocator = std.heap.smp_allocator;

    const temp_args = try std.process.argsAlloc(allocator);

    const args: [:null]?[*c]u8 = try allocator.allocSentinel(?[*c]u8, temp_args.len, null);
    defer allocator.free(args);

    for (temp_args, 0..) |arg, i| {
        args[i] = try allocator.dupeZ(u8, arg);
    }
    std.process.argsFree(allocator, temp_args);
    defer {
        for (args) |opt_arg| {
            if (opt_arg) |arg| {
                const span = std.mem.span(arg);
                allocator.free(span);
            }
        }
    }

    const ret = c.main(@intCast(args.len), args);

    return @intCast(ret);
}

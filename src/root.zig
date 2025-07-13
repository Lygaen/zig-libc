const std = @import("std");

const globals = @import("globals.zig");

pub usingnamespace @import("stdlib.zig");

const c = struct {
    extern fn main(argc: c_int, argv: [*c]?[*:0]u8) callconv(.C) c_int;
};

pub fn main() !u8 {
    globals.trace("Reaching entrypoint", @src(), .{});

    defer {
        const check = globals.gpa.deinit();
        if (check != .ok) {
            globals.trace("A leak was detected for the debug allocator", @src(), .{});
        }
    }

    const args = try argsAlloc();
    defer globals.allocator.free(args);

    const ret = c.main(@intCast(args.len), args.ptr);

    globals.trace("Main function exited with {}", @src(), .{ret});

    return @intCast(ret);
}

fn argsAlloc() ![:null]?[*:0]u8 {
    var argv = std.ArrayListUnmanaged(?[*:0]u8){};
    var it = try std.process.argsWithAllocator(globals.allocator);
    defer it.deinit();

    while (it.next()) |tmp_arg| {
        const arg = try globals.allocator.dupeZ(u8, tmp_arg);
        defer globals.allocator.free(arg);
        try argv.append(globals.allocator, arg);
    }
    return try argv.toOwnedSliceSentinel(globals.allocator, null);
}

const std = @import("std");

const globals = @import("globals.zig");
const stdlib = @import("stdlib.zig");

const c = struct {
    extern fn main(argc: c_int, argv: [*c]?[*:0]u8) callconv(.C) c_int;
};

export fn __main() callconv(.c) void {
    //WINDOWS compatibility stuff ?
    //Link error only on windows...
}

pub fn main() !void {
    globals.trace("Reaching entrypoint", @src(), .{});

    defer {
        const check = globals.gpa.deinit();
        if (check != .ok) {
            globals.trace("A leak was detected for the debug allocator", @src(), .{});
        }
    }

    stdlib.ENV_MAP = try loadENV();
    defer {
        var it = stdlib.ENV_MAP.iterator();

        while (it.next()) |kv| {
            globals.allocator.free(std.mem.span(kv.value_ptr.*));
        }
        stdlib.ENV_MAP.deinit();
    }

    const args = try argsAlloc();
    defer globals.allocator.free(args);

    const ret = c.main(@intCast(args.len), args.ptr);

    globals.trace("Main function exited with {}", @src(), .{ret});

    stdlib.exit(ret);
}

fn loadENV() !@TypeOf(stdlib.ENV_MAP) {
    var temp_map: @TypeOf(stdlib.ENV_MAP) = .init(globals.allocator);
    var env_map = try std.process.getEnvMap(globals.allocator);
    defer env_map.deinit();

    var it = env_map.iterator();
    while (it.next()) |kv| {
        const clone = try globals.allocator.dupeZ(u8, kv.value_ptr.*);
        try temp_map.put(kv.key_ptr.*, clone);
    }

    return temp_map;
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

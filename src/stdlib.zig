const std = @import("std");
const builtin = @import("builtin");

const globals = @import("globals.zig");

pub export fn abort() callconv(.c) noreturn {
    globals.trace("aborting program", @src(), .{});
    @panic("Program aborted");
}

var AT_EXIT_CALLBACKS = [_]?*const fn () callconv(.c) void{null} ** 32;
var AT_EXIT_MUTEX: std.Thread.Mutex = .{};

var AT_QUICK_EXIT_CALLBACKS = [_]?*const fn () callconv(.c) void{null} ** 32;
var AT_QUICK_EXIT_MUTEX: std.Thread.Mutex = .{};

export fn atexit(callback: *const fn () callconv(.c) void) callconv(.c) c_int {
    AT_EXIT_MUTEX.lock();
    defer AT_EXIT_MUTEX.unlock();

    for (&AT_EXIT_CALLBACKS) |*ptr| {
        if (ptr.* == null) {
            ptr.* = callback;
            globals.trace("Registering function {}", @src(), .{callback});
            return 0;
        }
    }

    globals.trace("Reached max-capacity for function {}", @src(), .{callback});
    return 1;
}

export fn at_quick_exit(callback: *const fn () callconv(.c) void) callconv(.c) c_int {
    AT_QUICK_EXIT_MUTEX.lock();
    defer AT_QUICK_EXIT_MUTEX.unlock();

    for (&AT_QUICK_EXIT_CALLBACKS) |*ptr| {
        if (ptr.* == null) {
            ptr.* = callback;
            globals.trace("Registering function {}", @src(), .{callback});
            return 0;
        }
    }

    globals.trace("Reached max-capacity for function {}", @src(), .{callback});
    return 1;
}

pub export fn exit(exit_code: c_int) callconv(.c) noreturn {
    AT_EXIT_MUTEX.lock();
    defer AT_EXIT_MUTEX.unlock();

    globals.trace("Clean exiting program", @src(), .{});

    for (AT_EXIT_CALLBACKS) |optional| {
        if (optional) |callback| {
            callback();
        }
    }

    _Exit(exit_code);
}

pub export fn quick_exit(exit_code: c_int) callconv(.c) noreturn {
    AT_QUICK_EXIT_MUTEX.lock();
    defer AT_QUICK_EXIT_MUTEX.unlock();

    globals.trace("Clean exiting program", @src(), .{});

    for (AT_QUICK_EXIT_CALLBACKS) |optional| {
        if (optional) |callback| {
            callback();
        }
    }

    _Exit(exit_code);
}

pub export fn _Exit(exit_code: c_int) callconv(.c) noreturn {
    globals.trace("Force exiting program", @src(), .{});
    std.process.exit(@intCast(exit_code));
}

pub var ENV_MAP: std.StringHashMap([*:0]u8) = undefined;

pub export fn getenv(name: ?[*:0]u8) ?[*:0]u8 {
    if (name == null) return null;
    globals.trace("Requesting env '{s}'", @src(), .{name.?});
    return ENV_MAP.get(std.mem.span(name.?)) orelse null;
}

pub export fn system(command: ?[*:0]u8) c_int {
    // Waiting for https://github.com/ziglang/zig/issues/23372 to be fixed
    globals.trace("STUB - System command {s}", @src(), .{command.?});
    return 1;

    // if (command == null) return 1;
    // globals.trace("System command {s}", @src(), .{command.?});

    // var iterator = std.mem.splitScalar(u8, std.mem.span(command.?), ' ');
    // var list: std.ArrayList([]const u8) = .init(globals.allocator);
    // defer list.deinit();
    // var env = std.process.getEnvMap(globals.allocator) catch return 1;
    // defer env.deinit();

    // while (iterator.next()) |split| {
    //     list.append(split) catch return 1;
    // }

    // const result = std.process.Child.run(.{
    //     .allocator = globals.allocator,
    //     .argv = list.items,
    //     .env_map = &env,
    // }) catch return 1;

    // return switch (result.term) {
    //     .Exited => |ex| ex,
    //     .Signal, .Stopped, .Unknown => |sig| @intCast(sig),
    // };
}

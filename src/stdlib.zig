const std = @import("std");
const builtin = @import("builtin");

const globals = @import("globals.zig");

const MAX_ALIGN = 16;

comptime {
    if (MAX_ALIGN * 8 < @bitSizeOf(usize))
        @compileError("Usize is wayyyy too big.");
}

pub export fn malloc(memory_size: usize) callconv(.c) ?*anyopaque {
    const ptr = globals.allocator.alignedAlloc(u8, MAX_ALIGN, memory_size + MAX_ALIGN) catch return null;
    std.mem.writeInt(usize, ptr[0..@sizeOf(usize)], @intCast(memory_size), .little);

    globals.trace("Allocating {} bytes at 0x{X}", @src(), .{ memory_size, @intFromPtr(ptr.ptr) + MAX_ALIGN });

    return ptr.ptr + MAX_ALIGN;
}

pub export fn aligned_alloc(alignement: usize, memory_size: usize) callconv(.c) ?*anyopaque {
    _ = alignement;
    globals.trace("STUB - passing to malloc", @src(), .{});
    return malloc(memory_size);
}

pub export fn calloc(element_count: usize, element_size: usize) callconv(.c) ?*anyopaque {
    const size = element_count * element_size;
    const ptr = malloc(size);

    if (ptr != null) {
        globals.trace("Zeroing memory at 0x{X}", @src(), .{@intFromPtr(ptr)});
        @memset(@as([*]u8, @ptrCast(ptr.?))[0..size], 0);
    }

    return ptr;
}

pub export fn free(pointer: ?*anyopaque) callconv(.c) void {
    if (pointer == null) return;

    const len_ptr: [*]align(MAX_ALIGN) u8 = @ptrFromInt(@intFromPtr(pointer.?) - MAX_ALIGN);
    const total_len = std.mem.readInt(usize, len_ptr[0..@sizeOf(usize)], .little) + MAX_ALIGN;

    globals.trace("Freeing {} bytes at 0x{X}", @src(), .{ total_len - MAX_ALIGN, @intFromPtr(pointer) });

    globals.allocator.free(len_ptr[0..total_len]);
}

pub export fn realloc(pointer: ?*anyopaque, memory_size: usize) callconv(.c) ?*anyopaque {
    if (pointer == null) return null;

    const len_ptr: [*]align(MAX_ALIGN) u8 = @ptrFromInt(@intFromPtr(pointer.?) - MAX_ALIGN);
    const total_len = std.mem.readInt(usize, len_ptr[0..@sizeOf(usize)], .little) + MAX_ALIGN;

    globals.trace("Reallocating {}->{} bytes at 0x{X}", @src(), .{ total_len - MAX_ALIGN, memory_size, @intFromPtr(pointer) });

    const ptr = globals.allocator.realloc(len_ptr[0..total_len], memory_size + MAX_ALIGN) catch return null;

    std.mem.writeInt(usize, ptr[0..@sizeOf(usize)], memory_size, .little);

    return ptr.ptr + MAX_ALIGN;
}

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

fn TypedAbs(comptime T: type) *const anyopaque {
    return &(struct {
        pub fn abs(val: T) callconv(.c) T {
            return @intCast(@abs(val));
        }
    }.abs);
}

comptime {
    @export(TypedAbs(c_int), .{ .name = "abs", .linkage = .strong });
    @export(TypedAbs(c_long), .{ .name = "labs", .linkage = .strong });
    @export(TypedAbs(c_longlong), .{ .name = "llabs", .linkage = .strong });
}

fn TypedDiv(comptime T: type) *const anyopaque {
    const Return = packed struct {
        quot: T,
        rem: T,
    };

    return &(struct {
        pub fn div(num: T, dividend: T) callconv(.c) Return {
            return Return{
                .quot = @divFloor(num, dividend),
                .rem = @mod(num, dividend),
            };
        }
    }.div);
}

comptime {
    @export(TypedDiv(c_int), .{ .name = "div", .linkage = .strong });
    @export(TypedDiv(c_long), .{ .name = "ldiv", .linkage = .strong });
    @export(TypedDiv(c_longlong), .{ .name = "lldiv", .linkage = .strong });
}

pub export fn bsearch(searched_value: ?*anyopaque, array_ptr: ?*anyopaque, element_count: usize, element_size: usize, comparator: *const fn (?*anyopaque, ?*anyopaque) callconv(.c) c_int) callconv(.c) ?*anyopaque {
    if (array_ptr == null)
        return null;

    var low: usize = 0;
    var high: usize = element_count;

    while (low < high) {
        const mid = low + (high - low) / 2;
        const ptr: ?*anyopaque = @ptrFromInt(@intFromPtr(array_ptr.?) + mid * element_size);
        const comp = comparator(searched_value, ptr);

        switch (comp) {
            0 => return ptr,
            1 => low = mid + 1,
            -1 => high = mid,
            else => return null,
        }
    }

    return null;
}

// Seed the random engine with random numbers at runtime
var RANDOM_ENGINE: std.Random.DefaultPrng = .init(0x00);

pub export fn rand() callconv(.c) c_int {
    return RANDOM_ENGINE.random().int(c_int);
}

pub export fn srand(seed: c_uint) callconv(.c) void {
    RANDOM_ENGINE.seed(@intCast(seed));
}

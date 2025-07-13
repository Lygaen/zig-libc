const std = @import("std");
const builtin = @import("builtin");

const options = @import("options");

pub var gpa: std.heap.DebugAllocator(.{
    .MutexType = std.Thread.Mutex,
}) = .init;

pub const is_debug_allocator = builtin.mode == .Debug or builtin.mode == .ReleaseSafe;
pub var allocator = if (is_debug_allocator) gpa.allocator() else std.heap.smp_allocator;

pub fn trace(comptime format: []const u8, comptime src: std.builtin.SourceLocation, args: anytype) void {
    if (!options.trace) return;

    const writer = std.io.getStdErr().writer();
    writer.writeAll("[TRACE] LIBC '" ++ src.fn_name ++ "' : ") catch return;
    std.fmt.format(writer, format, args) catch return;
    writer.writeAll("\n") catch return;
}

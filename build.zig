const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libc_mod = b.addModule("zig-libc", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = false,
        .link_libcpp = false,
    });

    const libc_lib = b.addLibrary(.{
        .name = "zig-libc",
        .root_module = libc_mod,
    });
    b.installArtifact(libc_lib);

    { // Docs step
        const install_docs = b.addInstallDirectory(.{
            .source_dir = libc_lib.getEmittedDocs(),
            .install_dir = .prefix,
            .install_subdir = "docs",
        });

        const docs_step = b.step("docs", "Install docs into $PREFIX/docs");
        docs_step.dependOn(&install_docs.step);
    }

    { // Header generation
        const header_conf = b.addConfigHeader(
            .{
                .style = .{ .autoconf_undef = b.path("include/__config.h.in") },
            },
            .{},
        );
        generateConfigValues(b, target.result, header_conf) catch @panic("Unable to generate config header values");

        const header_conf_install = b.addInstallHeaderFile(header_conf.getOutput(), "__config.h");
        header_conf_install.step.dependOn(&header_conf.step);
        b.getInstallStep().dependOn(&header_conf_install.step);

        libc_mod.addConfigHeader(header_conf);

        const dir = std.fs.cwd().openDir("./include/", .{
            .iterate = true,
        }) catch @panic("Include folder not found");
        libc_mod.addIncludePath(b.path("."));
        var files = dir.iterate();

        while (files.next() catch null) |file| {
            const ext = std.fs.path.extension(file.name);
            if (!std.mem.eql(u8, ".h", ext))
                continue;

            const file_step = b.addInstallHeaderFile(
                b.path(b.pathJoin(&.{ "./include/", file.name })),
                file.name,
            );
            b.getInstallStep().dependOn(&file_step.step);
        }
    }

    { // Check step
        const libc_check = b.addLibrary(.{
            .name = "zig-libc-check",
            .root_module = libc_mod,
        });
        const check = b.step("check", "Check if libc compiles");
        check.dependOn(&libc_check.step);
    }
}

const float_types = [_]std.Target.CType{ .float, .double, .longdouble };

fn computeTypeMax(target: std.Target, allocator: std.mem.Allocator, comptime ctype: std.Target.CType, force_sign: ?std.builtin.Signedness) []const u8 {
    if (comptime std.mem.containsAtLeastScalar(std.Target.CType, &float_types, 1, ctype)) {
        @compileError("Floating-point max is not supported");
    }

    const is_signed = blk: {
        if (force_sign) |sign| {
            break :blk sign == .signed;
        }

        if (ctype == .char) {
            break :blk target.cCharSignedness() == .signed;
        }

        const signed_types = [_]std.Target.CType{ .short, .int, .long, .longlong };
        break :blk std.mem.containsAtLeastScalar(std.Target.CType, &signed_types, 1, ctype);
    };

    const bit_size = target.cTypeBitSize(ctype);
    const max_value = blk: {
        if (is_signed) {
            break :blk std.math.pow(i128, 2, bit_size - 1) - 1;
        }

        break :blk std.math.pow(i128, 2, bit_size) - 1;
    };
    return std.fmt.allocPrint(allocator, "0x{X}", .{max_value}) catch "OOM";
}

pub fn computeFixedType(
    target: std.Target,
    allocator: std.mem.Allocator,
    signedness: std.builtin.Signedness,
    bit_size: u16,
) []const u8 {
    const c_type = blk: {
        inline for (@typeInfo(std.Target.CType).@"enum".fields) |field| {
            const temp: std.Target.CType = @enumFromInt(field.value);
            const is_unsigned = std.mem.startsWith(u8, field.name, "u");

            const has_same_sign = is_unsigned == (signedness == .unsigned);
            const has_same_size = target.cTypeBitSize(temp) == bit_size;

            if (has_same_size and has_same_sign)
                break :blk temp;
        }

        @panic(
            std.fmt.allocPrint(
                allocator,
                "Could not compute fixed type of size '{}' bits",
                .{bit_size},
            ) catch @panic("OOM"),
        );
    };

    const ctype_type_string: std.EnumArray(std.Target.CType, ?[]const u8) = .init(.{
        .char = "char",
        .short = "short",
        .ushort = "unsigned short",
        .int = "int",
        .uint = "unsigned int",
        .long = "long",
        .ulong = "unsigned long",
        .longlong = "long long",
        .ulonglong = "unsigned long long",

        .float = null,
        .double = null,
        .longdouble = null,
    });
    const t_string = ctype_type_string.get(c_type);

    if (t_string == null) {
        @panic(
            std.fmt.allocPrint(
                allocator,
                "Could not get string equivalent of c_type {s}",
                .{@tagName(c_type)},
            ) catch @panic("OOM"),
        );
    }

    return t_string.?;
}

fn addValueIdent(conf: *std.Build.Step.ConfigHeader, key: []const u8, value: []const u8) void {
    conf.values.put(key, .{ .ident = value }) catch @panic("OOM");
}

pub fn generateConfigValues(
    b: *std.Build,
    target: std.Target,
    conf: *std.Build.Step.ConfigHeader,
) !void {
    var arena: std.heap.ArenaAllocator = .init(b.allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    conf.addValue("CHAR_BIT", i32, target.cTypeBitSize(.char));

    addValueIdent(
        conf,
        "CHAR_MAX",
        computeTypeMax(
            target,
            allocator,
            .char,
            null,
        ),
    );
    addValueIdent(
        conf,
        "SCHAR_MAX",
        computeTypeMax(
            target,
            allocator,
            .char,
            .signed,
        ),
    );

    addValueIdent(
        conf,
        "SHORT_MAX",
        computeTypeMax(
            target,
            allocator,
            .short,
            null,
        ),
    );
    addValueIdent(
        conf,
        "INT_MAX",
        computeTypeMax(
            target,
            allocator,
            .int,
            null,
        ),
    );
    addValueIdent(
        conf,
        "LONG_MAX",
        computeTypeMax(
            target,
            allocator,
            .long,
            null,
        ),
    );

    addValueIdent(
        conf,
        "WCHAR_TYPE",
        computeFixedType(
            target,
            allocator,
            .signed,
            4 * 8,
        ),
    );

    const ptr_bit_size = target.ptrBitWidth();
    addValueIdent(
        conf,
        "PTR_DIFF_TYPE",
        computeFixedType(
            target,
            allocator,
            .signed,
            ptr_bit_size,
        ),
    );
    addValueIdent(
        conf,
        "SIZE_TYPE",
        computeFixedType(
            target,
            allocator,
            .unsigned,
            ptr_bit_size,
        ),
    );
}

const std = @import("std");
const Ast = std.zig.Ast;

var target: std.Target = undefined;

pub const Export = struct {
    value: union(enum) {
        container_comment: void,
        function: struct {
            name: []const u8,
            return_type: []const u8,
            c_params: []const u8,
        },
        constant: struct {
            name: []const u8,
            value: []const u8,
        },
        extern_variable: struct {
            name: []const u8,
            c_type: []const u8,
        },
    },
    comment: []const u8,

    pub fn fromFunctionProto(allocator: std.mem.Allocator, comment: []const u8, fn_proto: Ast.full.FnProto, ast: *const Ast) !?Export {
        const is_pub = fn_proto.visib_token != null;
        if (!is_pub) return null;

        const name = ast.tokenSlice(fn_proto.name_token orelse unreachable);

        const ret_type_fn = fn_proto.ast.return_type.unwrap() orelse return error.NoReturnType;
        const ret_type_slice = ast.tokenSlice(ast.firstToken(ret_type_fn));

        var allocating: std.io.Writer.Allocating = try .initCapacity(allocator, 100);
        var writer = &allocating.writer;
        var param_iterator = fn_proto.iterate(ast);
        var is_first = true;

        while (param_iterator.next()) |param| {
            if (!is_first) {
                try writer.writeAll(", ");
            }
            is_first = false;

            const nt = param.name_token orelse return error.UnnamedParameter;
            const name_slice = ast.tokenSlice(nt);
            const type_index = param.type_expr orelse return error.UntypedParameter;
            const type_slice = try zigTypeToC(allocator, ast.getNodeSource(type_index));
            defer allocator.free(type_slice);

            try writer.print("{s} {s}", .{ type_slice, name_slice });
        }

        return .{
            .comment = comment,
            .value = .{
                .function = .{
                    .name = try allocator.dupe(u8, name),
                    .return_type = try zigTypeToC(allocator, ret_type_slice),
                    .c_params = try allocating.toOwnedSlice(),
                },
            },
        };
    }

    pub fn fromVariableProto(allocator: std.mem.Allocator, comment: []const u8, var_proto: Ast.full.VarDecl, ast: *const Ast) !?Export {
        const is_pub = var_proto.visib_token != null;
        const is_export = var_proto.extern_export_token != null;
        var name = ast.tokenSlice(var_proto.ast.mut_token + 1);

        if (std.mem.startsWith(u8, name, "@\"")) {
            name = name[2 .. name.len - 1];
        }

        if (!is_pub)
            return null;

        if (is_export and std.mem.eql(u8, ast.tokenSlice(var_proto.extern_export_token orelse unreachable), "extern")) {
            std.debug.print("Invalid definition for {s}\n", .{name});
            return null;
        }

        const is_const = std.mem.eql(u8, ast.tokenSlice(var_proto.ast.mut_token), "const");

        if (is_const) {
            const init_index = var_proto.ast.init_node.unwrap() orelse {
                std.debug.print("Constant {s} does not define a value\n", .{name});
                return null;
            };
            var init_slice = ast.getNodeSource(init_index);

            const MACRO_EXPANSION = "Macro: ";
            var doc_comment = comment;
            if (std.mem.lastIndexOf(u8, comment, MACRO_EXPANSION)) |i| {
                init_slice = try expandSpecialMacro(allocator, comment[i + MACRO_EXPANSION.len ..]);
                doc_comment = doc_comment[0..i];
                if (i != 0) {
                    doc_comment = doc_comment[0 .. i - 1];
                }
            } else {
                init_slice = try allocator.dupe(u8, init_slice);
            }

            return .{
                .comment = doc_comment,
                .value = .{
                    .constant = .{
                        .name = try allocator.dupe(u8, name),
                        .value = init_slice,
                    },
                },
            };
        }

        const type_index = var_proto.ast.type_node.unwrap() orelse {
            std.debug.print("Variable {s} does not define a type\n", .{name});
            return null;
        };

        const t_slice = ast.tokenSlice(ast.firstToken(type_index));

        return .{
            .comment = comment,
            .value = .{
                .extern_variable = .{
                    .name = try allocator.dupe(u8, name),
                    .c_type = try zigTypeToC(allocator, t_slice),
                },
            },
        };
    }

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        allocator.free(self.comment);

        switch (self.value) {
            .function => |f| {
                allocator.free(f.name);
                allocator.free(f.c_params);
            },
            .extern_variable => |e| {
                allocator.free(e.name);
            },
            .constant => |c| {
                allocator.free(c.name);
                allocator.free(c.value);
            },
            else => {},
        }
    }
};

pub const ExportsMap = std.json.ArrayHashMap([]Export);

fn computeMinMaxCType(c_type: std.Target.CType, is_min: bool) isize {
    const is_signed = blk: {
        if (c_type == .char) {
            break :blk target.cCharSignedness() == .signed;
        }
        const signed_types = [_]std.Target.CType{
            .short, .int, .long, .longlong,
        };
        break :blk std.mem.containsAtLeast(
            std.Target.CType,
            &signed_types,
            1,
            &.{c_type},
        );
    };

    const size = target.cTypeBitSize(c_type);
    if (is_signed) {
        var max = std.math.powi(isize, 2, size - 1) catch @panic("Too big type");
        max -= 1;
        if (is_min)
            return (-1 - max);
        return max;
    } else {
        if (is_min)
            return 0;
        return std.math.pow(isize, 2, size) - 1;
    }
}

fn expandSpecialMacro(allocator: std.mem.Allocator, macro: []const u8) ![]const u8 {
    const MacroEvals = enum {
        __CHAR_MIN__,
        __CHAR_MAX__,
        __CHAR_BIT__,
        __SCHAR_MAX__,
        __SHRT_MAX__,
        __INT_MAX__,
        __LONG_MAX__,
        __PTR_TYPE__,
    };

    const eval = std.meta.stringToEnum(MacroEvals, macro);
    if (eval == null) {
        return try allocator.dupe(u8, macro);
    }

    return switch (eval.?) {
        .__CHAR_MIN__ => try std.fmt.allocPrint(
            allocator,
            "{}",
            .{computeMinMaxCType(
                .char,
                true,
            )},
        ),
        .__CHAR_MAX__ => try std.fmt.allocPrint(
            allocator,
            "{}",
            .{
                computeMinMaxCType(
                    .char,
                    false,
                ),
            },
        ),
        .__CHAR_BIT__ => try std.fmt.allocPrint(
            allocator,
            "{}",
            .{target.cTypeBitSize(.char)},
        ),
        .__SCHAR_MAX__ => try std.fmt.allocPrint(
            allocator,
            "{}",
            .{computeMinMaxCType(
                .char,
                false,
            )},
        ),
        .__SHRT_MAX__ => try std.fmt.allocPrint(
            allocator,
            "{}",
            .{computeMinMaxCType(
                .short,
                false,
            )},
        ),
        .__INT_MAX__ => try std.fmt.allocPrint(
            allocator,
            "{}",
            .{computeMinMaxCType(
                .int,
                false,
            )},
        ),
        .__LONG_MAX__ => try std.fmt.allocPrint(
            allocator,
            "{}",
            .{computeMinMaxCType(
                .int,
                false,
            )},
        ),
        .__PTR_TYPE__ => blk: {
            const ptr_bit_size = target.ptrBitWidth();
            const fields = @typeInfo(std.Target.CType).@"enum".fields;

            inline for (fields) |efield| {
                const ctype: std.Target.CType = @enumFromInt(efield.value);
                if (ctype == .double or ctype == .float or ctype == .longdouble)
                    continue;

                if (ptr_bit_size == target.cTypeBitSize(ctype)) {
                    break :blk try allocator.dupe(u8, efield.name);
                }
            }

            return error.UnrepresentablePointer;
        },
    };
}

pub fn generateHeaders(b: *std.Build, lib: *std.Build.Step.Compile) !void {
    target = lib.rootModuleTarget();

    var exports_map: ExportsMap = .{
        .map = try .init(b.allocator, &.{}, &.{}),
    };
    defer {
        var iter = exports_map.map.iterator();
        while (iter.next()) |entries| {
            for (entries.value_ptr.*) |*e| {
                e.deinit(b.allocator);
            }
        }
        exports_map.deinit(b.allocator);
    }

    var src_dir = try std.fs.cwd().openDir("./src/", .{
        .iterate = true,
        .no_follow = true,
    });
    defer src_dir.close();

    var src_dir_it = src_dir.iterate();
    var reader_buffer: [1000]u8 = @splat(0x00);
    while (try src_dir_it.next()) |entry| {
        if (entry.kind != .file)
            continue;

        if (std.mem.eql(u8, entry.name, "root.zig"))
            continue;

        std.debug.print("Analyzing {s}\n", .{entry.name});

        const file = try src_dir.openFile(entry.name, .{});
        defer file.close();
        var reader = file.reader(&reader_buffer);

        const file_content = try std.zig.readSourceFileToEndAlloc(
            b.allocator,
            &reader,
        );
        defer b.allocator.free(file_content);

        var ast = try Ast.parse(b.allocator, file_content, .zig);
        defer ast.deinit(b.allocator);

        const exports = try generateExports(b.allocator, ast);

        try exports_map.map.put(b.allocator, std.fs.path.stem(entry.name), exports);
    }

    const step = b.step("headers", "Generate headers");
    b.getInstallStep().dependOn(step);

    var iter = exports_map.map.iterator();
    var files = b.addWriteFiles();
    step.dependOn(&files.step);

    while (iter.next()) |entry| {
        const filename = try std.fmt.allocPrint(b.allocator, "{s}.h", .{entry.key_ptr.*});
        defer b.allocator.free(filename);

        const fcontent = try generateCHeaderFile(b.allocator, entry.key_ptr.*, entry.value_ptr.*);
        defer b.allocator.free(fcontent);

        const istep = b.addInstallHeaderFile(files.add(filename, fcontent), filename);
        step.dependOn(&istep.step);
    }
}

pub fn generateCHeaderFile(allocator: std.mem.Allocator, name: []const u8, exports: []Export) ![]const u8 {
    var allocating: std.io.Writer.Allocating = try .initCapacity(allocator, 1000);
    var writer = &allocating.writer;
    const name_upper = allocator.alloc(u8, name.len) catch @panic("OOM");
    defer allocator.free(name_upper);
    _ = std.ascii.upperString(name_upper, name);

    var opt_container_comment: ?*Export = null;

    for (exports) |*exp| {
        if (exp.value == .container_comment) {
            opt_container_comment = exp;
            break;
        }
    }

    if (opt_container_comment) |container_comment| {
        try writer.print("/* \n", .{});
        var split = std.mem.splitScalar(u8, container_comment.comment, '\n');
        while (split.next()) |sp| {
            try writer.print(" * {s}\n", .{sp});
        }
        try writer.print(" * \n * Generated using Zig from the zig-libc project", .{});
        try writer.print(" */\n\n", .{});
    }

    try writer.print("#ifndef __{s}_H__\n", .{name_upper});
    try writer.print("#define __{s}_H__\n\n", .{name_upper});

    for (exports) |*exp| {
        if (exp.value == .container_comment)
            continue;

        //try writer.print("\n", .{});

        if (exp.comment.len != 0) {
            var split = std.mem.splitScalar(u8, exp.comment, '\n');
            while (split.next()) |sp| {
                try writer.print("// {s}\n", .{sp});
            }
        }

        switch (exp.value) {
            .container_comment => {},
            .constant => |c| {
                try writer.print("#define {s} {s}\n", .{ c.name, c.value });
            },
            .function => |f| {
                try writer.print("{s} {s}({s});\n", .{ f.return_type, f.name, f.c_params });
            },
            .extern_variable => |e| {
                try writer.print("extern {s} {s};\n", .{ e.c_type, e.name });
            },
        }
        try writer.print("\n", .{});
    }

    try writer.print("#endif // __{s}_H__", .{name_upper});
    try writer.flush();

    return try allocating.toOwnedSlice();
}

fn zigTypeToC(allocator: std.mem.Allocator, t: []const u8) ![]const u8 {
    const TYPES_MAP: std.StaticStringMap([]const u8) = .initComptime(.{
        .{ "c_char", "char" },
        .{ "c_short", "short" },
        .{ "c_ushort", "unsigned short" },
        .{ "c_int", "int" },
        .{ "c_uint", "unsigned int" },
        .{ "c_ulong", "unsigned long" },
        .{ "c_longlong", "long long" },
        .{ "c_ulonglong", "unsigned long long" },
        .{ "c_longdouble", "long double" },
        .{ "f32", "float" },
        .{ "f64", "double" },
        .{ "f80", "long double" },
        .{ "bool", "bool" },
        .{ "anyopaque", "void" },
    });

    if (std.mem.startsWith(u8, t, "[*c]")) {
        const slice = try zigTypeToC(allocator, t["[*c]".len..]);
        defer allocator.free(slice);
        var temp = try allocator.alloc(u8, slice.len + 1);

        for (slice, 0..) |c, i| {
            temp[i] = c;
        }
        temp[slice.len] = '*';
        return temp;
    }

    return try allocator.dupe(u8, TYPES_MAP.get(t) orelse {
        std.debug.print("Unknown type {s}\n", .{t});
        return try allocator.dupe(u8, "UNKNOWN_TYPE");
    });
}

fn searchDocComment(ast: *const Ast, allocator: std.mem.Allocator, main_token: u32) ![]const u8 {
    var t = main_token;
    var buff: std.ArrayList(u8) = try .initCapacity(allocator, 0);

    while (t > 0) {
        t -= 1;
        switch (ast.tokens.items(.tag)[t]) {
            .doc_comment => {
                const sl = ast.tokenSlice(t);
                if (sl.len == 3) {
                    try buff.insert(allocator, 0, '\n');
                    continue;
                }

                const doc = sl["/// ".len..];
                if (buff.items.len != 0) {
                    try buff.insert(allocator, 0, '\n');
                }
                try buff.insertSlice(allocator, 0, doc);
                continue;
            },
            .keyword_pub, .keyword_export => continue,
            else => break,
        }
    }

    return buff.toOwnedSlice(allocator);
}

fn searchContainerDocComment(ast: *const Ast, allocator: std.mem.Allocator, main_token: u32) ![]const u8 {
    var t = main_token;
    var buff: std.ArrayList(u8) = try .initCapacity(allocator, 0);

    while (t > 0) {
        t -= 1;
        switch (ast.tokens.items(.tag)[t]) {
            .container_doc_comment => {
                const sl = ast.tokenSlice(t);
                if (sl.len == 3) {
                    try buff.insert(allocator, 0, '\n');
                    continue;
                }

                const doc = sl["//! ".len..];
                if (buff.items.len != 0) {
                    try buff.insert(allocator, 0, '\n');
                }
                try buff.insertSlice(allocator, 0, doc);
                continue;
            },
            else => continue,
        }
    }

    return buff.toOwnedSlice(allocator);
}

fn generateExports(allocator: std.mem.Allocator, ast: Ast) ![]Export {
    const root_declarations = ast.rootDecls();
    const nodes = ast.nodes;
    var exports: std.ArrayList(Export) = try .initCapacity(allocator, 1);

    exports.appendAssumeCapacity(.{
        .comment = try searchContainerDocComment(&ast, allocator, @intCast(ast.tokens.len - 1)),
        .value = .container_comment,
    });

    for (root_declarations) |declaration| {
        const declaration_index: usize = @intCast(@intFromEnum(declaration));
        const declaration_tag: Ast.Node.Tag = nodes.items(.tag)[declaration_index];

        if (declaration_tag == .fn_decl) {
            var buffer: [1]std.zig.Ast.Node.Index = undefined;
            const function_proto = ast.fullFnProto(
                &buffer,
                declaration,
            ) orelse continue;
            const doc_comment = try searchDocComment(&ast, allocator, function_proto.firstToken());

            const exp = try Export.fromFunctionProto(
                allocator,
                doc_comment,
                function_proto,
                &ast,
            );

            if (exp == null)
                continue;

            try exports.append(
                allocator,
                exp.?,
            );
        } else if (declaration_tag == .simple_var_decl) {
            const var_proto = ast.fullVarDecl(declaration) orelse unreachable;
            const doc_comment = try searchDocComment(&ast, allocator, var_proto.firstToken());

            const exp = try Export.fromVariableProto(
                allocator,
                doc_comment,
                var_proto,
                &ast,
            );

            if (exp == null)
                continue;

            try exports.append(
                allocator,
                exp.?,
            );
        }
    }

    return exports.toOwnedSlice(allocator);
}

pub fn Settings(
    comptime display_name: []const u8,
    comptime Spec: type,
    comptime constraints: anytype,
) type {
    const info = switch (@typeInfo(Spec)) {
        .@"struct" => |value| value,
        else => @compileError("settings spec must be a struct"),
    };
    if (display_name.len == 0) {
        @compileError("settings category must not be empty");
    }
    inline for (display_name) |ch| {
        if (ch < 0x20 or ch > 0x7e) {
            @compileError("settings category must be printable ASCII");
        }
    }
    if (display_name.len >= 0xFFFF) {
        @compileError("settings category name must fit in u16 length field");
    }
    inline for (info.fields) |field| {
        if (field.defaultValue() == null) {
            @compileError("settings field '" ++ field.name ++ "' requires a default value");
        }
        if (field.type != bool and field.type != i64 and field.type != f64 and
            field.type != i32 and field.type != u32 and field.type != f32)
        {
            @compileError("unsupported settings field type: " ++ @typeName(field.type) ++ " on '" ++ field.name ++ "'");
        }
    }
    _ = constraints;

    return struct {
        pub const Data = Spec;
        pub var data: Data = .{};
        pub const category_name = normalizeCategoryId(display_name);

        fn normalizeCategoryId(comptime category: []const u8) []const u8 {
            comptime {
                var buffer: [category.len]u8 = undefined;
                for (category, 0..) |ch, i| {
                    buffer[i] = switch (ch) {
                        'A'...'Z' => ch + ('a' - 'A'),
                        'a'...'z', '0'...'9' => ch,
                        else => '_',
                    };
                }
                const final = buffer;
                return &final;
            }
        }
    };
}

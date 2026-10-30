pub const Color = struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

pub fn argbToHost(color: u32) u32 {
    _ = color;
    return undefined;
}

pub fn containsAsciiLower(haystack: []const u8, needle_lower: []const u8) bool {
    _ = haystack;
    _ = needle_lower;
    return undefined;
}

pub fn copyText(dst: []u8, src: []const u8) usize {
    _ = dst;
    _ = src;
    return undefined;
}

pub const math = @import("math.zig");
pub const random = @import("random.zig");

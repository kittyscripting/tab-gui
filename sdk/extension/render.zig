const runtime = @import("runtime");
const Vec2 = runtime.Vec2;
const Vec3 = runtime.Vec3;
const Quat = runtime.Quat;
pub const elements = @import("render/elements/root.zig");

pub fn viewport() Vec2 {
    return undefined;
}

pub fn scale() f32 {
    return undefined;
}

pub fn windowPos() Vec2 {
    return undefined;
}

pub fn windowSize() Vec2 {
    return undefined;
}

pub fn clientPos() Vec2 {
    return undefined;
}

pub fn clientSize() Vec2 {
    return undefined;
}

pub fn titlebarHeight() f32 {
    return undefined;
}

pub fn uploadBitmap(bgra: []const u8, w: u32, h: u32) u32 {
    _ = bgra;
    _ = w;
    _ = h;
    return undefined;
}

pub fn freeTexture(texid: u32) void {
    _ = texid;
}

pub fn drawTexture(texid: u32, x: f32, y: f32) void {
    _ = texid;
    _ = x;
    _ = y;
}

pub fn drawTextureScaled(texid: u32, x: f32, y: f32, w: f32, h: f32) void {
    _ = texid;
    _ = x;
    _ = y;
    _ = w;
    _ = h;
}

pub fn drawLine(x1: f32, y1: f32, x2: f32, y2: f32, color: i32) void {
    _ = x1;
    _ = y1;
    _ = x2;
    _ = y2;
    _ = color;
}

pub fn drawRect(x: f32, y: f32, w: f32, h: f32, color: i32, line_width: f32) void {
    _ = x;
    _ = y;
    _ = w;
    _ = h;
    _ = color;
    _ = line_width;
}

pub fn drawFilledRect(x: f32, y: f32, w: f32, h: f32, color: i32) void {
    _ = x;
    _ = y;
    _ = w;
    _ = h;
    _ = color;
}
pub fn drawCircle(x: f32, y: f32, radius: f32, color: i32, filled: bool) void {
    _ = x;
    _ = y;
    _ = radius;
    _ = color;
    _ = filled;
}

pub fn drawGradientLine(x1: f32, y1: f32, x2: f32, y2: f32, color1: i32, color2: i32) void {
    _ = x1;
    _ = y1;
    _ = x2;
    _ = y2;
    _ = color1;
    _ = color2;
}

pub fn drawGradientRect(x: f32, y: f32, w: f32, h: f32, top_left: i32, top_right: i32, bottom_right: i32, bottom_left: i32) void {
    _ = x;
    _ = y;
    _ = w;
    _ = h;
    _ = top_left;
    _ = top_right;
    _ = bottom_right;
    _ = bottom_left;
}

pub fn drawRadialCircle(x: f32, y: f32, radius: f32, center: i32, edge: i32) void {
    _ = x;
    _ = y;
    _ = radius;
    _ = center;
    _ = edge;
}

pub fn drawGradientTriangle(x0: f32, y0: f32, x1: f32, y1: f32, x2: f32, y2: f32, color0: i32, color1: i32, color2: i32) void {
    _ = x0;
    _ = y0;
    _ = x1;
    _ = y1;
    _ = x2;
    _ = y2;
    _ = color0;
    _ = color1;
    _ = color2;
}

pub fn drawText(text: []const u8, x: f32, y: f32, size: f32, color: i32) void {
    _ = text;
    _ = x;
    _ = y;
    _ = size;
    _ = color;
}

pub fn drawTextCentered(text: []const u8, x: f32, y: f32, size: f32, color: i32) void {
    _ = text;
    _ = x;
    _ = y;
    _ = size;
    _ = color;
}

pub fn drawTextFmt(comptime fmt: []const u8, args: anytype, x: f32, y: f32, size: f32, color: i32) void {
    _ = fmt;
    _ = args;
    _ = x;
    _ = y;
    _ = size;
    _ = color;
}

pub fn drawTextCenteredFmt(comptime fmt: []const u8, args: anytype, x: f32, y: f32, size: f32, color: i32) void {
    _ = fmt;
    _ = args;
    _ = x;
    _ = y;
    _ = size;
    _ = color;
}

pub fn drawSphere3D(center: Vec3, radius: f32, color: i32) void {
    _ = center;
    _ = radius;
    _ = color;
}
pub fn drawWireSphere3D(center: Vec3, radius: f32, color: i32) void {
    _ = center;
    _ = radius;
    _ = color;
}

pub fn drawCapsule3D(a: Vec3, b: Vec3, radius: f32, color: i32) void {
    _ = a;
    _ = b;
    _ = radius;
    _ = color;
}

pub fn drawWireCapsule3D(a: Vec3, b: Vec3, radius: f32, color: i32) void {
    _ = a;
    _ = b;
    _ = radius;
    _ = color;
}

pub fn drawBox3D(center: Vec3, half_extents: Vec3, rotation: Quat, color: i32) void {
    _ = center;
    _ = half_extents;
    _ = rotation;
    _ = color;
}

pub fn drawBox3DWireframe(center: Vec3, half_extents: Vec3, rotation: Quat, color: i32) void {
    _ = center;
    _ = half_extents;
    _ = rotation;
    _ = color;
}

pub fn drawGradientSphere3D(center: Vec3, radius: f32, color_a: i32, color_b: i32, axis: Vec3) void {
    _ = center;
    _ = radius;
    _ = color_a;
    _ = color_b;
    _ = axis;
}

pub fn drawGradientCapsule3D(a: Vec3, b: Vec3, radius: f32, color_a: i32, color_b: i32) void {
    _ = a;
    _ = b;
    _ = radius;
    _ = color_a;
    _ = color_b;
}

pub fn drawGradientBox3D(center: Vec3, half_extents: Vec3, rotation: Quat, color_a: i32, color_b: i32, axis: Vec3) void {
    _ = center;
    _ = half_extents;
    _ = rotation;
    _ = color_a;
    _ = color_b;
    _ = axis;
}

pub fn rgba(r: i32, g: i32, b: i32, a: i32) i32 {
    _ = r;
    _ = g;
    _ = b;
    _ = a;
    return undefined;
}

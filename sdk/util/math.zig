const std = @import("std");
const runtime = @import("runtime");

pub const pi: f32 = @floatCast(std.math.pi);

pub const tau: f32 = pi * 2.0;

pub const rad_to_deg: f32 = 180.0 / pi;

pub const deg_to_rad: f32 = pi / 180.0;

pub fn normalizeRadians(radians: f32) f32 {
    _ = radians;
    return undefined;
}

pub fn clampPitch(pitch: f32) f32 {
    _ = pitch;
    return undefined;
}

pub fn angleDeg(a: runtime.Vec3, b: runtime.Vec3) f32 {
    _ = a;
    _ = b;
    return undefined;
}

pub fn yawPitch(dir: runtime.Vec3) runtime.Vec2 {
    _ = dir;
    return undefined;
}

pub fn fromYawPitch(yaw: f32, pitch: f32) runtime.Vec3 {
    _ = yaw;
    _ = pitch;
    return undefined;
}

pub fn u32ToF32(value: u32) f32 {
    _ = value;
    return undefined;
}

pub fn clampU32(value: u32, low: u32, high: u32) u32 {
    _ = value;
    _ = low;
    _ = high;
    return undefined;
}

pub fn accuracyMul(accuracy: u32) f32 {
    _ = accuracy;
    return undefined;
}

pub fn tickDeltaSeconds(now_seconds: f32, last_seconds: *f32) f32 {
    _ = now_seconds;
    _ = last_seconds;
    return undefined;
}

pub fn logf(x: f32) f32 {
    _ = x;
    return undefined;
}

pub fn expf(x: f32) f32 {
    _ = x;
    return undefined;
}

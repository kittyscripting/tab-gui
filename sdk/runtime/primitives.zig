const math = @import("math.zig");
const Vec3 = math.Vec3;
const Quat = math.Quat;

pub const Line = extern struct {
    from: Vec3,
    to: Vec3,
};

pub const Sphere = extern struct {
    center: Vec3,
    radius: f32,
};

pub const Capsule = extern struct {
    a: Vec3,
    b: Vec3,
    radius: f32,
};

pub const Box = extern struct {
    center: Vec3,
    half_extents: Vec3,
    rotation: Quat,
};

pub fn exit(code: i32) void {
    _ = code;
}

const math_mod = @import("math.zig");
pub const sinf = math_mod.sinf;
pub const cosf = math_mod.cosf;
pub const tanf = math_mod.tanf;
pub const asinf = math_mod.asinf;
pub const acosf = math_mod.acosf;
pub const atan2f = math_mod.atan2f;
pub const powf = math_mod.powf;
pub const clampf = math_mod.clampf;
pub const lerpf = math_mod.lerpf;
pub const distance = math_mod.distance;
pub const normalizeAngle = math_mod.normalizeAngle;
pub const random = math_mod.random;
pub const seedRandom = math_mod.seedRandom;
pub const Vec2 = math_mod.Vec2;
pub const Vec3 = math_mod.Vec3;
pub const Vec4 = math_mod.Vec4;
pub const Quat = math_mod.Quat;
pub const Mat4 = math_mod.Mat4;
const primitives_mod = @import("primitives.zig");
pub const Line = primitives_mod.Line;
pub const Sphere = primitives_mod.Sphere;
pub const Capsule = primitives_mod.Capsule;
pub const Box = primitives_mod.Box;
const log_mod = @import("log.zig");
pub const log = log_mod.log;
pub const info = log_mod.info;
pub const warn = log_mod.warn;
pub const err = log_mod.err;
pub const logCount = log_mod.logCount;
pub const logHistory = log_mod.logHistory;
const system_time_mod = @import("system_time.zig");
pub const SystemTime = system_time_mod.SystemTime;
pub const systemTime = system_time_mod.systemTime;

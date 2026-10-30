const runtime = @import("runtime");

pub const Transform = struct {
    position: runtime.Vec3 = .{},
    rotation: runtime.Quat = .{},
    velocity: runtime.Vec3 = .{},
};

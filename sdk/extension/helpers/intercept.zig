const runtime = @import("runtime");

pub const Intercept = struct {
    position: runtime.Vec3,
    time: f32,
};

pub fn linearIntercept(
    shooter: runtime.Vec3,
    target: runtime.Vec3,
    velocity: runtime.Vec3,
    projectile_speed: f32,
) ?Intercept {
    _ = shooter;
    _ = target;
    _ = velocity;
    _ = projectile_speed;
    return undefined;
}

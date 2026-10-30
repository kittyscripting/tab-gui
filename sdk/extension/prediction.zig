const runtime = @import("runtime");
const Actor = @import("actor.zig").Actor;
const Vec3 = runtime.Vec3;

pub fn predict(actor: *const Actor, projectile_speed: f32, projectile_gravity: f32, projectile_launch_angle: f32, time_addition: f32) ?Vec3 {
    _ = actor;
    _ = projectile_speed;
    _ = projectile_gravity;
    _ = projectile_launch_angle;
    _ = time_addition;
    return undefined;
}

pub fn refine(actor: *const Actor, aim_point: Vec3, projectile_speed: f32, projectile_gravity: f32, projectile_launch_angle: f32) Vec3 {
    _ = actor;
    _ = aim_point;
    _ = projectile_speed;
    _ = projectile_gravity;
    _ = projectile_launch_angle;
    return undefined;
}

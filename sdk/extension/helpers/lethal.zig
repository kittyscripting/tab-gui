const runtime = @import("runtime");
const AimSlotRef = @import("slots.zig").AimSlotRef;
const Actor = @import("../actor.zig").Actor;
const Vec3 = runtime.Vec3;

pub fn shotDamage(damage: f32, critical_multiplier: f32, charge: f32, critical: bool) f32 {
    _ = damage;
    _ = critical_multiplier;
    _ = charge;
    _ = critical;
    return undefined;
}

pub fn kills(damage: f32, critical_multiplier: f32, charge: f32, critical: bool, health: f32) bool {
    _ = damage;
    _ = critical_multiplier;
    _ = charge;
    _ = critical;
    _ = health;
    return undefined;
}

pub fn rayKills(slot: AimSlotRef, actor: *const Actor, ray_start: Vec3, ray_dir: Vec3, lead: Vec3, scale: f32) bool {
    _ = slot;
    _ = actor;
    _ = ray_start;
    _ = ray_dir;
    _ = lead;
    _ = scale;
    return undefined;
}

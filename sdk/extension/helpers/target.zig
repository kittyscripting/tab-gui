const runtime = @import("runtime");
const Vec3 = runtime.Vec3;
const Actor = @import("../actor.zig").Actor;
const LocalActor = @import("../local_actor.zig").LocalActor;
const slots = @import("slots.zig");
const EffectTarget = @import("../gun.zig").EffectTarget;

pub const fov_reference_distance: f32 = 10.0;

pub fn fovRadius(fov_deg: f32) f32 {
    _ = fov_deg;
    return undefined;
}

pub fn isInFov(eye: Vec3, view_dir: Vec3, point: Vec3, fov_deg: f32) bool {
    _ = eye;
    _ = view_dir;
    _ = point;
    _ = fov_deg;
    return undefined;
}

pub const AimTarget = struct {
    actor: *Actor,
    aim_point: Vec3,
    priority: f32,
    is_valid: bool,
    trigger_only: bool = false,
};

pub const HitboxPick = enum {
    defined,
    head,
    body,
    origin,
    nearest,
};

pub const TargetScore = enum {
    fitts,
    crosshair,
};

pub const TargetCtx = struct {
    fov_deg: f32,
    fov_scale: f32 = 1.0,
    swap_delay_ms: f32 = 150.0,
    lock_target: bool = false,
    hitbox: HitboxPick = .defined,
    score: TargetScore = .fitts,
    max_range: f32 = 0,
    reject_unnatural_motion: bool = false,
    effect_target: EffectTarget = .enemy,
    owned_target_def: u64 = 0,
};

pub fn keyedEffectTarget(slot_target: EffectTarget, primary_down: bool, ally_down: bool) ?EffectTarget {
    _ = slot_target;
    _ = primary_down;
    _ = ally_down;
    return undefined;
}

pub fn firesOtherWeapon(local: *const LocalActor, slot: slots.AimSlotRef) bool {
    _ = local;
    _ = slot;
    return undefined;
}

pub const TargetTracker = struct {
    pub fn reset(self: *TargetTracker) void {
        _ = self;
    }
    pub fn step(self: *TargetTracker, actors: []Actor, local: *LocalActor, ctx: TargetCtx, now_ms: f32) AimTarget {
        _ = self;
        _ = actors;
        _ = local;
        _ = ctx;
        _ = now_ms;
        return undefined;
    }
};

pub fn isObject(actor: *const Actor) bool {
    _ = actor;
    return undefined;
}

pub fn pickAimPoint(actor: *Actor, mode: HitboxPick, eye: Vec3, view_dir: Vec3) ?Vec3 {
    _ = actor;
    _ = mode;
    _ = eye;
    _ = view_dir;
    return undefined;
}

pub fn combineMaxRange(a: f32, b: f32) f32 {
    _ = a;
    _ = b;
    return undefined;
}

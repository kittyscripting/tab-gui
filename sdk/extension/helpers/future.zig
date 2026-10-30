const runtime = @import("runtime");
const motion = @import("motion.zig");
const Actor = @import("../actor.zig").Actor;
const AimSlotRef = @import("slots.zig").AimSlotRef;
const Vec3 = runtime.Vec3;
const Tracker = motion.MotionTracker(Vec3);
const Config = motion.Config;

pub const hold_scale: f32 = 0.8;

pub const max_samples: usize = 6;

pub fn knownSeconds(actor: *const Actor) f32 {
    _ = actor;
    return undefined;
}

pub fn nextFireSeconds(slot: AimSlotRef) f32 {
    _ = slot;
    return undefined;
}

pub const Shot = struct {
    projectile_speed: f32 = 0,
    projectile_gravity: f32 = 0,
    projectile_launch_angle: f32 = 0,
    pub fn of(slot: AimSlotRef) Shot {
        _ = slot;
        return undefined;
    }
};

pub fn shotOffset(actor: *const Actor, shot: Shot, fire_in: f32, rhythm: ?*const Tracker, config: Config) Vec3 {
    _ = actor;
    _ = shot;
    _ = fire_in;
    _ = rhythm;
    _ = config;
    return undefined;
}

pub fn hitsWithin(actor: *const Actor, shot: Shot, eye: Vec3, eye_velocity: Vec3, view_dir: Vec3, fire_in: f32, slack: f32, scale: f32, critical_only: bool, rhythm: ?*const Tracker, config: Config) bool {
    _ = actor;
    _ = shot;
    _ = eye;
    _ = eye_velocity;
    _ = view_dir;
    _ = fire_in;
    _ = slack;
    _ = scale;
    _ = critical_only;
    _ = rhythm;
    _ = config;
    return undefined;
}

pub const Observed = struct {
    changes: motion.Changes = .{},
    horizontal_age: f32 = 0,
    vertical_age: f32 = 0,
};

pub fn observe(tracker: *Tracker, actor: *const Actor, now_ms: f32, config: Config) Observed {
    _ = tracker;
    _ = actor;
    _ = now_ms;
    _ = config;
    return undefined;
}

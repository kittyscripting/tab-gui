const runtime = @import("runtime");
const motion = @import("motion.zig");
const future = @import("future.zig");
const target = @import("target.zig");
const Actor = @import("../actor.zig").Actor;
const LocalActor = @import("../local_actor.zig").LocalActor;
const Vec3 = runtime.Vec3;

pub fn targetInFov(actors: []Actor, local: *LocalActor, ctx: target.TargetCtx) bool {
    _ = actors;
    _ = local;
    _ = ctx;
    return undefined;
}

pub fn predictionRange(base_range: f32, projectile_speed: f32) f32 {
    _ = base_range;
    _ = projectile_speed;
    return undefined;
}

pub const Engagement = struct {
    target_id: ?i32 = null,
    pub fn step(self: *Engagement, tracker: *target.TargetTracker, actors: []Actor, local: *LocalActor, ctx: target.TargetCtx, now_ms: f32) ?target.AimTarget {
        _ = self;
        _ = tracker;
        _ = actors;
        _ = local;
        _ = ctx;
        _ = now_ms;
        return undefined;
    }
    pub fn end(self: *Engagement) void {
        _ = self;
    }
};

pub const TargetMotion = struct {
    tracker: motion.MotionTracker(Vec3) = .{},
    pub fn observe(self: *TargetMotion, actor: *const Actor, now_ms: f32, config: motion.Config) future.Observed {
        _ = self;
        _ = actor;
        _ = now_ms;
        _ = config;
        return undefined;
    }
    pub fn teleported(self: *TargetMotion, seen: future.Observed, accuracy: u32, now_ms: f32) bool {
        _ = self;
        _ = seen;
        _ = accuracy;
        _ = now_ms;
        return undefined;
    }
    pub fn reset(self: *TargetMotion) void {
        _ = self;
    }
};

pub fn motionAborts(seen: future.Observed, accuracy_mul: f32) bool {
    _ = seen;
    _ = accuracy_mul;
    return undefined;
}

pub const VerticalGuard = struct {
    pub fn hold(self: *VerticalGuard, view_dir: Vec3, target_dir: Vec3, now_ms: f32, accuracy_mul: f32) bool {
        _ = self;
        _ = view_dir;
        _ = target_dir;
        _ = now_ms;
        _ = accuracy_mul;
        return undefined;
    }
};

pub const CrossingWait = struct {
    start_ms: ?f32 = null,
    pub fn wait(self: *CrossingWait, actor: *const Actor, shot: future.Shot, eye: Vec3, eye_velocity: Vec3, view_dir: Vec3, fire_in: f32, now_ms: f32, critical_only: bool, movement_ms: f32, rhythm: *const motion.MotionTracker(Vec3), config: motion.Config) bool {
        _ = self;
        _ = actor;
        _ = shot;
        _ = eye;
        _ = eye_velocity;
        _ = view_dir;
        _ = fire_in;
        _ = now_ms;
        _ = critical_only;
        _ = movement_ms;
        _ = rhythm;
        _ = config;
        return undefined;
    }
};

pub fn frontLean(actor: *const Actor, eye: Vec3, projectile_speed: f32) Vec3 {
    _ = actor;
    _ = eye;
    _ = projectile_speed;
    return undefined;
}

pub fn criticalRadius(actor: *const Actor) f32 {
    _ = actor;
    return undefined;
}

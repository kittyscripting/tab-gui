const runtime = @import("runtime");
const Actor = @import("../actor.zig").Actor;
const Vec3 = runtime.Vec3;

pub const fire_hitbox_scale: f32 = 0.98;

pub const follow_end_weight: f32 = 0.05;

pub const Stroke = struct {
    active: bool = false,
    target_id: i32 = 0,
    movement_ms: f32 = 0.0,
    pub fn start(self: *Stroke, view_dir: Vec3, target_dir: Vec3, angular_dist_deg: f32, movement_ms: f32, accuracy: u32) void {
        _ = self;
        _ = view_dir;
        _ = target_dir;
        _ = angular_dist_deg;
        _ = movement_ms;
        _ = accuracy;
    }
    pub fn elapsedMs(self: *const Stroke, now_ms: f32) f32 {
        _ = self;
        _ = now_ms;
        return undefined;
    }
    pub fn complete(self: *const Stroke, elapsed_ms: f32) bool {
        _ = self;
        _ = elapsed_ms;
        return undefined;
    }
    pub fn crossingMs(self: *Stroke) f32 {
        _ = self;
        return undefined;
    }
    pub fn replan(self: *Stroke, view_dir: Vec3, target_dir: Vec3, now_ms: f32, dt_ms: f32) bool {
        _ = self;
        _ = view_dir;
        _ = target_dir;
        _ = now_ms;
        _ = dt_ms;
        return undefined;
    }
    pub fn steerDir(self: *Stroke, eye: Vec3, aim_point: Vec3, target_velocity: Vec3, elapsed_ms: f32, dt: f32) Vec3 {
        _ = self;
        _ = eye;
        _ = aim_point;
        _ = target_velocity;
        _ = elapsed_ms;
        _ = dt;
        return undefined;
    }
    pub fn step(self: *Stroke, view_dir: Vec3, elapsed_ms: f32, dt_seconds: f32, aim_dir: Vec3, fired: bool) Vec3 {
        _ = self;
        _ = view_dir;
        _ = elapsed_ms;
        _ = dt_seconds;
        _ = aim_dir;
        _ = fired;
        return undefined;
    }
    pub fn playerCoveredPlan(self: *const Stroke, fired: bool) bool {
        _ = self;
        _ = fired;
        return undefined;
    }
    pub fn playerTookOver(self: *const Stroke, actor: *const Actor, eye: Vec3, fired: bool) bool {
        _ = self;
        _ = actor;
        _ = eye;
        _ = fired;
        return undefined;
    }
    pub fn beginFollow(self: *Stroke, done: bool) bool {
        _ = self;
        _ = done;
        return undefined;
    }
    pub fn followWeightAt(self: *const Stroke, elapsed_ms: f32) f32 {
        _ = self;
        _ = elapsed_ms;
        return undefined;
    }
    pub fn followEnded(self: *const Stroke, elapsed_ms: f32) bool {
        _ = self;
        _ = elapsed_ms;
        return undefined;
    }
    pub fn followStep(self: *Stroke, view_dir: Vec3, eye: Vec3, aim_point: Vec3, target_velocity: Vec3, now_ms: f32, dt: f32) ?Vec3 {
        _ = self;
        _ = view_dir;
        _ = eye;
        _ = aim_point;
        _ = target_velocity;
        _ = now_ms;
        _ = dt;
        return undefined;
    }
    pub fn canReachHitbox(self: *const Stroke, actor: *const Actor, eye: Vec3, aim_dir: Vec3, lead: Vec3, critical_only: bool) bool {
        _ = self;
        _ = actor;
        _ = eye;
        _ = aim_dir;
        _ = lead;
        _ = critical_only;
        return undefined;
    }
};

pub fn pitchStrength(accuracy: u32) f32 {
    _ = accuracy;
    return undefined;
}

pub fn speedMovementMs(speed: u32) f32 {
    _ = speed;
    return undefined;
}

pub fn movementTimeMs(full_ms: f32, angular_dist_deg: f32, width_deg: f32) f32 {
    _ = full_ms;
    _ = angular_dist_deg;
    _ = width_deg;
    return undefined;
}

pub fn arrivalMs(actor: *const Actor, eye: Vec3, view_dir: Vec3, target_dir: Vec3, lead: Vec3, movement_ms: f32, accuracy: u32, critical_only: bool) f32 {
    _ = actor;
    _ = eye;
    _ = view_dir;
    _ = target_dir;
    _ = lead;
    _ = movement_ms;
    _ = accuracy;
    _ = critical_only;
    return undefined;
}

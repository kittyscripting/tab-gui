const runtime = @import("runtime");
const Vec3 = runtime.Vec3;

pub fn boxCorners(box: anytype) [8]Vec3 {
    _ = box;
    return undefined;
}

pub fn targetWidthDeg(actor: anytype, eye: Vec3) f32 {
    _ = actor;
    _ = eye;
    return undefined;
}

pub fn targetRadius(actor: anytype) f32 {
    _ = actor;
    return undefined;
}

pub const YawPitchDelta = struct {
    yaw: f32,
    pitch: f32,
    magnitude: f32,
};

pub fn yawPitchDistance(view_dir: Vec3, dir_to_target: Vec3) YawPitchDelta {
    _ = view_dir;
    _ = dir_to_target;
    return undefined;
}

pub fn perturbDirection(base_dir: Vec3, yaw_rad: f32, pitch_rad: f32) Vec3 {
    _ = base_dir;
    _ = yaw_rad;
    _ = pitch_rad;
    return undefined;
}

pub fn hasUsableHitboxes(actor: anytype, critical_only: bool) bool {
    _ = actor;
    _ = critical_only;
    return undefined;
}

pub fn pointInHitboxes(actor: anytype, point: Vec3, critical_only: bool) bool {
    _ = actor;
    _ = point;
    _ = critical_only;
    return undefined;
}

pub fn rayHitsHitboxes(actor: anytype, ray_start: Vec3, ray_dir: Vec3, lead: Vec3, scale: f32, critical_only: bool) bool {
    _ = actor;
    _ = ray_start;
    _ = ray_dir;
    _ = lead;
    _ = scale;
    _ = critical_only;
    return undefined;
}

pub fn rayHitboxEntryDistance(actor: anytype, from: Vec3, to: Vec3) ?f32 {
    _ = actor;
    _ = from;
    _ = to;
    return undefined;
}

pub const SweepHit = struct {
    t: f32,
    dir: Vec3,
    distance: f32,
};

pub fn sweepHit(actor: anytype, eye: Vec3, from: Vec3, to: Vec3, lead: Vec3, margin: f32, critical_only: bool) ?SweepHit {
    _ = actor;
    _ = eye;
    _ = from;
    _ = to;
    _ = lead;
    _ = margin;
    _ = critical_only;
    return undefined;
}

pub fn nearestHitboxPoint(actor: anytype, eye: Vec3, view_dir: Vec3, critical_only: bool) ?Vec3 {
    _ = actor;
    _ = eye;
    _ = view_dir;
    _ = critical_only;
    return undefined;
}

pub const settleDriftRadPerSec: f32 = 0.01;

pub const approachBlend: f32 = 0.35;

pub const attackSeconds: f32 = 0.08;

pub const releaseSeconds: f32 = 0.2;

pub const Action = enum {
    steer,
    follow,
    idle,
};

pub fn action(inside: bool, driftRadPerSec: f32) Action {
    _ = inside;
    _ = driftRadPerSec;
    return undefined;
}

pub const Transition = struct {
    blend: f32 = 0.0,
    pub fn reset(self: *Transition) void {
        _ = self;
    }
    pub fn update(self: *Transition, dt: f32, inside: bool, driftRadPerSec: f32) void {
        _ = self;
        _ = dt;
        _ = inside;
        _ = driftRadPerSec;
    }
};

pub fn followShare(smoothness: u32) f32 {
    _ = smoothness;
    return undefined;
}

pub const biasGainPerSec: f32 = 10.0;

pub const biasCap: f32 = 1.0;

pub const leadSeconds: f32 = 0.1;

pub const maxLeadFraction: f32 = 0.5;

pub fn biasGain(smoothness: u32) f32 {
    _ = smoothness;
    return undefined;
}

pub fn leadGoal(core: anytype, relVelPerp: @TypeOf(core), lead_seconds: f32, max_lead: f32) @TypeOf(core) {
    _ = relVelPerp;
    _ = lead_seconds;
    _ = max_lead;
    return undefined;
}

pub fn biasDisplacement(rayPoint: anytype, goal: @TypeOf(rayPoint), viewDir: @TypeOf(rayPoint), relVelPerp: @TypeOf(rayPoint), dt: f32, gain: f32, cap: f32) @TypeOf(rayPoint) {
    _ = goal;
    _ = viewDir;
    _ = relVelPerp;
    _ = dt;
    _ = gain;
    _ = cap;
    return undefined;
}

pub fn followDirection(eye: anytype, viewDir: @TypeOf(eye), targetPos: @TypeOf(eye), relVel: @TypeOf(eye), dt: f32, strength: @TypeOf(eye), bias: @TypeOf(eye)) ?@TypeOf(eye) {
    _ = viewDir;
    _ = targetPos;
    _ = relVel;
    _ = dt;
    _ = strength;
    _ = bias;
    return undefined;
}

pub fn driftRate(eyePos: anytype, eyeVel: @TypeOf(eyePos), targetPos: @TypeOf(eyePos), targetVel: @TypeOf(eyePos)) f32 {
    _ = eyeVel;
    _ = targetPos;
    _ = targetVel;
    return undefined;
}

pub fn corePoint(hitboxes: anytype, eye: anytype, viewDir: @TypeOf(eye), lead: @TypeOf(eye)) ?@TypeOf(eye) {
    _ = hitboxes;
    _ = viewDir;
    _ = lead;
    return undefined;
}

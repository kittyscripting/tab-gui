const runtime = @import("runtime");

pub const TraceMask = packed struct(u64) {
    geometry: bool = false,
    _world_reserved: u7 = 0,
    players: bool = false,
    turrets: bool = false,
    explosives: bool = false,
    supports: bool = false,
    unknown_kind: bool = false,
    props: bool = false,
    _class_reserved: u10 = 0,
    self: bool = false,
    allies: bool = false,
    enemies: bool = false,
    neutral: bool = false,
    unknown_team: bool = false,
    _relation_reserved: u3 = 0,
    _reserved: u32 = 0,
    pub const world: TraceMask = .{ .geometry = true };
    pub const everything: TraceMask = .{
        .geometry = true,
        .players = true,
        .turrets = true,
        .explosives = true,
        .supports = true,
        .unknown_kind = true,
        .props = true,
        .self = true,
        .allies = true,
        .enemies = true,
        .neutral = true,
        .unknown_team = true,
    };
};

pub const TraceHit = struct {
    position: runtime.Vec3,
    entity: i32,
    hit: bool,
    evaluated: TraceMask = .{},
};

pub fn trace(from: runtime.Vec3, to: runtime.Vec3, ignore_actor_id: i32, mask: TraceMask) TraceHit {
    _ = from;
    _ = to;
    _ = ignore_actor_id;
    _ = mask;
    return undefined;
}

const runtime = @import("runtime");
const Transform = @import("transform.zig").Transform;
const TransformSample = @import("transform_history.zig").TransformSample;
const Ability = @import("ability.zig").Ability;
const Gun = @import("gun.zig").Gun;
const HealthPools = @import("health_pool.zig").HealthPools;
const Skeleton = @import("skeleton.zig").Skeleton;
const HitboxSet = @import("hitbox.zig").HitboxSet;
const Team = @import("team.zig").Team;

pub const ActorKind = enum {
    player,
    turret,
    explosive,
    support,
    unknown,
};

pub const Actor = struct {
    id: i32,
    type_id: u64,
    kind: ActorKind = .player,
    team: Team = .unknown,
    transform: Transform = .{},
    velocity: runtime.Vec3 = .{},
    terminal_velocity: f32 = 0,
    horizontal_drag: f32 = 0,
    gravity: f32 = 0,
    on_ground: bool = false,
    master_entity: u32 = 0,
    transform_history: []const TransformSample = &.{},
    health: f32 = 0,
    max_health: f32 = 0,
    health_pools: ?*HealthPools = null,
    is_invincible: bool = false,
    is_invulnerable: bool = false,
    is_visible: bool = false,
    target_priority: u8 = 0,
    abilities: []Ability = &.{},
    guns: []Gun = &.{},
    skeleton: ?*Skeleton = null,
    hitboxes: ?*HitboxSet = null,
    pub fn ability(self: *const Actor, comptime A: type) Ability {
        _ = self;
        _ = A;
        return undefined;
    }
    pub fn gun(self: *const Actor, comptime G: type) Gun {
        _ = self;
        _ = G;
        return undefined;
    }
    pub fn transformAt(self: *const Actor, time_ms: f32) Transform {
        _ = self;
        _ = time_ms;
        return undefined;
    }
};

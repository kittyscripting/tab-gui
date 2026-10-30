const GameButton = @import("input.zig").GameButton;

pub const GunKind = enum {
    standard,
    scoped,
    bow,
    casted,
};

pub const AimType = enum {
    flick,
    track,
    bow,
    none,
};

pub const EffectTarget = enum {
    enemy,
    ally,
    both,
};

pub const Gun = struct {
    kind: GunKind = .standard,
    aim_type: AimType = .none,
    effect_target: EffectTarget = .enemy,
    owned_target_def: u64 = 0,
    button: GameButton = .primary_fire,
    aoe: bool = false,
    charging: bool = false,
    projectile_speed: f32 = 0,
    projectile_gravity: f32 = 0,
    projectile_launch_angle: f32 = 0,
    max_range: f32 = 0,
    damage: f32 = 0,
    critical_multiplier: f32 = 0,
    active: bool = false,
    charge_percent: f32 = 0,
    enabled: bool = false,
    reloading: bool = false,
    ammo: i32 = 0,
    max_ammo: i32 = 0,
    cooldown: f32 = 0,
    cooldown_start: f32 = 0,
};

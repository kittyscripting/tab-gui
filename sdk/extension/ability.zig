const GameButton = @import("input.zig").GameButton;
const EffectTarget = @import("gun.zig").EffectTarget;

pub const AbilityKind = enum {
    cooldown,
    charged,
    passive,
};

pub const AbilityType = enum {
    flick,
    none,
};

pub const Ability = struct {
    kind: AbilityKind = .cooldown,
    ability_type: AbilityType = .none,
    effect_target: EffectTarget = .enemy,
    button: GameButton = .ability1,
    aoe: bool = false,
    projectile_speed: f32 = 0,
    projectile_gravity: f32 = 0,
    projectile_launch_angle: f32 = 0,
    damage: f32 = 0,
    critical_multiplier: f32 = 0,
    cast_time: f32 = 0,
    custom_delay: f32 = 0,
    active: bool = false,
    enabled: bool = false,
    using: bool = false,
    charges: i32 = 0,
    max_charges: i32 = 0,
    cooldown: f32 = 0,
    cooldown_start: f32 = 0,
    points: f32 = 0,
    max_points: f32 = 0,
    pub fn isMultiCharge(self: Ability) bool {
        _ = self;
        return undefined;
    }
    pub fn readyAt(self: Ability) f32 {
        _ = self;
        return undefined;
    }
    pub fn readyPercent(self: Ability) f32 {
        _ = self;
        return undefined;
    }
    pub fn canUse(self: Ability) bool {
        _ = self;
        return undefined;
    }
};

const runtime = @import("runtime");
const Actor = @import("actor.zig").Actor;
const Gun = @import("gun.zig").Gun;
const Ability = @import("ability.zig").Ability;
const AimSlotRef = @import("helpers/slots.zig").AimSlotRef;
const input = @import("input.zig");
pub const GameButton = input.GameButton;
pub const DesireSentinel = input.DesireSentinel;

pub const EnabledGunIter = struct {
    pub fn next(self: *EnabledGunIter) ?*Gun {
        _ = self;
        return undefined;
    }
};

pub const EnabledAbilityIter = struct {
    pub fn next(self: *EnabledAbilityIter) ?*Ability {
        _ = self;
        return undefined;
    }
};

pub const EnabledAimSlotIter = struct {
    pub fn next(self: *EnabledAimSlotIter) ?AimSlotRef {
        _ = self;
        return undefined;
    }
};

pub const LocalActor = extern struct {
    controller: ?*Actor,
    avatar: ?*Actor,
    last_view_direction: runtime.Vec3,
    pub fn isPressed(self: *const LocalActor, button: GameButton) bool {
        _ = self;
        _ = button;
        return undefined;
    }
    pub fn setPressed(self: *LocalActor, button: GameButton, down: bool) void {
        _ = self;
        _ = button;
        _ = down;
    }
    pub fn releaseButton(self: *LocalActor, button: GameButton) void {
        _ = self;
        _ = button;
    }
    pub fn setViewDir(self: *LocalActor, dir: runtime.Vec3) void {
        _ = self;
        _ = dir;
    }
    pub fn viewDirection(self: *const LocalActor) runtime.Vec3 {
        _ = self;
        return undefined;
    }
    pub fn firstEnabledGun(self: *const LocalActor) ?*Gun {
        _ = self;
        return undefined;
    }
    pub fn enabledGuns(self: *const LocalActor) EnabledGunIter {
        _ = self;
        return undefined;
    }
    pub fn firstEnabledAbility(self: *const LocalActor) ?*Ability {
        _ = self;
        return undefined;
    }
    pub fn enabledAbilities(self: *const LocalActor) EnabledAbilityIter {
        _ = self;
        return undefined;
    }
    pub fn enabledAimSlots(self: *const LocalActor) EnabledAimSlotIter {
        _ = self;
        return undefined;
    }
};

pub fn isKeyOrGameButtonDown(local: *const LocalActor, setting: u32, fallback: GameButton) bool {
    _ = local;
    _ = setting;
    _ = fallback;
    return undefined;
}

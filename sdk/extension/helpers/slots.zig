const Gun = @import("../gun.zig").Gun;
const GunKind = @import("../gun.zig").GunKind;
const EffectTarget = @import("../gun.zig").EffectTarget;
const Ability = @import("../ability.zig").Ability;
const GameButton = @import("../input.zig").GameButton;

pub const LatchKind = enum {
    lost,
    swapped,
    held,
};

pub const EnabledLatch = struct {
    pub fn observe(self: *EnabledLatch, current_slot: ?u8) LatchKind {
        _ = self;
        _ = current_slot;
        return undefined;
    }
    pub fn reset(self: *EnabledLatch) void {
        _ = self;
    }
};

pub const GunLatch = struct {
    pub fn observe(self: *GunLatch, current: ?*const Gun) LatchKind {
        _ = self;
        _ = current;
        return undefined;
    }
    pub fn reset(self: *GunLatch) void {
        _ = self;
    }
};

pub const AimSlotRef = union(enum) {
    gun: *Gun,
    ability: *Ability,
    pub fn isFlick(self: AimSlotRef) bool {
        _ = self;
        return undefined;
    }
    pub fn isTrack(self: AimSlotRef) bool {
        _ = self;
        return undefined;
    }
    pub fn isBow(self: AimSlotRef) bool {
        _ = self;
        return undefined;
    }
    pub fn isNone(self: AimSlotRef) bool {
        _ = self;
        return undefined;
    }
    pub fn button(self: AimSlotRef) GameButton {
        _ = self;
        return undefined;
    }
    pub fn projectileSpeed(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn projectileGravity(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn projectileLaunchAngle(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn maxRange(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn damage(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn criticalMultiplier(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn shotCharge(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn cooldown(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn cooldownStart(self: AimSlotRef) f32 {
        _ = self;
        return undefined;
    }
    pub fn effectTarget(self: AimSlotRef) EffectTarget {
        _ = self;
        return undefined;
    }
    pub fn ownedTargetDef(self: AimSlotRef) u64 {
        _ = self;
        return undefined;
    }
    pub fn kind(self: AimSlotRef) GunKind {
        _ = self;
        return undefined;
    }
    pub fn ptrEquals(self: AimSlotRef, other: AimSlotRef) bool {
        _ = self;
        _ = other;
        return undefined;
    }
};

pub const AimSlotLatch = struct {
    pub fn observe(self: *AimSlotLatch, current: ?AimSlotRef) LatchKind {
        _ = self;
        _ = current;
        return undefined;
    }
    pub fn reset(self: *AimSlotLatch) void {
        _ = self;
    }
};

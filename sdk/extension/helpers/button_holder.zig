const LocalActor = @import("../local_actor.zig").LocalActor;
const GameButton = @import("../input.zig").GameButton;
const EffectTarget = @import("../gun.zig").EffectTarget;
const slots = @import("slots.zig");

pub const ButtonHolder = struct {
    held: ?GameButton = null,
    pub fn holdDown(self: *ButtonHolder, local: *LocalActor, button: GameButton) void {
        _ = self;
        _ = local;
        _ = button;
    }
    pub fn holdUp(self: *ButtonHolder, local: *LocalActor, button: GameButton) void {
        _ = self;
        _ = local;
        _ = button;
    }
    pub fn pressUp(self: *ButtonHolder, local: *LocalActor) void {
        _ = self;
        _ = local;
    }
    pub fn release(self: *ButtonHolder, local: *LocalActor) void {
        _ = self;
        _ = local;
    }
};

pub const TwinFire = struct {
    pub fn hold(self: *TwinFire, local: *LocalActor, slot: slots.AimSlotRef, effect_target: EffectTarget) void {
        _ = self;
        _ = local;
        _ = slot;
        _ = effect_target;
    }
    pub fn release(self: *TwinFire, local: *LocalActor) void {
        _ = self;
        _ = local;
    }
};

pub fn twinButton(local: *LocalActor, slot: slots.AimSlotRef, effect_target: EffectTarget) ?GameButton {
    _ = local;
    _ = slot;
    _ = effect_target;
    return undefined;
}

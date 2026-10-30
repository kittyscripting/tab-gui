const local_actor = @import("../local_actor.zig");
const LocalActor = local_actor.LocalActor;
const EffectTarget = @import("../gun.zig").EffectTarget;
const slots = @import("slots.zig");

pub fn effectTarget(local: *const LocalActor, slot: slots.AimSlotRef, key: u32, ally_key: u32) ?EffectTarget {
    _ = local;
    _ = slot;
    _ = key;
    _ = ally_key;
    return undefined;
}

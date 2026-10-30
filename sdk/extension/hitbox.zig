const runtime = @import("runtime");

pub const SphereHitbox = extern struct {
    shape: runtime.Sphere,
    bone: i16,
    critical: bool,
};

pub const CapsuleHitbox = extern struct {
    shape: runtime.Capsule,
    bone: i16,
    critical: bool,
};

pub const BoxHitbox = extern struct {
    shape: runtime.Box,
    bone: i16 = -1,
    critical: bool = false,
};

pub const HitboxSet = struct {
    spheres: []SphereHitbox,
    capsules: []CapsuleHitbox,
    boxes: []BoxHitbox = &.{},
};

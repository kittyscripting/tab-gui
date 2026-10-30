pub const HealthPoolKind = enum(u8) {
    normal,
    armor,
    shield,
    overhealth,
};

pub const HealthPool = struct {
    kind: HealthPoolKind,
    current: f32,
    max: f32,
};

pub const HealthPools = struct {
    pools: []HealthPool,
    pub fn ofKind(self: HealthPools, kind: HealthPoolKind) ?HealthPool {
        _ = self;
        _ = kind;
        return undefined;
    }
};

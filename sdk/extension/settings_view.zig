pub fn count() usize {
    return undefined;
}

pub fn snapshot() void {}

pub fn save() void {}

pub const ActorInfo = struct {
    id: u64,
    name: []const u8,
};

pub fn actorCount() usize {
    return undefined;
}

pub fn actor(idx: usize, buf: []u8) ?ActorInfo {
    _ = idx;
    _ = buf;
    return undefined;
}

pub fn setScope(actor_id: ?u64) bool {
    _ = actor_id;
    return undefined;
}

pub fn resetField(entry_idx: usize, field_idx: usize) bool {
    _ = entry_idx;
    _ = field_idx;
    return undefined;
}

pub fn isOverridden(entry_idx: usize, field_idx: usize) bool {
    _ = entry_idx;
    _ = field_idx;
    return undefined;
}

pub fn isGlobalOnly(entry_idx: usize, field_idx: usize) bool {
    _ = entry_idx;
    _ = field_idx;
    return undefined;
}

pub const Field = struct {
    name: []const u8,
    type_tag: u8,
    offset: u32,
    size: u32,
    default: [16]u8,
    min: ?[16]u8,
    max: ?[16]u8,
    display: []const u8,
    description: []const u8,
    control: []const u8,
    options: []const []const u8,
};

pub const Entry = struct {
    base: u32,
    module_name: []const u8,
    category: []const u8,
    fields: []const Field,
};

pub const View = struct {
    bytes: [65536]u8 = undefined,
    fields_buf: [256]Field = undefined,
    options_buf: [256][]const u8 = undefined,
    pub fn fetch(self: *View, idx: usize) ?Entry {
        _ = self;
        _ = idx;
        return undefined;
    }
};

pub fn valuePtr(comptime T: type, base: u32, offset: u32) *T {
    _ = base;
    _ = offset;
    return undefined;
}

pub fn slotValue(comptime T: type, slot: [16]u8) T {
    _ = slot;
    return undefined;
}

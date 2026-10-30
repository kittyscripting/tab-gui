pub const ActorListEntry = struct {
    id: u64,
    name: []const u8,
};

pub fn ActorList(comptime entries: []const ActorListEntry) type {
    return struct {
        pub const count = entries.len;
    };
}

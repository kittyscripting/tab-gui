pub const name_capacity: usize = 27;

pub const Node = extern struct {
    name: [name_capacity]u8 = [_]u8{0} ** name_capacity,
    name_len: u8 = 0,
    depth: u8 = 0,
    total_ns: i64 = 0,
    call_count: u32 = 0,
    pub fn label(self: *const Node) []const u8 {
        _ = self;
        return undefined;
    }
};

pub fn frameSeq() u32 {
    return undefined;
}

pub fn nodeCount() usize {
    return undefined;
}

pub fn rootTotalNs() i64 {
    return undefined;
}

pub fn nodes() []const Node {
    return undefined;
}

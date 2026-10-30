pub const Press = struct {
    pub fn start(self: *Press, now_ms: f32) void {
        _ = self;
        _ = now_ms;
    }
    pub fn clear(self: *Press) void {
        _ = self;
    }
    pub fn active(self: *const Press) bool {
        _ = self;
        return undefined;
    }
    pub fn holding(self: *const Press, now_ms: f32) bool {
        _ = self;
        _ = now_ms;
        return undefined;
    }
    pub fn settle(self: *Press, now_ms: f32) bool {
        _ = self;
        _ = now_ms;
        return undefined;
    }
};

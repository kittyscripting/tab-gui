pub const lateralChangeMps: f32 = 2.0;

pub const changeWindowMs: f32 = 100.0;

pub fn LateralChange(comptime V: type) type {
    return struct {
        const Self = @This();

        pub fn reset(self: *Self) void {
            _ = self;
        }

        pub fn lastSampleMs(self: *const Self) ?f32 {
            _ = self;
            return undefined;
        }

        pub fn observe(self: *Self, velocity: V, time_ms: f32, lateralAxis: V) bool {
            _ = self;
            _ = velocity;
            _ = time_ms;
            _ = lateralAxis;
            return undefined;
        }
    };
}

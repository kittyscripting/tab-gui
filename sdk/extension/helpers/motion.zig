pub const Change = enum {
    none,
    expected,
    unexpected,
    teleport,
};

pub const Changes = struct {
    horizontal: Change = .none,
    vertical: Change = .none,
};

pub const default_pattern_window_ms: f32 = 1200.0;

pub const default_teleport_meters: f32 = 0.5;

pub const default_vertical_accel: f32 = 100.0;

pub const Config = struct {
    pattern_window_ms: f32 = default_pattern_window_ms,
    teleport_meters: f32 = default_teleport_meters,
    vertical_accel: f32 = default_vertical_accel,
    pub fn scaled(accuracy_mul: f32) Config {
        _ = accuracy_mul;
        return undefined;
    }
};

pub fn MotionTracker(comptime V: type) type {
    return struct {
        const Self = @This();

        pub fn reset(self: *Self) void {
            _ = self;
        }

        pub fn lastSampleMs(self: *const Self) ?f32 {
            _ = self;
            return undefined;
        }

        pub fn observe(self: *Self, velocity: V, position: V, nowMs: f32, config: Config) Changes {
            _ = self;
            _ = velocity;
            _ = position;
            _ = nowMs;
            _ = config;
            return undefined;
        }

        pub fn oscillating(self: *const Self, nowMs: f32, config: Config) bool {
            _ = self;
            _ = nowMs;
            _ = config;
            return undefined;
        }

        pub fn leadScale(self: *const Self, nowMs: f32, lead_seconds: f32, config: Config) f32 {
            _ = self;
            _ = nowMs;
            _ = lead_seconds;
            _ = config;
            return undefined;
        }
    };
}

pub fn scaleHorizontal(comptime V: type, v: V, factor: f32) V {
    _ = v;
    _ = factor;
    return undefined;
}

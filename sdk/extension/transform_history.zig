const Transform = @import("transform.zig").Transform;

pub const TransformSample = struct {
    time_ms: f32,
    transform: Transform,
};

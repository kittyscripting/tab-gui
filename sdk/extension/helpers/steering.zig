const runtime = @import("runtime");
const Vec3 = runtime.Vec3;

pub const vertical_limit: f32 = 0.9;

pub fn nearVertical(dir: Vec3) bool {
    _ = dir;
    return undefined;
}

pub fn slerpTrack(view_dir: Vec3, dir_to_target: Vec3, smooth_x: f32, smooth_y: f32) Vec3 {
    _ = view_dir;
    _ = dir_to_target;
    _ = smooth_x;
    _ = smooth_y;
    return undefined;
}

pub fn trackRateDegPerSec(smoothness: u32) f32 {
    _ = smoothness;
    return undefined;
}

pub fn slerpTime(view_dir: Vec3, dir_to_target: Vec3, t: f32) Vec3 {
    _ = view_dir;
    _ = dir_to_target;
    _ = t;
    return undefined;
}

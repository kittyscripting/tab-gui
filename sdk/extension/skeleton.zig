const runtime = @import("runtime");

pub const Bone = extern struct {
    position: runtime.Vec3,
    parent: i32,
};

pub const Skeleton = struct {
    bones: []const Bone,
    pub fn lines(self: Skeleton) []const runtime.Line {
        _ = self;
        return undefined;
    }
    pub fn findRoot(self: Skeleton) ?usize {
        _ = self;
        return undefined;
    }
};

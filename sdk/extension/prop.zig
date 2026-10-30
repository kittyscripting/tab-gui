const Transform = @import("transform.zig").Transform;
const Team = @import("team.zig").Team;

pub const Prop = struct {
    id: i32,
    type_id: u64,
    team: Team = .unknown,
    owner: i32 = 0,
    transform: Transform = .{},
};

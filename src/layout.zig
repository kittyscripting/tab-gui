const state = @import("state.zig");

pub const Point = struct { x: f32, y: f32 };
pub const Cell = struct { col: usize, row: usize };

pub fn normalizedPosition(raw: u32) usize {
    return if (raw < state.position_options.len) @intCast(raw) else 0;
}

pub fn panelPosition(vp_w: f32, vp_h: f32, panel_w: f32, panel_h: f32, pos_index: usize) Point {
    const cell = positionCell(pos_index);
    return gridPosition(vp_w, vp_h, panel_w, panel_h, cell.col, cell.row);
}

pub fn helpPosition(vp_w: f32, vp_h: f32, panel_w: f32, panel_h: f32, pos_index: usize) Point {
    const cell: Cell = switch (pos_index) {
        0 => .{ .col = @as(usize, 2), .row = @as(usize, 0) },
        1 => .{ .col = @as(usize, 1), .row = @as(usize, 2) },
        2 => .{ .col = @as(usize, 0), .row = @as(usize, 0) },
        3 => .{ .col = @as(usize, 2), .row = @as(usize, 1) },
        4 => .{ .col = @as(usize, 0), .row = @as(usize, 1) },
        5 => .{ .col = @as(usize, 2), .row = @as(usize, 2) },
        6 => .{ .col = @as(usize, 1), .row = @as(usize, 0) },
        7 => .{ .col = @as(usize, 0), .row = @as(usize, 2) },
        else => .{ .col = @as(usize, 2), .row = @as(usize, 0) },
    };
    return gridPosition(vp_w, vp_h, panel_w, panel_h, cell.col, cell.row);
}

pub fn isBottomAligned(pos_index: usize) bool {
    return pos_index >= 5 and pos_index <= 7;
}

pub fn positionCell(pos_index: usize) Cell {
    return switch (pos_index) {
        0 => .{ .col = 0, .row = 0 },
        1 => .{ .col = 1, .row = 0 },
        2 => .{ .col = 2, .row = 0 },
        3 => .{ .col = 0, .row = 1 },
        4 => .{ .col = 2, .row = 1 },
        5 => .{ .col = 0, .row = 2 },
        6 => .{ .col = 1, .row = 2 },
        7 => .{ .col = 2, .row = 2 },
        else => .{ .col = 0, .row = 0 },
    };
}

pub fn gridPosition(vp_w: f32, vp_h: f32, panel_w: f32, panel_h: f32, col: usize, row: usize) Point {
    const cell_w = vp_w / 3.0;
    const cell_h = vp_h / 3.0;
    return .{
        .x = @min(@max(cell_w * @as(f32, @floatFromInt(col)) + (cell_w - panel_w) * 0.5, 0.0), @max(vp_w - panel_w, 0.0)),
        .y = @min(@max(cell_h * @as(f32, @floatFromInt(row)) + (cell_h - panel_h) * 0.5, 0.0), @max(vp_h - panel_h, 0.0)),
    };
}

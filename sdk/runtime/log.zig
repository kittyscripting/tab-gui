pub fn log(msg: []const u8) void {
    _ = msg;
}

pub fn info(comptime fmt: []const u8, args: anytype) void {
    _ = fmt;
    _ = args;
}

pub fn warn(comptime fmt: []const u8, args: anytype) void {
    _ = fmt;
    _ = args;
}

pub fn err(comptime fmt: []const u8, args: anytype) void {
    _ = fmt;
    _ = args;
}

pub fn logCount() i32 {
    return undefined;
}

pub fn logHistory(from: i32, to: i32) []const u8 {
    _ = from;
    _ = to;
    return undefined;
}

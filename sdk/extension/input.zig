const runtime = @import("runtime");

pub const GameButton = enum(u8) {
    primary_fire = 0,
    secondary_fire = 1,
    ability1 = 2,
    ability2 = 3,
    ultimate = 4,
    melee = 5,
    reload = 6,
    interact = 7,
    crouch = 8,
    jump = 9,
    forward = 10,
    back = 11,
    left = 12,
    right = 13,
    _,
};

pub const DesireSentinel = enum(i8) {
    none = -1,
    force_up = 0,
    force_down = 1,
};

pub const Key = enum(u8) {
    backspace = 0x08,
    tab = 0x09,
    enter = 0x0D,
    shift = 0x10,
    ctrl = 0x11,
    alt = 0x12,
    pause = 0x13,
    capslock = 0x14,
    escape = 0x1B,
    space = 0x20,
    pageup = 0x21,
    pagedown = 0x22,
    end = 0x23,
    home = 0x24,
    left = 0x25,
    up = 0x26,
    right = 0x27,
    down = 0x28,
    insert = 0x2D,
    delete = 0x2E,
    @"0" = 0x30,
    @"1" = 0x31,
    @"2" = 0x32,
    @"3" = 0x33,
    @"4" = 0x34,
    @"5" = 0x35,
    @"6" = 0x36,
    @"7" = 0x37,
    @"8" = 0x38,
    @"9" = 0x39,
    a = 0x41,
    b = 0x42,
    c = 0x43,
    d = 0x44,
    e = 0x45,
    f = 0x46,
    g = 0x47,
    h = 0x48,
    i = 0x49,
    j = 0x4A,
    k = 0x4B,
    l = 0x4C,
    m = 0x4D,
    n = 0x4E,
    o = 0x4F,
    p = 0x50,
    q = 0x51,
    r = 0x52,
    s = 0x53,
    t = 0x54,
    u = 0x55,
    v = 0x56,
    w = 0x57,
    x = 0x58,
    y = 0x59,
    z = 0x5A,
    backtick = 0xC0,
    numpad1 = 0x61,
    numpad2 = 0x62,
    numpad3 = 0x63,
    numpad4 = 0x64,
    numpad5 = 0x65,
    numpad6 = 0x66,
    numpad7 = 0x67,
    numpad8 = 0x68,
    numpad9 = 0x69,
    multiply = 0x6A,
    add = 0x6B,
    subtract = 0x6D,
    decimal = 0x6E,
    divide = 0x6F,
    f1 = 0x70,
    f2 = 0x71,
    f3 = 0x72,
    f4 = 0x73,
    f5 = 0x74,
    f6 = 0x75,
    f7 = 0x76,
    f8 = 0x77,
    f9 = 0x78,
    f10 = 0x79,
    f11 = 0x7A,
    f12 = 0x7B,
    oem_plus = 0xBB,
    oem_comma = 0xBC,
    oem_minus = 0xBD,
    oem_period = 0xBE,
    oem_2 = 0xBF,
    oem_4 = 0xDB,
    oem_5 = 0xDC,
    oem_6 = 0xDD,
    oem_7 = 0xDE,
    _,
};

pub const MouseButton = enum(u8) {
    left = 0,
    right = 1,
    middle = 2,
    back = 3,
    forward = 4,
    _,
};

pub fn keyName(code: u32) ?[]const u8 {
    _ = code;
    return undefined;
}

pub fn keyState(k: Key) u8 {
    _ = k;
    return undefined;
}

pub fn keyStateCode(code: u8) u8 {
    _ = code;
    return undefined;
}

pub fn keyDown(code: u8) bool {
    _ = code;
    return undefined;
}

pub fn keyPressed(code: u8) bool {
    _ = code;
    return undefined;
}

pub fn keyReleased(code: u8) bool {
    _ = code;
    return undefined;
}

pub fn isKeyDown(k: Key) bool {
    _ = k;
    return undefined;
}

pub fn isKeyPressed(k: Key) bool {
    _ = k;
    return undefined;
}

pub fn isKeyReleased(k: Key) bool {
    _ = k;
    return undefined;
}

pub fn firstKeyPressed() u8 {
    return undefined;
}

pub fn firstKeyDown() u8 {
    return undefined;
}

pub fn isMouseButtonPressed(b: MouseButton) bool {
    _ = b;
    return undefined;
}

pub fn mouseDeltaX() f32 {
    return undefined;
}

pub fn mouseDeltaY() f32 {
    return undefined;
}

pub fn mouseX() f32 {
    return undefined;
}

pub fn mouseY() f32 {
    return undefined;
}

pub fn requestMouseDelta(dx: f32, dy: f32) bool {
    _ = dx;
    _ = dy;
    return undefined;
}

pub fn setDisabled(disable: bool) void {
    _ = disable;
}

pub fn isDisabled() bool {
    return undefined;
}

pub fn setSensitivity(value: f32) void {
    _ = value;
}

pub fn resetSensitivity() void {}

pub fn mouseViewDelta() ?runtime.Vec2 {
    return undefined;
}

pub fn withMouseRotation(dir: runtime.Vec3) runtime.Vec3 {
    _ = dir;
    return undefined;
}

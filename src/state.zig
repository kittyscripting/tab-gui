const std = @import("std");
const sdk = @import("sdk");

pub const position_options = [_][]const u8{
    "top-left",      "top-center",   "top-right",
    "middle-left",   "middle-right", "bottom-left",
    "bottom-center", "bottom-right",
};

pub const MAX_ROWS: usize = 256;
pub const VISIBLE_ROWS: usize = 16;
pub const MAX_ROW_OPTIONS: usize = 16;
pub const TEXT_CAP: usize = 48;
pub const OPTION_TEXT_CAP: usize = 48;
pub const SEARCH_CAP: usize = 64;

pub const TYPE_BOOL: u8 = 0;
pub const TYPE_I64: u8 = 1;
pub const TYPE_F64: u8 = 2;
pub const TYPE_I32: u8 = 3;
pub const TYPE_U32: u8 = 4;
pub const TYPE_F32: u8 = 5;

pub const View = enum { scope, actors, categories, settings, search };
pub const RowKind = enum { back, setting, spacer };
const MAX_NAVIGATION_DEPTH: usize = 4;

pub const MAX_ACTORS: usize = 64;
pub const ACTOR_NAME_CAP: usize = 64;
const ACTOR_FETCH_BUF_LEN: usize = 128;

const NavigationEntry = struct {
    view_mode: View,
    selected: usize,
    scroll_top: usize,
    search_typing: bool,
};

const SettingsCursor = struct {
    category_buf: [TEXT_CAP]u8 = undefined,
    category_len: usize = 0,
    selected: usize = 0,
    scroll_top: usize = 0,
};

pub const Category = struct {
    name_buf: [TEXT_CAP]u8 = undefined,
    name_len: usize = 0,
    setting_count: u32 = 0,

    pub fn name(self: *const Category) []const u8 {
        return self.name_buf[0..self.name_len];
    }
};

pub const Row = struct {
    kind: RowKind = .setting,
    entry_idx: usize = 0,
    field_idx: usize = 0,
    base: u32 = 0,
    offset: u32 = 0,
    size: u32 = 0,
    type_tag: u8 = 0,
    min: ?[16]u8 = null,
    max: ?[16]u8 = null,
    module_buf: [TEXT_CAP]u8 = undefined,
    module_len: usize = 0,
    category_buf: [TEXT_CAP]u8 = undefined,
    category_len: usize = 0,
    name_buf: [TEXT_CAP]u8 = undefined,
    name_len: usize = 0,
    display_buf: [TEXT_CAP]u8 = undefined,
    display_len: usize = 0,
    description_buf: [TEXT_CAP * 4]u8 = undefined,
    description_len: usize = 0,
    control_buf: [TEXT_CAP]u8 = undefined,
    control_len: usize = 0,
    option_bufs: [MAX_ROW_OPTIONS][OPTION_TEXT_CAP]u8 = undefined,
    option_lens: [MAX_ROW_OPTIONS]usize = undefined,
    option_slices: [MAX_ROW_OPTIONS][]const u8 = undefined,
    option_count: usize = 0,
    options_overflow: bool = false,

    pub fn moduleName(self: *const Row) []const u8 {
        return self.module_buf[0..self.module_len];
    }

    pub fn category(self: *const Row) []const u8 {
        return self.category_buf[0..self.category_len];
    }

    pub fn name(self: *const Row) []const u8 {
        return self.name_buf[0..self.name_len];
    }

    pub fn display(self: *const Row) []const u8 {
        return if (self.display_len != 0) self.display_buf[0..self.display_len] else self.name();
    }

    pub fn description(self: *const Row) []const u8 {
        return self.description_buf[0..self.description_len];
    }

    pub fn control(self: *const Row) []const u8 {
        return self.control_buf[0..self.control_len];
    }

    pub fn options(self: *const Row) []const []const u8 {
        return self.option_slices[0..self.option_count];
    }

    pub fn isSelectable(self: *const Row) bool {
        return self.kind != .spacer;
    }
};

pub fn isKeybindControl(control: []const u8) bool {
    return std.mem.eql(u8, control, "keybind") or std.mem.eql(u8, control, "keybind_default");
}

pub var visible: bool = false;
pub var visible_prev: bool = false;
pub var view_mode: View = .categories;
pub var selected: usize = 0;
pub var scroll_top: usize = 0;
pub var editing: bool = false;
pub var drilled_category: [TEXT_CAP]u8 = undefined;
pub var drilled_category_len: usize = 0;
pub var search_buf: [SEARCH_CAP]u8 = undefined;
pub var search_len: usize = 0;
pub var search_typing: bool = false;
pub var root_view: View = .categories;
pub var actor_scope: ?u64 = null;
pub var actor_ids: [MAX_ACTORS]u64 = undefined;
pub var actor_name_bufs: [MAX_ACTORS][ACTOR_NAME_CAP]u8 = undefined;
pub var actor_name_lens: [MAX_ACTORS]usize = undefined;
pub var actors_len: usize = 0;
pub var view = sdk.settings_view.View{};
pub var rows: [MAX_ROWS]Row = undefined;
pub var rows_len: usize = 0;
pub var categories: [MAX_ROWS]Category = undefined;
pub var categories_len: usize = 0;

var navigation: [MAX_NAVIGATION_DEPTH]NavigationEntry = undefined;
var navigation_len: usize = 0;
var settings_cursors: [MAX_ROWS]SettingsCursor = undefined;
var settings_cursors_len: usize = 0;

fn settingsCursor() ?*SettingsCursor {
    const category = drilled_category[0..drilled_category_len];
    var i: usize = 0;
    while (i < settings_cursors_len) : (i += 1) {
        const cursor = &settings_cursors[i];
        if (std.mem.eql(u8, cursor.category_buf[0..cursor.category_len], category)) return cursor;
    }
    if (settings_cursors_len == settings_cursors.len) return null;

    const cursor = &settings_cursors[settings_cursors_len];
    settings_cursors_len += 1;
    cursor.category_len = sdk.util.copyText(cursor.category_buf[0..], category);
    cursor.selected = 0;
    cursor.scroll_top = 0;
    return cursor;
}

fn restoreSettingsCursor() void {
    const cursor = settingsCursor() orelse {
        selected = 0;
        scroll_top = 0;
        return;
    };
    selected = cursor.selected;
    scroll_top = cursor.scroll_top;
}

fn rememberSettingsCursor() void {
    const cursor = settingsCursor() orelse return;
    cursor.selected = selected;
    cursor.scroll_top = scroll_top;
}

pub fn enterSubmenu(next_view: View) void {
    std.debug.assert(navigation_len < navigation.len);
    navigation[navigation_len] = .{
        .view_mode = view_mode,
        .selected = selected,
        .scroll_top = scroll_top,
        .search_typing = search_typing,
    };
    navigation_len += 1;
    view_mode = next_view;
    editing = false;
    if (next_view == .settings) {
        restoreSettingsCursor();
    } else {
        selected = 0;
        scroll_top = 0;
    }
}

pub fn goBack() void {
    if (view_mode == .settings) rememberSettingsCursor();
    editing = false;
    if (navigation_len == 0) {
        view_mode = root_view;
        selected = 0;
        scroll_top = 0;
        search_typing = false;
        return;
    }

    navigation_len -= 1;
    const previous = navigation[navigation_len];
    view_mode = previous.view_mode;
    selected = previous.selected;
    scroll_top = previous.scroll_top;
    search_typing = previous.search_typing;
}

pub fn atRootView() bool {
    return navigation_len == 0 and view_mode == root_view;
}

pub fn openNavigation() void {
    editing = false;
    refreshActors();
    const root: View = if (actors_len != 0) .scope else .categories;
    if (opened_before and root == root_view and sdk.settings_view.setScope(actor_scope)) return;
    opened_before = true;
    resetNavigation(root);
}

var opened_before: bool = false;

fn resetNavigation(root: View) void {
    navigation_len = 0;
    selected = 0;
    scroll_top = 0;
    search_len = 0;
    search_typing = false;
    drilled_category_len = 0;
    actor_scope = null;
    settings_cursors_len = 0;
    root_view = root;
    view_mode = root;
}

pub fn refreshActors() void {
    actors_len = 0;
    const n = sdk.settings_view.actorCount();
    var i: usize = 0;
    while (i < n and actors_len < MAX_ACTORS) : (i += 1) {
        var fetch_buf: [ACTOR_FETCH_BUF_LEN]u8 = undefined;
        const info = sdk.settings_view.actor(i, &fetch_buf) orelse continue;
        actor_ids[actors_len] = info.id;
        actor_name_lens[actors_len] = sdk.util.copyText(actor_name_bufs[actors_len][0..], info.name);
        actors_len += 1;
    }
}

pub fn actorName(idx: usize) []const u8 {
    return actor_name_bufs[idx][0..actor_name_lens[idx]];
}

pub fn actorNameById(id: u64) ?[]const u8 {
    var i: usize = 0;
    while (i < actors_len) : (i += 1) {
        if (actor_ids[i] == id) return actorName(i);
    }
    return null;
}

pub fn preselectLocalActor() void {
    const local = sdk.localActor() orelse return;
    const avatar = local.avatar orelse return;
    const typeId = avatar.type_id;
    var i: usize = 0;
    while (i < actors_len) : (i += 1) {
        if (actor_ids[i] == typeId) {
            selected = i;
            return;
        }
    }
}

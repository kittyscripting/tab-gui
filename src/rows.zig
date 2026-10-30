const std = @import("std");
const sdk = @import("sdk");
const state = @import("state.zig");

pub fn refillRows() void {
    switch (state.view_mode) {
        .scope => refillScope(),
        .actors => refillActors(),
        .categories => refillCategories(),
        .settings => refillSettings(),
        .search => refillSearch(),
    }
}

fn refillScope() void {
    state.rows_len = 2;
}

fn refillActors() void {
    state.rows_len = state.actors_len;
}

fn entryVisibleInScope(module_name: []const u8) bool {
    if (state.actor_scope == null) return true;
    return !std.mem.eql(u8, module_name, "@runtime");
}

fn hiddenInActorScope(entry_idx: usize, field_idx: usize) bool {
    if (state.actor_scope == null) return false;
    return sdk.settings_view.isGlobalOnly(entry_idx, field_idx);
}

fn visibleFieldCount(entry_idx: usize, entry: sdk.settings_view.Entry) usize {
    if (state.actor_scope == null) return entry.fields.len;
    var count: usize = 0;
    var field_idx: usize = 0;
    while (field_idx < entry.fields.len) : (field_idx += 1) {
        if (!hiddenInActorScope(entry_idx, field_idx)) count += 1;
    }
    return count;
}

fn refillCategories() void {
    state.rows_len = 0;
    state.categories_len = 0;
    const n = sdk.settings_view.count();
    var total_settings: u32 = 0;
    var entry_idx: usize = 0;
    while (entry_idx < n) : (entry_idx += 1) {
        const entry = state.view.fetch(entry_idx) orelse continue;
        if (!entryVisibleInScope(entry.module_name)) continue;
        const visible_fields = visibleFieldCount(entry_idx, entry);
        if (state.actor_scope != null and visible_fields == 0) continue;
        total_settings +|= @intCast(@min(visible_fields, @as(usize, std.math.maxInt(u32))));
        const cat_index = findCategory(entry.category) orelse addCategory(entry.category) orelse continue;
        state.categories[cat_index].setting_count +|= @intCast(@min(visible_fields, @as(usize, std.math.maxInt(u32))));
    }
    std.mem.sort(state.Category, state.categories[0..state.categories_len], {}, categoryLessThan);
    state.rows_len = if (total_settings == 0) 0 else state.categories_len + 1;
}

fn categoryLessThan(_: void, a: state.Category, b: state.Category) bool {
    return switch (std.ascii.orderIgnoreCase(a.name(), b.name())) {
        .lt => true,
        .gt => false,
        .eq => std.mem.lessThan(u8, a.name(), b.name()),
    };
}

fn drilledEntry(entry_idx: usize) ?sdk.settings_view.Entry {
    const entry = state.view.fetch(entry_idx) orelse return null;
    if (!entryVisibleInScope(entry.module_name)) return null;
    if (!std.mem.eql(u8, entry.category, state.drilled_category[0..state.drilled_category_len])) return null;
    return entry;
}

fn appendDrilledGroup(want_global_only: bool) usize {
    const start = state.rows_len;
    const n = sdk.settings_view.count();
    var entry_idx: usize = 0;
    while (entry_idx < n and state.rows_len < state.MAX_ROWS) : (entry_idx += 1) {
        const entry = drilledEntry(entry_idx) orelse continue;
        var field_idx: usize = 0;
        while (field_idx < entry.fields.len and state.rows_len < state.MAX_ROWS) : (field_idx += 1) {
            if (sdk.settings_view.isGlobalOnly(entry_idx, field_idx) != want_global_only) continue;
            snapshotRow(&state.rows[state.rows_len], entry_idx, field_idx, entry, entry.fields[field_idx]);
            state.rows_len += 1;
        }
    }
    return state.rows_len - start;
}

fn drilledGroupHasField(want_global_only: bool) bool {
    const n = sdk.settings_view.count();
    var entry_idx: usize = 0;
    while (entry_idx < n) : (entry_idx += 1) {
        const entry = drilledEntry(entry_idx) orelse continue;
        var field_idx: usize = 0;
        while (field_idx < entry.fields.len) : (field_idx += 1) {
            if (sdk.settings_view.isGlobalOnly(entry_idx, field_idx) == want_global_only) return true;
        }
    }
    return false;
}

fn refillSettings() void {
    state.rows_len = 0;
    state.rows[0] = .{ .kind = .back };
    state.rows_len = 1;
    if (state.actor_scope != null) {
        _ = appendDrilledGroup(false);
    } else {
        const global_only_rows = appendDrilledGroup(true);
        if (global_only_rows != 0 and state.rows_len < state.MAX_ROWS and drilledGroupHasField(false)) {
            state.rows[state.rows_len] = .{ .kind = .spacer };
            state.rows_len += 1;
        }
        _ = appendDrilledGroup(false);
    }
    if (state.rows_len == 1) {
        state.goBack();
        refillRows();
    }
}

fn refillSearch() void {
    state.rows_len = 0;
    const n = sdk.settings_view.count();
    var entry_idx: usize = 0;
    while (entry_idx < n and state.rows_len < state.MAX_ROWS) : (entry_idx += 1) {
        const entry = state.view.fetch(entry_idx) orelse continue;
        if (!entryVisibleInScope(entry.module_name)) continue;
        var field_idx: usize = 0;
        while (field_idx < entry.fields.len and state.rows_len < state.MAX_ROWS) : (field_idx += 1) {
            const field = entry.fields[field_idx];
            const display = if (field.display.len != 0) field.display else field.name;
            const needle = state.search_buf[0..state.search_len];
            const matches = state.search_len == 0 or
                sdk.util.containsAsciiLower(display, needle) or
                sdk.util.containsAsciiLower(field.name, needle) or
                sdk.util.containsAsciiLower(entry.category, needle) or
                sdk.util.containsAsciiLower(entry.module_name, needle);
            if (matches and !hiddenInActorScope(entry_idx, field_idx)) {
                snapshotRow(&state.rows[state.rows_len], entry_idx, field_idx, entry, field);
                state.rows_len += 1;
            }
        }
    }
}

fn snapshotRow(row: *state.Row, entry_idx: usize, field_idx: usize, entry: sdk.settings_view.Entry, field: sdk.settings_view.Field) void {
    row.* = .{
        .kind = .setting,
        .entry_idx = entry_idx,
        .field_idx = field_idx,
        .base = entry.base,
        .offset = field.offset,
        .size = field.size,
        .type_tag = field.type_tag,
        .min = field.min,
        .max = field.max,
    };
    row.module_len = sdk.util.copyText(row.module_buf[0..], entry.module_name);
    row.category_len = sdk.util.copyText(row.category_buf[0..], entry.category);
    row.name_len = sdk.util.copyText(row.name_buf[0..], field.name);
    row.display_len = sdk.util.copyText(row.display_buf[0..], field.display);
    row.description_len = sdk.util.copyText(row.description_buf[0..], field.description);
    row.control_len = sdk.util.copyText(row.control_buf[0..], field.control);
    if (field.options.len > state.MAX_ROW_OPTIONS) {
        row.options_overflow = true;
        row.option_count = 0;
        return;
    }
    row.option_count = field.options.len;
    var i: usize = 0;
    while (i < field.options.len) : (i += 1) {
        row.option_lens[i] = sdk.util.copyText(row.option_bufs[i][0..], field.options[i]);
        row.option_slices[i] = row.option_bufs[i][0..row.option_lens[i]];
    }
}

fn nearestSelectable(from: usize) usize {
    var i = from;
    while (i < state.rows_len) : (i += 1) {
        if (state.rows[i].isSelectable()) return i;
    }
    i = from;
    while (i > 0) {
        i -= 1;
        if (state.rows[i].isSelectable()) return i;
    }
    return from;
}

pub fn selectableAbove(from: usize) usize {
    var i = from;
    while (i > 0) {
        i -= 1;
        if (state.rows[i].isSelectable()) return i;
    }
    return from;
}

pub fn selectableBelow(from: usize) usize {
    var i = from + 1;
    while (i < state.rows_len) : (i += 1) {
        if (state.rows[i].isSelectable()) return i;
    }
    return from;
}

pub fn clampSelection() void {
    if (state.rows_len == 0) {
        state.selected = 0;
        state.scroll_top = 0;
        state.editing = false;
        return;
    }
    if (state.selected >= state.rows_len) state.selected = state.rows_len - 1;
    if (state.view_mode == .settings) state.selected = nearestSelectable(state.selected);
    if (state.selected < state.scroll_top) state.scroll_top = state.selected;
    if (state.selected >= state.scroll_top + state.VISIBLE_ROWS) state.scroll_top = state.selected + 1 - state.VISIBLE_ROWS;
    if (state.scroll_top >= state.rows_len) state.scroll_top = state.rows_len - 1;
    if (state.view_mode != .settings or state.rows[state.selected].kind != .setting) state.editing = false;
}

fn findCategory(name: []const u8) ?usize {
    var i: usize = 0;
    while (i < state.categories_len) : (i += 1) {
        if (std.mem.eql(u8, state.categories[i].name(), name)) return i;
    }
    return null;
}

fn addCategory(name: []const u8) ?usize {
    if (state.categories_len + 1 >= state.MAX_ROWS) return null;
    const idx = state.categories_len;
    state.categories_len += 1;
    state.categories[idx].name_len = sdk.util.copyText(state.categories[idx].name_buf[0..], name);
    state.categories[idx].setting_count = 0;
    return idx;
}

pub fn findMatchingSetting(match: *const state.Row) ?usize {
    var i: usize = 0;
    while (i < state.rows_len) : (i += 1) {
        if (state.rows[i].kind != .setting) continue;
        if (state.rows[i].entry_idx == match.entry_idx and state.rows[i].field_idx == match.field_idx) return i;
        if (std.mem.eql(u8, state.rows[i].moduleName(), match.moduleName()) and std.mem.eql(u8, state.rows[i].name(), match.name())) return i;
    }
    return null;
}

pub fn live(comptime T: type, row: *const state.Row) *T {
    return sdk.settings_view.valuePtr(T, row.base, row.offset);
}

pub fn minU32(row: *const state.Row) ?u32 {
    const slot = row.min orelse return null;
    return sdk.settings_view.slotValue(u32, slot);
}

pub fn maxU32(row: *const state.Row) ?u32 {
    const slot = row.max orelse return null;
    return sdk.settings_view.slotValue(u32, slot);
}

pub fn minF32(row: *const state.Row) ?f32 {
    const slot = row.min orelse return null;
    return sdk.settings_view.slotValue(f32, slot);
}

pub fn maxF32(row: *const state.Row) ?f32 {
    const slot = row.max orelse return null;
    return sdk.settings_view.slotValue(f32, slot);
}

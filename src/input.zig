const std = @import("std");
const sdk = @import("sdk");
const state = @import("state.zig");
const rows = @import("rows.zig");

inline fn pressed(key: sdk.Key) bool {
    return sdk.isKeyPressed(key);
}

inline fn pressedCode(code: u8) bool {
    return sdk.keyPressed(code);
}

pub fn handleScopeInput() void {
    if (pressed(.up) and state.selected > 0) state.selected -= 1;
    if (pressed(.down) and state.selected + 1 < state.rows_len) state.selected += 1;
    if (pressed(.enter) and state.rows_len != 0) {
        if (state.selected == 0) {
            if (sdk.settings_view.setScope(null)) {
                state.actor_scope = null;
                state.enterSubmenu(.categories);
            }
        } else {
            state.enterSubmenu(.actors);
            state.preselectLocalActor();
        }
    }
    if (pressed(.escape)) state.visible = false;
}

pub fn handleActorsInput() void {
    if (pressed(.up) and state.selected > 0) state.selected -= 1;
    if (pressed(.down) and state.selected + 1 < state.rows_len) state.selected += 1;
    if (pressed(.enter) and state.rows_len != 0) {
        if (sdk.settings_view.setScope(state.actor_ids[state.selected])) {
            state.actor_scope = state.actor_ids[state.selected];
            state.enterSubmenu(.categories);
        }
    }
    if (pressed(.escape)) state.goBack();
}

pub fn handleCategoriesInput() void {
    if (pressed(.up) and state.selected > 0) state.selected -= 1;
    if (pressed(.down) and state.selected + 1 < state.rows_len) state.selected += 1;
    if (pressed(.enter) and state.rows_len != 0) {
        if (state.selected == 0) {
            state.enterSubmenu(.search);
            state.search_typing = true;
        } else if (state.selected - 1 < state.categories_len) {
            const cat = &state.categories[state.selected - 1];
            state.drilled_category_len = sdk.util.copyText(state.drilled_category[0..], cat.name());
            state.enterSubmenu(.settings);
        }
    }
    if (pressed(.escape)) {
        if (state.atRootView()) state.visible = false else state.goBack();
    }
}

pub fn handleSettingsInput() void {
    if (state.editing and state.rows_len != 0 and state.selected < state.rows_len and state.rows[state.selected].kind == .setting) {
        if (stepRow(&state.rows[state.selected])) state.editing = false;
        return;
    }

    if (pressed(.up)) state.selected = rows.selectableAbove(state.selected);
    if (pressed(.down)) state.selected = rows.selectableBelow(state.selected);
    if (pressed(.enter) and state.rows_len != 0) {
        if (state.selected == 0 and state.rows[0].kind == .back) {
            state.goBack();
            return;
        } else if (canEdit(&state.rows[state.selected])) {
            const row = &state.rows[state.selected];
            if (row.type_tag == state.TYPE_BOOL and row.size >= 1) {
                const ptr = rows.live(bool, row);
                ptr.* = !ptr.*;
            } else {
                state.editing = true;
            }
        }
    }
    if (pressed(.delete) and state.rows_len != 0 and state.rows[state.selected].kind == .setting) restoreDefault(&state.rows[state.selected]);
    if (pressed(.escape)) state.goBack();
}

pub fn handleSearchInput() void {
    if (state.search_typing) handleSearchTyping();
    if (pressed(.up) and state.selected > 0) state.selected -= 1;
    if (pressed(.down) and state.selected + 1 < state.rows_len) state.selected += 1;
    if (pressed(.escape)) {
        state.goBack();
        state.search_len = 0;
        state.search_typing = false;
        return;
    }
    if (pressed(.enter) and state.rows_len != 0) {
        const match = state.rows[state.selected];
        state.drilled_category_len = sdk.util.copyText(state.drilled_category[0..], match.category());
        state.enterSubmenu(.settings);
        rows.refillRows();
        state.selected = rows.findMatchingSetting(&match) orelse 0;
        rows.clampSelection();
    }
}

fn handleSearchTyping() void {
    if (pressed(.backspace) and state.search_len > 0) state.search_len -= 1;

    var vk: usize = 0x20;
    while (vk < 256) : (vk += 1) {
        if (!pressedCode(@intCast(vk))) continue;
        if (state.search_len + 1 >= state.search_buf.len) continue;
        var ch: u8 = 0;
        if (vk >= 0x30 and vk <= 0x39) {
            ch = @intCast(vk);
        } else if (vk >= 0x41 and vk <= 0x5A) {
            ch = @intCast(vk + 0x20);
        } else if (vk == 0x20) {
            ch = ' ';
        }
        if (ch != 0) {
            state.search_buf[state.search_len] = ch;
            state.search_len += 1;
        }
    }
}

fn canEdit(row: *const state.Row) bool {
    if (row.kind != .setting or row.options_overflow) return false;
    const control = row.control();
    if (state.isKeybindControl(control) or std.mem.eql(u8, control, "color")) return row.type_tag == state.TYPE_U32 and row.size >= 4;
    if (std.mem.eql(u8, control, "multi")) return row.type_tag == state.TYPE_U32 and row.size >= 4 and row.option_count != 0;
    if (std.mem.eql(u8, control, "slider")) {
        if (row.size < 4) return false;
        return row.type_tag == state.TYPE_U32 or row.type_tag == state.TYPE_I32 or row.type_tag == state.TYPE_F32;
    }
    return row.type_tag == state.TYPE_BOOL and row.size >= 1;
}

fn stepRow(row: *const state.Row) bool {
    if (row.kind != .setting or row.options_overflow) return true;
    const control = row.control();
    if (state.isKeybindControl(control)) {
        if (row.type_tag != state.TYPE_U32 or row.size < 4) return true;
        return sdk.render.elements.basic.keybind.step(rows.live(u32, row));
    }
    if (std.mem.eql(u8, control, "multi")) {
        if (row.type_tag != state.TYPE_U32 or row.size < 4) return true;
        return sdk.render.elements.basic.multi.step(rows.live(u32, row), @intCast(row.option_count));
    }
    if (std.mem.eql(u8, control, "slider")) {
        if (row.size < 4) return true;
        if (row.type_tag == state.TYPE_F32) {
            const min = rows.minF32(row) orelse 0.0;
            const max = rows.maxF32(row) orelse 1.0;
            return sdk.render.elements.basic.slider.stepF32(rows.live(f32, row), min, max);
        }
        if (row.type_tag == state.TYPE_U32 or row.type_tag == state.TYPE_I32) {
            const min = rows.minU32(row) orelse 0;
            const max = rows.maxU32(row) orelse 255;
            return sdk.render.elements.basic.slider.step(rows.live(u32, row), min, max);
        }
        return true;
    }
    if (std.mem.eql(u8, control, "color")) {
        if (row.type_tag != state.TYPE_U32 or row.size < 4) return true;
        return sdk.render.elements.basic.colorpicker.step(rows.live(u32, row));
    }
    if (row.type_tag == state.TYPE_BOOL and row.size >= 1) {
        return sdk.render.elements.basic.boolean.step(rows.live(bool, row));
    }
    return true;
}

fn restoreDefault(row: *const state.Row) void {
    if (row.kind != .setting) return;
    _ = sdk.settings_view.resetField(row.entry_idx, row.field_idx);
}

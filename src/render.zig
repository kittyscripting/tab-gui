const std = @import("std");
const sdk = @import("sdk");
const state = @import("state.zig");
const layout = @import("layout.zig");
const rows = @import("rows.zig");

const MAX_DESCRIPTION_LINES: usize = 4;
const DESCRIPTION_LINE_H: f32 = 14.0;
const FONT_BASE: f32 = 11.0;

const DescriptionLine = struct {
    start: usize,
    end: usize,
};

fn headerHeight(view_mode: state.View) f32 {
    if (view_mode == .scope or view_mode == .actors) return 0.0;
    return if (state.root_view == .scope) 22.0 else 0.0;
}

fn firstRowStart(view_mode: state.View) f32 {
    const header = headerHeight(view_mode);
    return switch (view_mode) {
        .search => 34.0 + header,
        .categories, .settings => 12.0 + header,
        .scope, .actors => 12.0,
    };
}

fn scopeLabel() []const u8 {
    const id = state.actor_scope orelse return "Global";
    return state.actorNameById(id) orelse "Global";
}

fn inheritedTextColor(text_color: i32) i32 {
    const tc: u32 = @bitCast(text_color);
    return sdk.render.rgba(@intCast(tc & 0xFF), @intCast((tc >> 8) & 0xFF), @intCast((tc >> 16) & 0xFF), 96);
}

fn rowIsInheritedGlobal(row: *const state.Row, is_editing: bool) bool {
    if (state.actor_scope == null) return false;
    if (is_editing) return false;
    return !sdk.settings_view.isOverridden(row.entry_idx, row.field_idx);
}

fn renderScopeHeader(panel_x: f32, panel_y: f32, text_color: i32) void {
    if (state.root_view != .scope) return;
    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    sdk.render.drawText(scopeLabel(), panel_x + 18.0 * s, panel_y + 12.0 * s, font, text_color);
}

pub fn renderPanel(panel_color_raw: u32, accent_color_raw: u32, hide_help: bool, position: u32) void {
    const vp = sdk.render.viewport();
    if (vp.x <= 0.0 or vp.y <= 0.0) return;
    const s = sdk.render.scale();

    const visible_rows = @min(state.rows_len -| state.scroll_top, state.VISIBLE_ROWS);
    const header_h = headerHeight(state.view_mode);
    const panel_w: f32 = 420.0 * s;
    const uncapped_h: f32 = switch (state.view_mode) {
        .search => (37.0 + 22.0 * @as(f32, @floatFromInt(visible_rows)) + header_h) * s,
        else => if (state.rows_len == 0)
            (50.0 + header_h) * s
        else
            (15.0 + 22.0 * @as(f32, @floatFromInt(visible_rows)) + header_h) * s,
    };
    const panel_h: f32 = @min(uncapped_h, vp.y * 0.5);
    const pos_index = layout.normalizedPosition(position);
    const panel_pos = layout.panelPosition(vp.x, vp.y, panel_w, panel_h, pos_index);
    const panel_color: i32 = @bitCast(sdk.util.argbToHost((panel_color_raw & 0x00FF_FFFF) | 0xCC00_0000));
    const accent_color: i32 = @bitCast(sdk.util.argbToHost(accent_color_raw));
    const text_color = sdk.render.rgba(230, 230, 235, 255);
    const muted_color = sdk.render.rgba(44, 44, 52, 255);

    sdk.render.drawFilledRect(panel_pos.x, panel_pos.y, panel_w, panel_h, panel_color);
    sdk.render.drawRect(panel_pos.x, panel_pos.y, panel_w, panel_h, accent_color, 2.0 * s);

    switch (state.view_mode) {
        .scope => renderScope(panel_pos.x, panel_pos.y, panel_w, panel_h, text_color, accent_color),
        .actors => renderActors(panel_pos.x, panel_pos.y, panel_w, panel_h, text_color, accent_color),
        .categories => renderCategories(panel_pos.x, panel_pos.y, panel_w, panel_h, text_color, accent_color),
        .settings => renderSettings(panel_pos.x, panel_pos.y, panel_w, panel_h, text_color, accent_color, muted_color),
        .search => renderSearch(panel_pos.x, panel_pos.y, panel_w, panel_h, text_color, accent_color),
    }

    renderOverflowCue(panel_pos.x, panel_pos.y, panel_w, panel_h, accent_color);

    if (!hide_help) {
        renderHelp(vp.x, vp.y, panel_color, accent_color, text_color, pos_index);
        renderDescriptionPanel(panel_pos.x, panel_pos.y, panel_w, panel_h, panel_color, accent_color, text_color, pos_index);
    }
}

fn renderScope(panel_x: f32, panel_y: f32, panel_w: f32, panel_h: f32, text_color: i32, accent_color: i32) void {
    _ = panel_w;
    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    const row_h: f32 = 22.0 * s;
    var y = panel_y + firstRowStart(.scope) * s;
    const panel_bottom = panel_y + panel_h - 8.0 * s;
    const end = @min(state.rows_len, state.scroll_top + state.VISIBLE_ROWS);
    var i = state.scroll_top;
    while (i < end) : (i += 1) {
        if (y + 13.0 * s > panel_bottom) break;
        if (i == state.selected) sdk.render.drawFilledRect(panel_x + 8.0 * s, y + 6.0 * s, 4.0 * s, 4.0 * s, accent_color);
        const label: []const u8 = if (i == 0) "Global" else "Actor";
        sdk.render.drawText(label, panel_x + 18.0 * s, y + 2.0 * s, font, text_color);
        y += row_h;
    }
}

fn renderActors(panel_x: f32, panel_y: f32, panel_w: f32, panel_h: f32, text_color: i32, accent_color: i32) void {
    _ = panel_w;
    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    const row_h: f32 = 22.0 * s;
    if (state.rows_len == 0) {
        sdk.render.drawText("no actors", panel_x + 18.0 * s, panel_y + 22.0 * s, font, text_color);
        return;
    }

    var y = panel_y + firstRowStart(.actors) * s;
    const panel_bottom = panel_y + panel_h - 8.0 * s;
    const end = @min(state.rows_len, state.scroll_top + state.VISIBLE_ROWS);
    var i = state.scroll_top;
    while (i < end) : (i += 1) {
        if (y + 13.0 * s > panel_bottom) break;
        if (i == state.selected) sdk.render.drawFilledRect(panel_x + 8.0 * s, y + 6.0 * s, 4.0 * s, 4.0 * s, accent_color);
        sdk.render.drawText(state.actorName(i), panel_x + 18.0 * s, y + 2.0 * s, font, text_color);
        y += row_h;
    }
}

fn renderCategories(panel_x: f32, panel_y: f32, panel_w: f32, panel_h: f32, text_color: i32, accent_color: i32) void {
    _ = panel_w;
    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    const row_h: f32 = 22.0 * s;
    const row_start = firstRowStart(.categories);
    renderScopeHeader(panel_x, panel_y, text_color);
    if (state.rows_len == 0) {
        sdk.render.drawText("no settings loaded", panel_x + 18.0 * s, panel_y + row_start * s, font, text_color);
        return;
    }

    var y = panel_y + row_start * s;
    const panel_bottom = panel_y + panel_h - 8.0 * s;
    const end = @min(state.rows_len, state.scroll_top + state.VISIBLE_ROWS);
    var i = state.scroll_top;
    while (i < end) : (i += 1) {
        if (y + 13.0 * s > panel_bottom) break;
        if (i == state.selected) sdk.render.drawFilledRect(panel_x + 8.0 * s, y + 6.0 * s, 4.0 * s, 4.0 * s, accent_color);
        if (i == 0) {
            drawSearchLabel(panel_x + 18.0 * s, y + 2.0 * s, text_color, false);
        } else if (i - 1 < state.categories_len) {
            drawCategoryLabel(&state.categories[i - 1], panel_x + 18.0 * s, y + 2.0 * s, text_color);
        }
        y += row_h;
    }
}

fn renderSettings(panel_x: f32, panel_y: f32, panel_w: f32, panel_h: f32, text_color: i32, accent_color: i32, muted_color: i32) void {
    _ = panel_w;
    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    const row_h: f32 = 22.0 * s;
    const row_start = firstRowStart(.settings);
    renderScopeHeader(panel_x, panel_y, text_color);
    if (state.rows_len == 0) {
        sdk.render.drawText("no settings loaded", panel_x + 18.0 * s, panel_y + row_start * s, font, text_color);
        return;
    }

    var y = panel_y + row_start * s;
    const panel_bottom = panel_y + panel_h - 8.0 * s;
    const end = @min(state.rows_len, state.scroll_top + state.VISIBLE_ROWS);
    var i = state.scroll_top;
    while (i < end) : (i += 1) {
        const row = &state.rows[i];
        if (row.kind == .back) {
            if (y + 13.0 * s > panel_bottom) break;
            if (i == state.selected) sdk.render.drawFilledRect(panel_x + 8.0 * s, y + 6.0 * s, 4.0 * s, 4.0 * s, accent_color);
            sdk.render.drawText("< Back", panel_x + 18.0 * s, y + 2.0 * s, font, accent_color);
            y += row_h;
            continue;
        }
        if (row.kind == .spacer) {
            if (y + 13.0 * s > panel_bottom) break;
            y += row_h;
            continue;
        }

        if (y + 13.0 * s > panel_bottom) break;
        const is_editing = state.editing and i == state.selected;
        renderSelectionMark(panel_x + 8.0 * s, y + 6.0 * s, i == state.selected, is_editing, accent_color);
        const inherited = rowIsInheritedGlobal(row, is_editing);
        const label_color = if (inherited) inheritedTextColor(text_color) else text_color;
        sdk.render.drawText(row.display(), panel_x + 18.0 * s, y + 2.0 * s, font, label_color);
        if (!inherited) {
            renderValue(row, panel_x + 218.0 * s, y, 184.0 * s, row_h, is_editing, i == state.selected, text_color, accent_color, muted_color);
        }
        y += row_h;
    }
}

fn renderSearch(panel_x: f32, panel_y: f32, panel_w: f32, panel_h: f32, text_color: i32, accent_color: i32) void {
    _ = panel_w;
    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    const row_h: f32 = 22.0 * s;
    const row_start = firstRowStart(.search);
    renderScopeHeader(panel_x, panel_y, text_color);
    drawSearchLabel(panel_x + 18.0 * s, panel_y + (12.0 + headerHeight(.search)) * s, text_color, true);
    if (state.rows_len == 0) {
        sdk.render.drawText("no matches", panel_x + 18.0 * s, panel_y + row_start * s, font, text_color);
        return;
    }

    var y = panel_y + row_start * s;
    const panel_bottom = panel_y + panel_h - 8.0 * s;
    const end = @min(state.rows_len, state.scroll_top + state.VISIBLE_ROWS);
    var i = state.scroll_top;
    while (i < end) : (i += 1) {
        if (y + 13.0 * s > panel_bottom) break;
        const row = &state.rows[i];
        if (i == state.selected) sdk.render.drawFilledRect(panel_x + 8.0 * s, y + 6.0 * s, 4.0 * s, 4.0 * s, accent_color);
        var label_buf: [128]u8 = undefined;
        const label = std.fmt.bufPrint(label_buf[0..], "{s}  {s}", .{ row.category(), row.display() }) catch row.display();
        const label_color = if (rowIsInheritedGlobal(row, false)) inheritedTextColor(text_color) else text_color;
        sdk.render.drawText(label, panel_x + 18.0 * s, y + 2.0 * s, font, label_color);
        y += row_h;
    }
}

fn renderOverflowCue(panel_x: f32, panel_y: f32, panel_w: f32, panel_h: f32, accent_color: i32) void {
    if (state.rows_len == 0) return;

    const s = sdk.render.scale();
    const row_start: f32 = firstRowStart(state.view_mode);
    const row_y = panel_y + row_start * s;
    const panel_bottom = panel_y + panel_h - 8.0 * s;
    const text_bottom = row_y + 13.0 * s;
    if (text_bottom > panel_bottom) return;

    const row_capacity: usize = @as(usize, @intFromFloat(@floor((panel_bottom - text_bottom) / (22.0 * s)))) + 1;
    const visible_rows = @min(state.VISIBLE_ROWS, row_capacity);
    if (state.scroll_top + visible_rows >= state.rows_len) return;

    const ac: u32 = @bitCast(accent_color);
    const cue_color = sdk.render.rgba(
        @intCast(ac & 0xFF),
        @intCast((ac >> 8) & 0xFF),
        @intCast((ac >> 16) & 0xFF),
        255,
    );
    const cx = panel_x + panel_w * 0.5;
    const top_y = panel_bottom;
    const tip_y = panel_y + panel_h - 3.0 * s;
    const half_w = 14.0 * s;
    sdk.render.drawFilledRect(cx - 22.0 * s, top_y + 1.0 * s, 44.0 * s, 2.0 * s, cue_color);
    sdk.render.drawLine(cx - half_w, top_y, cx, tip_y, cue_color);
    sdk.render.drawLine(cx + half_w, top_y, cx, tip_y, cue_color);
}

fn renderHelp(vp_w: f32, vp_h: f32, panel_color: i32, accent_color: i32, text_color: i32, pos_index: usize) void {
    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    const default_keybind_capturing = state.editing and focusedControlIs("keybind_default");
    const help_w_base: f32 = if (default_keybind_capturing) 300.0 else 240.0;
    const help_w: f32 = help_w_base * s;
    const help_h: f32 = 88.0 * s;
    const help_pos = layout.helpPosition(vp_w, vp_h, help_w, help_h, pos_index);
    sdk.render.drawFilledRect(help_pos.x, help_pos.y, help_w, help_h, panel_color);
    sdk.render.drawRect(help_pos.x, help_pos.y, help_w, help_h, accent_color, 2.0 * s);
    sdk.render.drawText("Up/Down  navigate", help_pos.x + 10.0 * s, help_pos.y + 12.0 * s, font, text_color);
    sdk.render.drawText("Enter    open / edit", help_pos.x + 10.0 * s, help_pos.y + 30.0 * s, font, text_color);
    const escape_text = if (default_keybind_capturing) "Press any key to override; Esc keeps Default" else "ESC      back / close";
    sdk.render.drawText(escape_text, help_pos.x + 10.0 * s, help_pos.y + 48.0 * s, font, text_color);
    if (!default_keybind_capturing) sdk.render.drawText("Delete   reset default", help_pos.x + 10.0 * s, help_pos.y + 66.0 * s, font, text_color);
}

fn glyphAdvancePx(size: f32) f32 {
    const clamped: f32 = if (size < 1.0) 1.0 else size;
    const height: i32 = @intFromFloat(clamped + 0.5);
    const width = @divTrunc(height * 5 + 3, 7);
    const advance = width + @max(@divTrunc(height + 6, 7), 1);
    return @floatFromInt(advance);
}

fn renderDescriptionPanel(panel_x: f32, panel_y: f32, panel_w: f32, panel_h: f32, panel_color: i32, accent_color: i32, text_color: i32, pos_index: usize) void {
    if (state.view_mode != .settings and state.view_mode != .search) return;
    if (state.rows_len == 0 or state.selected >= state.rows_len) return;
    const row = &state.rows[state.selected];
    if (row.kind != .setting) return;
    const desc = row.description();
    if (desc.len == 0) return;

    const s = sdk.render.scale();
    const font: f32 = FONT_BASE * s;
    const pad_x: f32 = 8.0 * s;
    const pad_y: f32 = 8.0 * s;
    const inner_w = @max(panel_w - pad_x * 2.0, font);
    const max_cols: usize = @max(1, @as(usize, @intFromFloat(@floor(inner_w / glyphAdvancePx(font)))));
    var wrapped: [MAX_DESCRIPTION_LINES]DescriptionLine = undefined;
    const line_count = wrapDescription(desc, max_cols, wrapped[0..]);
    if (line_count == 0) return;

    const line_h = DESCRIPTION_LINE_H * s;
    const desc_h: f32 = @max(32.0 * s, pad_y * 2.0 + line_h * @as(f32, @floatFromInt(line_count)));
    const bottom_aligned = layout.isBottomAligned(pos_index);
    const desc_y = if (bottom_aligned)
        panel_y - desc_h - 6.0 * s
    else
        panel_y + panel_h + 6.0 * s;

    sdk.render.drawFilledRect(panel_x, desc_y, panel_w, desc_h, panel_color);
    sdk.render.drawRect(panel_x, desc_y, panel_w, desc_h, accent_color, 2.0 * s);

    const first_y = if (line_count == 1) desc_y + desc_h * 0.5 - 5.0 * s else desc_y + pad_y;
    var i: usize = 0;
    while (i < line_count) : (i += 1) {
        const line = wrapped[i];
        sdk.render.drawText(desc[line.start..line.end], panel_x + pad_x, first_y + line_h * @as(f32, @floatFromInt(i)), font, text_color);
    }
}

fn wrapDescription(desc: []const u8, max_cols: usize, out: []DescriptionLine) usize {
    var count: usize = 0;
    var i: usize = 0;
    while (i < desc.len and count < out.len) {
        while (i < desc.len and isInlineSpace(desc[i])) : (i += 1) {}
        if (i >= desc.len) break;
        if (isLineBreak(desc[i])) {
            i = skipLineBreak(desc, i);
            continue;
        }

        const start = i;
        var last_space: ?usize = null;
        var cols: usize = 0;
        while (i < desc.len and cols < max_cols) {
            const c = desc[i];
            if (isLineBreak(c)) break;
            if (isInlineSpace(c)) last_space = i;
            i += 1;
            cols += 1;
        }

        var end = i;
        if (i < desc.len) {
            if (isLineBreak(desc[i])) {
                i = skipLineBreak(desc, i);
            } else if (cols >= max_cols) {
                if (last_space) |space| {
                    if (space > start) {
                        end = space;
                        i = space + 1;
                        while (i < desc.len and isInlineSpace(desc[i])) : (i += 1) {}
                    }
                }
            }
        }

        while (end > start and isInlineSpace(desc[end - 1])) : (end -= 1) {}
        if (end > start) {
            out[count] = .{ .start = start, .end = end };
            count += 1;
        }
    }
    return count;
}

fn isInlineSpace(c: u8) bool {
    return c == ' ' or c == '\t';
}

fn isLineBreak(c: u8) bool {
    return c == '\n' or c == '\r';
}

fn skipLineBreak(text: []const u8, index: usize) usize {
    if (text[index] == '\r' and index + 1 < text.len and text[index + 1] == '\n') {
        return index + 2;
    }
    return index + 1;
}

fn focusedControlIs(control: []const u8) bool {
    if (state.view_mode != .settings) return false;
    if (state.rows_len == 0 or state.selected >= state.rows_len) return false;
    const row = &state.rows[state.selected];
    return row.kind == .setting and std.mem.eql(u8, row.control(), control);
}

fn renderSelectionMark(x: f32, y: f32, is_selected: bool, is_editing: bool, accent_color: i32) void {
    if (!is_selected) return;
    const s = sdk.render.scale();
    if (is_editing) {
        sdk.render.drawFilledRect(x - 1.0 * s, y - 1.0 * s, 6.0 * s, 6.0 * s, accent_color);
    } else {
        sdk.render.drawFilledRect(x, y, 4.0 * s, 4.0 * s, accent_color);
    }
}

fn drawSearchLabel(x: f32, y: f32, color: i32, force_cursor: bool) void {
    const s = sdk.render.scale();
    var buf: [80]u8 = undefined;
    const q = state.search_buf[0..state.search_len];
    const text = if (force_cursor or state.search_typing)
        std.fmt.bufPrint(buf[0..], "Search: {s}_", .{q}) catch "Search"
    else if (state.search_len != 0)
        std.fmt.bufPrint(buf[0..], "Search: {s}", .{q}) catch "Search"
    else
        "Search";
    sdk.render.drawText(text, x, y, FONT_BASE * s, color);
}

fn drawCategoryLabel(category: *const state.Category, x: f32, y: f32, color: i32) void {
    const s = sdk.render.scale();
    var buf: [96]u8 = undefined;
    const label = std.fmt.bufPrint(buf[0..], "{s} ({d})", .{ category.name(), category.setting_count }) catch category.name();
    sdk.render.drawText(label, x, y, FONT_BASE * s, color);
}

fn renderValue(row: *const state.Row, x: f32, y: f32, w: f32, h: f32, is_editing: bool, is_selected: bool, text_color: i32, accent_color: i32, muted_color: i32) void {
    const s = sdk.render.scale();
    const content_h: f32 = 14.0 * s;
    if (is_editing) sdk.render.drawRect(x, y - 4.0 * s, w, h, accent_color, 2.0 * s);
    const control = row.control();
    const isKeybind = state.isKeybindControl(control);
    if (isKeybind and row.type_tag == state.TYPE_U32 and row.size >= 4) {
        sdk.render.elements.basic.keybind.render(x, y, w, content_h, rows.live(u32, row).*, is_editing, text_color);
        return;
    }
    if (std.mem.eql(u8, control, "multi") and row.type_tag == state.TYPE_U32 and row.size >= 4 and !row.options_overflow) {
        const opts = row.options();
        sdk.render.elements.basic.multi.render(x, y, w, content_h, rows.live(u32, row).*, opts, text_color);
        return;
    }
    if (std.mem.eql(u8, control, "slider") and row.size >= 4) {
        if (row.type_tag == state.TYPE_F32) {
            const min = rows.minF32(row) orelse 0.0;
            const max = rows.maxF32(row) orelse 1.0;
            sdk.render.elements.basic.slider.renderF32(x, y, w, content_h, rows.live(f32, row).*, min, max, accent_color, muted_color);
            if (is_selected) {
                var buf: [32]u8 = undefined;
                drawSliderValueCentered(formatSliderValue(row, buf[0..]), x, y, w, content_h, text_color);
            }
            return;
        }
        if (row.type_tag == state.TYPE_U32 or row.type_tag == state.TYPE_I32) {
            const min = rows.minU32(row) orelse 0;
            const max = rows.maxU32(row) orelse 255;
            sdk.render.elements.basic.slider.render(x, y, w, content_h, rows.live(u32, row).*, min, max, accent_color, muted_color);
            if (is_selected) {
                var buf: [32]u8 = undefined;
                drawSliderValueCentered(formatSliderValue(row, buf[0..]), x, y, w, content_h, text_color);
            }
            return;
        }
    }
    if (std.mem.eql(u8, control, "color") and row.type_tag == state.TYPE_U32 and row.size >= 4) {
        const val = rows.live(u32, row).*;
        sdk.render.elements.basic.colorpicker.render(x, y, w, content_h, val, is_editing);
        if (is_selected) {
            const alpha: u32 = (val >> 24) & 0xFF;
            const pct: u32 = @divTrunc(alpha * 100, 255);
            var buf: [16]u8 = undefined;
            const t = std.fmt.bufPrint(buf[0..], "{d}%", .{pct}) catch "?";
            drawSliderValueCentered(t, x, y, w, content_h, text_color);
        }
        return;
    }
    if (row.type_tag == state.TYPE_BOOL and row.size >= 1) {
        sdk.render.elements.basic.boolean.render(x, y, w, content_h, rows.live(bool, row).*, accent_color);
        return;
    }
    if ((row.type_tag == state.TYPE_U32 or row.type_tag == state.TYPE_I32 or row.type_tag == state.TYPE_I64 or row.type_tag == state.TYPE_F32 or row.type_tag == state.TYPE_F64) and row.min != null and row.max != null and row.size >= 4) {
        const min = rows.minU32(row) orelse 0;
        const max = rows.maxU32(row) orelse 255;
        sdk.render.elements.basic.slider.render(x, y, w, content_h, rows.live(u32, row).*, min, max, accent_color, muted_color);
        if (is_selected) {
            var buf: [32]u8 = undefined;
            const t = std.fmt.bufPrint(buf[0..], "{d}", .{rows.live(u32, row).*}) catch "?";
            drawSliderValueCentered(t, x, y, w, content_h, text_color);
        }
        return;
    }

    var buf: [32]u8 = undefined;
    const text = formatPlain(row, buf[0..]);
    sdk.render.drawText(text, x + w - 86.0 * s, y + content_h * 0.5 - 5.0 * s, FONT_BASE * s, text_color);
}

fn drawSliderValueCentered(text: []const u8, x: f32, y: f32, w: f32, content_h: f32, text_color: i32) void {
    const s = sdk.render.scale();
    sdk.render.drawTextCentered(text, x + w * 0.5, y + content_h * 0.5 - 5.0 * s, FONT_BASE * s, text_color);
}

fn formatSliderValue(row: *const state.Row, out: []u8) []const u8 {
    return switch (row.type_tag) {
        state.TYPE_F32 => std.fmt.bufPrint(out, "{d:.2}", .{rows.live(f32, row).*}) catch "?",
        state.TYPE_I32 => std.fmt.bufPrint(out, "{d}", .{rows.live(i32, row).*}) catch "?",
        else => std.fmt.bufPrint(out, "{d}", .{rows.live(u32, row).*}) catch "?",
    };
}

fn formatPlain(row: *const state.Row, out: []u8) []const u8 {
    return switch (row.type_tag) {
        state.TYPE_U32 => std.fmt.bufPrint(out, "{d}", .{rows.live(u32, row).*}) catch "?",
        state.TYPE_I32 => std.fmt.bufPrint(out, "{d}", .{rows.live(i32, row).*}) catch "?",
        else => std.fmt.bufPrint(out, "0x{X:0>8}", .{rows.live(u32, row).*}) catch "?",
    };
}

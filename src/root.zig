const sdk = @import("sdk");
const state = @import("state.zig");
const rows = @import("rows.zig");
const input = @import("input.zig");
const render = @import("render.zig");

const Settings = sdk.Settings("Tab GUI", struct {
    open_key: u32 = 0x24,
    position: u32 = 2,
    hide_help: bool = false,
    panel_color: u32 = 0xCC101015,
    accent_color: u32 = 0xFFA0A0FF,
    bar_speed: u32 = 32,
}, .{
    .open_key = .{ .control = "keybind", .display_name = "Toggle Key" },
    .position = .{ .control = "multi", .display_name = "Position", .options = .{
        "top-left",      "top-center",   "top-right",
        "middle-left",   "middle-right", "bottom-left",
        "bottom-center", "bottom-right",
    } },
    .hide_help = .{ .display_name = "Hide Help" },
    .panel_color = .{ .control = "color", .display_name = "Panel Color" },
    .accent_color = .{ .control = "color", .display_name = "Accent Color" },
    .bar_speed = .{ .control = "slider", .display_name = "Bar Speed", .min = 0, .max = 255 },
});

export fn onUnload() void {
    if (state.visible) sdk.settings_view.save();
    sdk.input.setDisabled(false);
    state.visible = false;
    state.visible_prev = false;
}

export fn onUIFrame() void {
    const open_key: u8 = if (Settings.data.open_key == 0) @intFromEnum(sdk.Key.home) else @as(u8, @truncate(Settings.data.open_key));
    const configured_pressed = sdk.keyPressed(open_key);
    const alternate_pressed = sdk.isKeyDown(.ctrl) and sdk.isKeyDown(.shift) and sdk.isKeyPressed(.m);
    if (configured_pressed or alternate_pressed) {
        state.visible = !state.visible;
    }
    if (open_key != @intFromEnum(sdk.Key.home) and sdk.keyPressed(@intFromEnum(sdk.Key.home))) {
        sdk.info("tab-gui: Home ignored; configured toggle key is {s} (0x{x})", .{
            sdk.input.keyName(open_key) orelse "unknown",
            open_key,
        });
    }
    const was_visible = state.visible_prev;
    if (state.visible and !was_visible) {
        sdk.settings_view.snapshot();
        state.openNavigation();
        sdk.input.setDisabled(true);
    }
    if (!state.visible and was_visible) {
        sdk.settings_view.save();
        sdk.input.setDisabled(false);
    }
    state.visible_prev = state.visible;
    if (!state.visible) return;

    rows.refillRows();
    rows.clampSelection();

    switch (state.view_mode) {
        .scope => input.handleScopeInput(),
        .actors => input.handleActorsInput(),
        .categories => input.handleCategoriesInput(),
        .settings => input.handleSettingsInput(),
        .search => input.handleSearchInput(),
    }

    rows.refillRows();
    rows.clampSelection();
    render.renderPanel(Settings.data.panel_color, Settings.data.accent_color, Settings.data.hide_help, Settings.data.position);
}

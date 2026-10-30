const std = @import("std");

const app_names = [_][]const u8{};

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .cpu_arch = .wasm32, .os_tag = .freestanding });
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseFast });

    const runtime = addModule(b, "sdk/runtime/root.zig", target, optimize, &.{});
    const util = addModule(b, "sdk/util/root.zig", target, optimize, &.{
        .{ .name = "runtime", .module = runtime },
    });
    const sdk = addModule(b, "sdk/extension/root.zig", target, optimize, &.{
        .{ .name = "runtime", .module = runtime },
        .{ .name = "util", .module = util },
    });

    var imports: [app_names.len + 1]std.Build.Module.Import = undefined;
    imports[0] = .{ .name = "sdk", .module = sdk };
    inline for (app_names, 1..) |name, index| {
        const app = addModule(b, "sdk/" ++ name ++ "/root.zig", target, optimize, &.{
            .{ .name = "runtime", .module = runtime },
            .{ .name = "util", .module = util },
            .{ .name = "extension", .module = sdk },
        });
        app.addImport(name, app);
        imports[index] = .{ .name = name, .module = app };
    }

    const check = b.step("check", "Analyze the module without linking");
    b.default_step = check;

    const module = b.addObject(.{
        .name = "module",
        .root_module = addModule(b, "src/root.zig", target, optimize, &imports),
    });
    check.dependOn(&module.step);
}

fn addModule(
    b: *std.Build,
    path: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    imports: []const std.Build.Module.Import,
) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path(path),
        .target = target,
        .optimize = optimize,
        .pic = true,
        .imports = imports,
    });
}

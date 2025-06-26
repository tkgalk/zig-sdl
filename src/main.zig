//! Zig wrapper for SDL2
//! This module provides a safe, idiomatic Zig interface to SDL2.
//!
//! Example usage:
//! ```zig
//! const sdl = @import("sdl2");
//!
//! try sdl.init(.{ .video = true });
//! defer sdl.quit();
//!
//! const window = try sdl.Window.create("My Game", 800, 600, .{});
//! defer window.destroy();
//!
//! const renderer = try sdl.Renderer.create(window, .{});
//! defer renderer.destroy();
//! ```

const std = @import("std");

pub const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

// Core SDL functionality
pub const Init = @import("init.zig");
pub const Window = @import("window.zig");
pub const Renderer = @import("renderer.zig");
pub const Event = @import("event.zig");
pub const Surface = @import("surface.zig");
pub const Texture = @import("texture.zig");
pub const Rect = @import("rect.zig");
pub const Color = @import("color.zig");
pub const Error = @import("error.zig");

// Re-export commonly used types
pub const Point = c.SDL_Point;
pub const FPoint = c.SDL_FPoint;

// Error handling
pub const SdlError = Error.SdlError;

pub const ErrorSet = error{SdlInitFailed};

// Initialize SDL subsystems
pub fn init(flags: Init.Flags) ErrorSet!void {
    if (c.SDL_Init(flags.toMask()) < 0) {
        return error.SdlInitFailed;
    }
}

// Quit SDL
pub fn quit() void {
    c.SDL_Quit();
}

// Get SDL version
pub fn getVersion() c.SDL_version {
    var version: c.SDL_version = undefined;
    c.SDL_GetVersion(&version);
    return version;
}

// Delay execution
pub fn delay(ms: u32) void {
    c.SDL_Delay(ms);
}

// Get performance counter
pub fn getPerformanceCounter() u64 {
    return c.SDL_GetPerformanceCounter();
}

// Get performance frequency
pub fn getPerformanceFrequency() u64 {
    return c.SDL_GetPerformanceFrequency();
}

// Poll events
pub fn pollEvent(event: *c.SDL_Event) bool {
    return c.SDL_PollEvent(event) != 0;
}

// Wait for events
pub fn waitEvent(event: *c.SDL_Event) bool {
    return c.SDL_WaitEvent(event) != 0;
}

// Pump events
pub fn pumpEvents() void {
    c.SDL_PumpEvents();
}

test "basic sdl functionality" {
    // This test will only work if SDL2 is properly linked
    // In a real test environment, you'd want to mock SDL2 or have it available
    _ = getPerformanceFrequency();
    _ = getPerformanceCounter();
}

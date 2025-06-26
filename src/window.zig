//! SDL2 window management

const std = @import("std");
pub const c = @import("main.zig").c;

pub const Window = struct {
    ptr: *c.SDL_Window,

    pub const Flags = struct {
        fullscreen: bool = false,
        opengl: bool = false,
        shown: bool = false,
        hidden: bool = false,
        borderless: bool = false,
        resizable: bool = false,
        minimized: bool = false,
        maximized: bool = false,
        input_grabbed: bool = false,
        input_focus: bool = false,
        mouse_focus: bool = false,
        foreign: bool = false,
        allow_highdpi: bool = false,
        mouse_capture: bool = false,
        always_on_top: bool = false,
        skip_taskbar: bool = false,
        utility: bool = false,
        tooltip: bool = false,
        popup_menu: bool = false,
        keyboard_grabbed: bool = false,
        vulkan: bool = false,
        metal: bool = false,

        pub fn toMask(self: Flags) u32 {
            var mask: u32 = 0;
            if (self.fullscreen) mask |= c.SDL_WINDOW_FULLSCREEN;
            if (self.opengl) mask |= c.SDL_WINDOW_OPENGL;
            if (self.shown) mask |= c.SDL_WINDOW_SHOWN;
            if (self.hidden) mask |= c.SDL_WINDOW_HIDDEN;
            if (self.borderless) mask |= c.SDL_WINDOW_BORDERLESS;
            if (self.resizable) mask |= c.SDL_WINDOW_RESIZABLE;
            if (self.minimized) mask |= c.SDL_WINDOW_MINIMIZED;
            if (self.maximized) mask |= c.SDL_WINDOW_MAXIMIZED;
            if (self.input_grabbed) mask |= c.SDL_WINDOW_INPUT_GRABBED;
            if (self.input_focus) mask |= c.SDL_WINDOW_INPUT_FOCUS;
            if (self.mouse_focus) mask |= c.SDL_WINDOW_MOUSE_FOCUS;
            if (self.foreign) mask |= c.SDL_WINDOW_FOREIGN;
            if (self.allow_highdpi) mask |= c.SDL_WINDOW_ALLOW_HIGHDPI;
            if (self.mouse_capture) mask |= c.SDL_WINDOW_MOUSE_CAPTURE;
            if (self.always_on_top) mask |= c.SDL_WINDOW_ALWAYS_ON_TOP;
            if (self.skip_taskbar) mask |= c.SDL_WINDOW_SKIP_TASKBAR;
            if (self.utility) mask |= c.SDL_WINDOW_UTILITY;
            if (self.tooltip) mask |= c.SDL_WINDOW_TOOLTIP;
            if (self.popup_menu) mask |= c.SDL_WINDOW_POPUP_MENU;
            if (self.keyboard_grabbed) mask |= c.SDL_WINDOW_KEYBOARD_GRABBED;
            if (self.vulkan) mask |= c.SDL_WINDOW_VULKAN;
            if (self.metal) mask |= c.SDL_WINDOW_METAL;
            return mask;
        }
    };

    pub fn create(title: [*:0]const u8, x: i32, y: i32, w: i32, h: i32, flags: Flags) !Window {
        const window = c.SDL_CreateWindow(title, x, y, w, h, flags.toMask());
        if (window == null) {
            return error.WindowCreationFailed;
        }
        return Window{ .ptr = window.? };
    }

    pub fn destroy(self: Window) void {
        c.SDL_DestroyWindow(self.ptr);
    }

    pub fn getSize(self: Window) struct { w: i32, h: i32 } {
        var w: i32 = undefined;
        var h: i32 = undefined;
        c.SDL_GetWindowSize(self.ptr, &w, &h);
        return .{ .w = w, .h = h };
    }

    pub fn setSize(self: Window, w: i32, h: i32) void {
        c.SDL_SetWindowSize(self.ptr, w, h);
    }

    pub fn getPosition(self: Window) struct { x: i32, y: i32 } {
        var x: i32 = undefined;
        var y: i32 = undefined;
        c.SDL_GetWindowPosition(self.ptr, &x, &y);
        return .{ .x = x, .y = y };
    }

    pub fn setPosition(self: Window, x: i32, y: i32) void {
        c.SDL_SetWindowPosition(self.ptr, x, y);
    }

    pub fn setTitle(self: Window, title: [*:0]const u8) void {
        c.SDL_SetWindowTitle(self.ptr, title);
    }

    pub fn getTitle(self: Window) [*:0]const u8 {
        return c.SDL_GetWindowTitle(self.ptr);
    }

    pub fn show(self: Window) void {
        c.SDL_ShowWindow(self.ptr);
    }

    pub fn hide(self: Window) void {
        c.SDL_HideWindow(self.ptr);
    }

    pub fn raise(self: Window) void {
        c.SDL_RaiseWindow(self.ptr);
    }

    pub fn restore(self: Window) void {
        c.SDL_RestoreWindow(self.ptr);
    }

    pub fn maximize(self: Window) void {
        c.SDL_MaximizeWindow(self.ptr);
    }

    pub fn minimize(self: Window) void {
        c.SDL_MinimizeWindow(self.ptr);
    }

    pub fn setFullscreen(self: Window, flags: u32) !void {
        if (c.SDL_SetWindowFullscreen(self.ptr, flags) < 0) {
            return error.FullscreenFailed;
        }
    }

    pub fn getSurface(self: Window) !*c.SDL_Surface {
        const surface = c.SDL_GetWindowSurface(self.ptr);
        if (surface == null) {
            return error.SurfaceCreationFailed;
        }
        return surface;
    }

    pub fn updateSurface(self: Window) !void {
        if (c.SDL_UpdateWindowSurface(self.ptr) < 0) {
            return error.SurfaceUpdateFailed;
        }
    }
};

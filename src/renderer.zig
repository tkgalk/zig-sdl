//! SDL2 renderer for hardware-accelerated graphics

const std = @import("std");
pub const c = @import("main.zig").c;

pub const Renderer = struct {
    ptr: *c.SDL_Renderer,

    pub const Flags = struct {
        software: bool = false,
        accelerated: bool = false,
        presentvsync: bool = false,
        targettexture: bool = false,

        pub fn toMask(self: Flags) u32 {
            var mask: u32 = 0;
            if (self.software) mask |= c.SDL_RENDERER_SOFTWARE;
            if (self.accelerated) mask |= c.SDL_RENDERER_ACCELERATED;
            if (self.presentvsync) mask |= c.SDL_RENDERER_PRESENTVSYNC;
            if (self.targettexture) mask |= c.SDL_RENDERER_TARGETTEXTURE;
            return mask;
        }
    };

    pub fn create(window: *c.SDL_Window, index: i32, flags: Flags) !Renderer {
        const renderer = c.SDL_CreateRenderer(window, index, flags.toMask());
        if (renderer == null) {
            return error.RendererCreationFailed;
        }
        return Renderer{ .ptr = renderer.? };
    }

    pub fn destroy(self: Renderer) void {
        c.SDL_DestroyRenderer(self.ptr);
    }

    pub fn clear(self: Renderer) !void {
        if (c.SDL_RenderClear(self.ptr) < 0) {
            return error.RenderClearFailed;
        }
    }

    pub fn present(self: Renderer) void {
        c.SDL_RenderPresent(self.ptr);
    }

    pub fn setDrawColor(self: Renderer, r: u8, g: u8, b: u8, a: u8) !void {
        if (c.SDL_SetRenderDrawColor(self.ptr, r, g, b, a) < 0) {
            return error.SetDrawColorFailed;
        }
    }

    pub fn getDrawColor(self: Renderer) struct { r: u8, g: u8, b: u8, a: u8 } {
        var r: u8 = undefined;
        var g: u8 = undefined;
        var b: u8 = undefined;
        var a: u8 = undefined;
        c.SDL_GetRenderDrawColor(self.ptr, &r, &g, &b, &a);
        return .{ .r = r, .g = g, .b = b, .a = a };
    }

    pub fn drawPoint(self: Renderer, x: i32, y: i32) !void {
        if (c.SDL_RenderDrawPoint(self.ptr, x, y) < 0) {
            return error.DrawPointFailed;
        }
    }

    pub fn drawLine(self: Renderer, x1: i32, y1: i32, x2: i32, y2: i32) !void {
        if (c.SDL_RenderDrawLine(self.ptr, x1, y1, x2, y2) < 0) {
            return error.DrawLineFailed;
        }
    }

    pub fn drawRect(self: Renderer, rect: ?*const c.SDL_Rect) !void {
        if (c.SDL_RenderDrawRect(self.ptr, rect) < 0) {
            return error.DrawRectFailed;
        }
    }

    pub fn fillRect(self: Renderer, rect: ?*const c.SDL_Rect) !void {
        if (c.SDL_RenderFillRect(self.ptr, rect) < 0) {
            return error.FillRectFailed;
        }
    }

    pub fn copy(self: Renderer, texture: *c.SDL_Texture, srcrect: ?*const c.SDL_Rect, dstrect: ?*const c.SDL_Rect) !void {
        if (c.SDL_RenderCopy(self.ptr, texture, srcrect, dstrect) < 0) {
            return error.RenderCopyFailed;
        }
    }

    pub fn copyEx(self: Renderer, texture: *c.SDL_Texture, srcrect: ?*const c.SDL_Rect, dstrect: ?*const c.SDL_Rect, angle: f64, center: ?*const c.SDL_Point, flip: c.SDL_RendererFlip) !void {
        if (c.SDL_RenderCopyEx(self.ptr, texture, srcrect, dstrect, angle, center, flip) < 0) {
            return error.RenderCopyExFailed;
        }
    }

    pub fn setViewport(self: Renderer, rect: ?*const c.SDL_Rect) !void {
        if (c.SDL_RenderSetViewport(self.ptr, rect) < 0) {
            return error.SetViewportFailed;
        }
    }

    pub fn getViewport(self: Renderer) c.SDL_Rect {
        var rect: c.SDL_Rect = undefined;
        c.SDL_RenderGetViewport(self.ptr, &rect);
        return rect;
    }

    pub fn setClipRect(self: Renderer, rect: ?*const c.SDL_Rect) !void {
        if (c.SDL_RenderSetClipRect(self.ptr, rect) < 0) {
            return error.SetClipRectFailed;
        }
    }

    pub fn getClipRect(self: Renderer) c.SDL_Rect {
        var rect: c.SDL_Rect = undefined;
        c.SDL_RenderGetClipRect(self.ptr, &rect);
        return rect;
    }

    pub fn setScale(self: Renderer, scaleX: f32, scaleY: f32) !void {
        if (c.SDL_RenderSetScale(self.ptr, scaleX, scaleY) < 0) {
            return error.SetScaleFailed;
        }
    }

    pub fn getScale(self: Renderer) struct { x: f32, y: f32 } {
        var x: f32 = undefined;
        var y: f32 = undefined;
        c.SDL_RenderGetScale(self.ptr, &x, &y);
        return .{ .x = x, .y = y };
    }
};

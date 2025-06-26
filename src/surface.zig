//! SDL2 surface operations

const std = @import("std");
pub const c = @import("main.zig").c;

pub const Surface = struct {
    ptr: *c.SDL_Surface,

    pub fn createRGB(width: i32, height: i32, depth: i32, rmask: u32, gmask: u32, bmask: u32, amask: u32) !Surface {
        const surface = c.SDL_CreateRGBSurface(0, width, height, depth, rmask, gmask, bmask, amask);
        if (surface == null) {
            return error.SurfaceCreationFailed;
        }
        return Surface{ .ptr = surface };
    }

    pub fn destroy(self: Surface) void {
        c.SDL_FreeSurface(self.ptr);
    }

    pub fn getSize(self: Surface) struct { w: i32, h: i32 } {
        return .{ .w = self.ptr.w, .h = self.ptr.h };
    }

    pub fn fillRect(self: Surface, rect: ?*const c.SDL_Rect, color: u32) !void {
        if (c.SDL_FillRect(self.ptr, rect, color) < 0) {
            return error.FillRectFailed;
        }
    }

    pub fn blitSurface(self: Surface, srcrect: ?*const c.SDL_Rect, dst: *c.SDL_Surface, dstrect: ?*c.SDL_Rect) !void {
        if (c.SDL_BlitSurface(self.ptr, srcrect, dst, dstrect) < 0) {
            return error.BlitSurfaceFailed;
        }
    }
};

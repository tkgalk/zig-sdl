//! SDL2 rectangle operations

const std = @import("std");
pub const c = @import("main.zig").c;

pub const Rect = struct {
    pub fn new(x: i32, y: i32, w: i32, h: i32) c.SDL_Rect {
        return c.SDL_Rect{ .x = x, .y = y, .w = w, .h = h };
    }

    pub fn hasIntersection(a: *const c.SDL_Rect, b: *const c.SDL_Rect) bool {
        return c.SDL_HasIntersection(a, b) != 0;
    }

    pub fn intersectRect(a: *const c.SDL_Rect, b: *const c.SDL_Rect, result: *c.SDL_Rect) bool {
        return c.SDL_IntersectRect(a, b, result) != 0;
    }

    pub fn unionRect(a: *const c.SDL_Rect, b: *const c.SDL_Rect, result: *c.SDL_Rect) void {
        c.SDL_UnionRect(a, b, result);
    }

    pub fn enclosePoints(points: [*]const c.SDL_Point, count: i32, clip: ?*const c.SDL_Rect, result: *c.SDL_Rect) bool {
        return c.SDL_EnclosePoints(points, count, clip, result) != 0;
    }

    pub fn intersectRectAndLine(rect: *const c.SDL_Rect, x1: *i32, y1: *i32, x2: *i32, y2: *i32) bool {
        return c.SDL_IntersectRectAndLine(rect, x1, y1, x2, y2) != 0;
    }
};

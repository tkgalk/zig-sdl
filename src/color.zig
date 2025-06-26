//! SDL2 color operations

const std = @import("std");
pub const c = @import("main.zig").c;

pub const Color = struct {
    pub fn new(r: u8, g: u8, b: u8, a: u8) c.SDL_Color {
        return c.SDL_Color{ .r = r, .g = g, .b = b, .a = a };
    }

    pub fn newRGB(r: u8, g: u8, b: u8) c.SDL_Color {
        return c.SDL_Color{ .r = r, .g = g, .b = b, .a = 255 };
    }

    pub fn black() c.SDL_Color {
        return newRGB(0, 0, 0);
    }

    pub fn white() c.SDL_Color {
        return newRGB(255, 255, 255);
    }

    pub fn red() c.SDL_Color {
        return newRGB(255, 0, 0);
    }

    pub fn green() c.SDL_Color {
        return newRGB(0, 255, 0);
    }

    pub fn blue() c.SDL_Color {
        return newRGB(0, 0, 255);
    }

    pub fn yellow() c.SDL_Color {
        return newRGB(255, 255, 0);
    }

    pub fn cyan() c.SDL_Color {
        return newRGB(0, 255, 255);
    }

    pub fn magenta() c.SDL_Color {
        return newRGB(255, 0, 255);
    }

    pub fn gray() c.SDL_Color {
        return newRGB(128, 128, 128);
    }

    pub fn darkGray() c.SDL_Color {
        return newRGB(64, 64, 64);
    }

    pub fn lightGray() c.SDL_Color {
        return newRGB(192, 192, 192);
    }
};

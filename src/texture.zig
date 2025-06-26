//! SDL2 texture operations

const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub const Texture = struct {
    ptr: *c.SDL_Texture,

    pub fn create(renderer: *c.SDL_Renderer, format: u32, access: i32, w: i32, h: i32) !Texture {
        const texture = c.SDL_CreateTexture(renderer, format, access, w, h);
        if (texture == null) {
            return error.TextureCreationFailed;
        }
        return Texture{ .ptr = texture };
    }

    pub fn createFromSurface(renderer: *c.SDL_Renderer, surface: *c.SDL_Surface) !Texture {
        const texture = c.SDL_CreateTextureFromSurface(renderer, surface);
        if (texture == null) {
            return error.TextureCreationFailed;
        }
        return Texture{ .ptr = texture };
    }

    pub fn destroy(self: Texture) void {
        c.SDL_DestroyTexture(self.ptr);
    }

    pub fn getSize(self: Texture) struct { w: i32, h: i32 } {
        var w: i32 = undefined;
        var h: i32 = undefined;
        c.SDL_QueryTexture(self.ptr, null, null, &w, &h);
        return .{ .w = w, .h = h };
    }

    pub fn setBlendMode(self: Texture, blend_mode: c.SDL_BlendMode) !void {
        if (c.SDL_SetTextureBlendMode(self.ptr, blend_mode) < 0) {
            return error.SetBlendModeFailed;
        }
    }

    pub fn getBlendMode(self: Texture) c.SDL_BlendMode {
        var blend_mode: c.SDL_BlendMode = undefined;
        c.SDL_GetTextureBlendMode(self.ptr, &blend_mode);
        return blend_mode;
    }

    pub fn setAlphaMod(self: Texture, alpha: u8) !void {
        if (c.SDL_SetTextureAlphaMod(self.ptr, alpha) < 0) {
            return error.SetAlphaModFailed;
        }
    }

    pub fn getAlphaMod(self: Texture) u8 {
        var alpha: u8 = undefined;
        c.SDL_GetTextureAlphaMod(self.ptr, &alpha);
        return alpha;
    }

    pub fn setColorMod(self: Texture, r: u8, g: u8, b: u8) !void {
        if (c.SDL_SetTextureColorMod(self.ptr, r, g, b) < 0) {
            return error.SetColorModFailed;
        }
    }

    pub fn getColorMod(self: Texture) struct { r: u8, g: u8, b: u8 } {
        var r: u8 = undefined;
        var g: u8 = undefined;
        var b: u8 = undefined;
        c.SDL_GetTextureColorMod(self.ptr, &r, &g, &b);
        return .{ .r = r, .g = g, .b = b };
    }
};

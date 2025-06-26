//! SDL2 event handling

const std = @import("std");
pub const c = @import("main.zig").c;

pub const Event = struct {
    pub const Type = enum(u32) {
        quit = c.SDL_QUIT,
        window_event = c.SDL_WINDOWEVENT,
        key_down = c.SDL_KEYDOWN,
        key_up = c.SDL_KEYUP,
        mouse_motion = c.SDL_MOUSEMOTION,
        mouse_button_down = c.SDL_MOUSEBUTTONDOWN,
        mouse_button_up = c.SDL_MOUSEBUTTONUP,
        mouse_wheel = c.SDL_MOUSEWHEEL,
    };

    pub fn poll() ?c.SDL_Event {
        var event: c.SDL_Event = undefined;
        if (c.SDL_PollEvent(&event) != 0) {
            return event;
        }
        return null;
    }

    pub fn wait() c.SDL_Event {
        var event: c.SDL_Event = undefined;
        _ = c.SDL_WaitEvent(&event);
        return event;
    }

    pub fn pump() void {
        c.SDL_PumpEvents();
    }

    pub fn push(event: *const c.SDL_Event) !void {
        if (c.SDL_PushEvent(event) < 0) {
            return error.EventPushFailed;
        }
    }
};

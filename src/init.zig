//! SDL2 initialization and subsystem management

const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

pub const Flags = struct {
    timer: bool = false,
    audio: bool = false,
    video: bool = false,
    joystick: bool = false,
    haptic: bool = false,
    gamecontroller: bool = false,
    events: bool = false,
    sensor: bool = false,
    noparachute: bool = false,

    pub fn toMask(self: Flags) u32 {
        var mask: u32 = 0;
        if (self.timer) mask |= c.SDL_INIT_TIMER;
        if (self.audio) mask |= c.SDL_INIT_AUDIO;
        if (self.video) mask |= c.SDL_INIT_VIDEO;
        if (self.joystick) mask |= c.SDL_INIT_JOYSTICK;
        if (self.haptic) mask |= c.SDL_INIT_HAPTIC;
        if (self.gamecontroller) mask |= c.SDL_INIT_GAMECONTROLLER;
        if (self.events) mask |= c.SDL_INIT_EVENTS;
        if (self.sensor) mask |= c.SDL_INIT_SENSOR;
        if (self.noparachute) mask |= c.SDL_INIT_NOPARACHUTE;
        return mask;
    }
};

pub fn initSubSystem(flags: Flags) !void {
    if (c.SDL_InitSubSystem(flags.toMask()) < 0) {
        return error.SdlInitFailed;
    }
}

pub fn quitSubSystem(flags: Flags) void {
    c.SDL_QuitSubSystem(flags.toMask());
}

pub fn wasInit(flags: Flags) u32 {
    return c.SDL_WasInit(flags.toMask());
}

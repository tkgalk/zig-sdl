//! Basic SDL2 window example
//! This example demonstrates how to create a window, renderer, and handle basic events.

const std = @import("std");
const sdl = @import("sdl2");

pub fn main() !void {
    // Initialize SDL with video subsystem
    try sdl.init(.{ .video = true });
    defer sdl.quit();

    // Create a window
    const window = try sdl.Window.Window.create("SDL2 Zig Wrapper Example", sdl.c.SDL_WINDOWPOS_CENTERED, sdl.c.SDL_WINDOWPOS_CENTERED, 800, 600, .{ .shown = true, .resizable = true });
    defer window.destroy();

    // Create a renderer
    const renderer = try sdl.Renderer.Renderer.create(window.ptr, -1, .{ .accelerated = true, .presentvsync = true });
    defer renderer.destroy();

    // Main event loop
    var event: sdl.c.SDL_Event = undefined;
    var running = true;

    while (running) {
        // Handle events
        while (sdl.pollEvent(&event)) {
            switch (event.type) {
                sdl.c.SDL_QUIT => {
                    running = false;
                },
                sdl.c.SDL_KEYDOWN => {
                    if (event.key.keysym.sym == sdl.c.SDLK_ESCAPE) {
                        running = false;
                    }
                },
                else => {},
            }
        }

        // Clear the screen
        try renderer.setDrawColor(0, 0, 0, 255);
        try renderer.clear();

        // Draw a simple rectangle
        try renderer.setDrawColor(255, 255, 255, 255);
        const rect = sdl.Rect.Rect.new(100, 100, 200, 150);
        try renderer.fillRect(@as(?*const sdl.c.SDL_Rect, &rect));

        // Draw a colored rectangle
        try renderer.setDrawColor(255, 0, 0, 255);
        const red_rect = sdl.Rect.Rect.new(350, 100, 200, 150);
        try renderer.fillRect(@as(?*const sdl.c.SDL_Rect, &red_rect));

        // Draw some lines
        try renderer.setDrawColor(0, 255, 0, 255);
        try renderer.drawLine(50, 300, 750, 300);
        try renderer.drawLine(400, 50, 400, 550);

        // Present the render
        renderer.present();

        // Cap the frame rate
        sdl.delay(16); // ~60 FPS
    }
}

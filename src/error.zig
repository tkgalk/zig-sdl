//! Error handling for SDL2 wrapper

const std = @import("std");

pub const SdlError = struct {
    message: []const u8,

    pub fn init(message: []const u8) SdlError {
        return SdlError{ .message = message };
    }

    pub fn format(
        self: SdlError,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("SDL Error: {s}", .{self.message});
    }
};

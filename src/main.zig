const std = @import("std");
const VERSION = "0.1.0";

pub fn main() anyerror!void {
    std.debug.print("🐚 conch v{}\n", .{VERSION});
}

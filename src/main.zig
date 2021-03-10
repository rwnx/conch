const std = @import("std");
const eql = std.mem.eql;
const stdin = std.io.getStdIn().inStream();
const stdout = std.io.getStdOut().outStream();

pub fn main() !void {
    var buf: [10]u8 = undefined;

    while(true) {
      try stdout.print("> ", .{});

      const line = try stdin.readUntilDelimiterOrEof(&buf, '\n');
      
      try stdout.print("\"{}\"\n", .{line});
    }
}
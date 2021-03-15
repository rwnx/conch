const std = @import("std");
const eql = std.mem.eql;
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();
const stderr = std.io.getStdErr().writer();
const print = @import("std").debug.print;

const page_allocator = std.heap.page_allocator;
const ArenaAllocator = std.heap.ArenaAllocator;
const ArrayList = std.ArrayList;

const Allocator = std.mem.Allocator;

const ChildProcess = std.ChildProcess;

fn get_line(allocator: *Allocator) ![]u8 {
    var list = ArrayList(u8).init(allocator);

    while (true) {
        const byte = stdin.readByte() catch |err| switch (err) {
            error.EndOfStream => {
                break;
            },
            else => |e| return e,
        };

        if (byte == '\n') {
            break;
        }

        try list.append(byte);
    }

    return list.items;
}


pub fn main() !void {
    while (true) {
        // alloc Arena + dealloc each loop
        var arena = ArenaAllocator.init(page_allocator);
        defer arena.deinit();
        const allocator = &arena.allocator;

        // prompt for line
        try stdout.print("🐚 > ", .{});
        const line = get_line(allocator) catch "";


        // split,collect argv into args = [][]
        var args = ArrayList([]const u8).init(allocator);
        var tokens = std.mem.tokenize(line, " ");
        while (tokens.next()) | token | {
          try args.append(token);
        }

        const child = try ChildProcess.exec(.{
          .allocator = allocator,
          .argv      = args.items[0..]
        });

        print("{}\n", .{child.stdout[0..]});
    }
}

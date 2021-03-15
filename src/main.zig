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
        var arena = ArenaAllocator.init(page_allocator);
        defer arena.deinit();
        const allocator = &arena.allocator;

        try stdout.print("> ", .{});

        const line = get_line(allocator) catch "";

        print("{}\n", .{line});
    }
}

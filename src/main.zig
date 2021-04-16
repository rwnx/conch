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

fn shutdown() void {
    print("🦀 Bye!\n", .{});
}


fn get_line(allocator: *Allocator) ![]u8 {
    var buffer_size : u64 = 10;
    var read_index : u64 = 0;
    var buffer: []u8 = try allocator.alloc(u8, buffer_size);

    while (true) {
        const byte = try stdin.readByte();

        if (byte) {
            if (byte == '\n') {
                break;
            }
            if(read_index == buffer_size - 1) {
                buffer_size = buffer_size * 2;
                buffer = try allocator.realloc(buffer, buffer_size);
            }
            buffer[read_index] = byte;
            read_index = read_index + 1;

        } else |err| {
            if(err == error.EndOfStream) {
                break;
            } else {
                return err;
            }
        }
    }

    return allocator.shrink(buffer, read_index + 1)[0..read_index];
}

pub fn main() !void {
    while (true) {
        // alloc Arena + dealloc each loop
        var arena = ArenaAllocator.init(page_allocator);
        defer arena.deinit();
        const allocator = &arena.allocator;

        var cwd : std.fs.Dir = std.fs.cwd();
        const cwd_display : []u8 = try cwd.realpathAlloc(allocator, ".");

        // prompt for line
        try stdout.print("🐚{s}> ", .{cwd_display});
        const line = get_line(allocator) catch "";

        // split,collect argv into args = [][]
        var args = ArrayList([]const u8).init(allocator);
        var tokens = std.mem.tokenize(line, " ");
        while (tokens.next()) |token| {
            try args.append(token);
        }
        const argv = args.items[0..];

        if (argv.len < 1) {
            continue;
        }
        const command = argv[0];

        // Builtins!
        if (eql(u8, command, "exit")) {
            shutdown();
            break;
        }

        if (eql(u8, command, "cd")) {
            const new_dir = argv[1];
            var nextdir = cwd.openDir(new_dir, .{});
            

            if(nextdir) |cd_target| {
                try cd_target.setAsCwd();
            } else |err| {
                if(err == error.FileNotFound) {
                    print("cd: no such directory: {s}\n", .{new_dir});
                } else {
                    print("cd: {s}\n", .{err});
                }
            }
            
            continue;
        }

        const child = ChildProcess.exec(.{
            .allocator = allocator,
            .argv = argv,
        }) catch |err| switch (err) {
            error.FileNotFound => {
                print("{s}: command not found\n", .{args.items[0]});
                continue;
            },
            else => |e| {
                print("Fatal: {s}\n", .{e});
                continue;
            },
        };

        print("{s}", .{child.stdout[0..]});
    }
}

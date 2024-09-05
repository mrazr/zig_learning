const std = @import("std");

fn isFile(path: []const u8) bool {
    return std.fs.path.dirname(path) == null;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    for (args) |arg| {
        std.debug.print("Arg: {s}\n", .{arg});
    }
    const app_name = std.fs.path.basename(args[0]);
    if (args.len != 3) {
        std.debug.print("Usage: {s} <filename> <letter>\n", .{app_name});
        return;
    }
    const filename = args[1];
    const letter = args[2][0];
    std.debug.print("Length of filename is {d}\n", .{filename.len});
    std.debug.print("Letter is {c}\n", .{letter});
    if (false and !isFile(filename)) {
        std.debug.print("a regular file is expected", .{});
        return;
    }
    var file = try std.fs.openFileAbsolute(filename, .{});
    var buffer: [1024]u8 = undefined;
    const read = try file.readAll(&buffer);
    std.debug.print("Read {d} bytes\n", .{read});
    std.debug.print("Contents:\n`{s}`\n", .{buffer[0..read]});
    var letter_count: u32 = 0;
    for (buffer[0..read]) |c| {
        if (c == letter) {
            letter_count += 1;
        }
    }
    std.debug.print("Found {d} occurrences of letter `{c}` in the file\n", .{ letter_count, letter });
}

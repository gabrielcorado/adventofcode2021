const std = @import("std");
const data = @import("data.zig").data;
const solution = @import("solution.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const lines = try data(allocator);
    const part1 = try solution.count_line_overlaps(allocator, lines);
    const part2 = try solution.count_line_overlaps_with_diagonal(allocator, lines);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("PART 1: {}\n", .{part1});
    try stdout.print("PART 2: {}\n", .{part2});
}

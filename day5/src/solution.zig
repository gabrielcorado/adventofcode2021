const std = @import("std");
const common = @import("common.zig");
const Line = common.Line;
const Point = common.Point;
const expect = std.testing.expect;

const Allocator = std.mem.Allocator;
const test_allocator = std.testing.allocator;

const ArrayList = std.ArrayList;
const AutoArrayHashMap = std.AutoArrayHashMap;

// creates a hash representation (u64) of a point given by x and y coordinates.
fn hash_point(x: i32, y: i32) u64 {
    var hasher = std.hash.Wyhash.init(0);
    std.hash.autoHashStrat(&hasher, Point{ .x = x, .y = y }, .Deep);
    return hasher.final();
}

// produces a range based on the start/end. it works with increasing/decreasing ranges.
fn range(allocator: *Allocator, start: i32, end: i32) anyerror!ArrayList(i32) {
    const d = end - start;
    const d_norm = if (d < 0) @as(i32, -1) else if (d > 0) @as(i32, 1) else @as(i32, 0);
    const len = std.math.absCast(d) + 1;
    var i: i32 = 0;
    var n = start;
    var arr = ArrayList(i32).init(allocator);
    while (i < len) : (i += 1) {
        try arr.append(n);
        n += d_norm;
    }
    return arr;
}

// generates the horizontal coordinates of a line.
// 1. generates a range for both x and y axis;
// 2. iterates over the ranges in a nested form, generating the coordinates;
// 3. hash the coordinates using `hash_point` function;
// 3. return the list of hashed coordinates.
fn horizontal_coordinates(allocator: *Allocator, line: Line) anyerror!ArrayList(u64) {
    var result = ArrayList(u64).init(allocator);

    var i_range = try range(allocator, line.start.x, line.end.x);
    defer i_range.deinit();
    var j_range = try range(allocator, line.start.y, line.end.y);
    defer j_range.deinit();

    for (i_range.items) |i| {
        for (j_range.items) |j| {
            try result.append(hash_point(i, j));
        }
    }

    return result;
}

// PART 1
// 1. iterates over all lines:
//   1.1 generates coordinates for horizontal/vertical lines only using `horizontal_coordinates`.
//   1.2 store coordinates at a `ArrayHashMap` using the coordinate hash as key and counter as value;
//       1.2.1 everytime it sees a repeated increase the counter.
// 2. iterate over the `ArrayHashMap` and count the number of coordinates that have more than 2 occurrencies;
pub fn count_line_overlaps(allocator: *Allocator, lines: ArrayList(Line)) anyerror!usize {
    var occurrencies = AutoArrayHashMap(u64, i32).init(allocator);
    defer occurrencies.deinit();

    for (lines.items) |line| {
        // not an horizontal line.
        if (line.start.x != line.end.x and line.start.y != line.end.y) {
            continue;
        }

        var coordinates = try horizontal_coordinates(allocator, line);
        defer coordinates.deinit();

        for (coordinates.items) |coordinate| {
            var curr = occurrencies.get(coordinate) orelse 0;
            try occurrencies.put(coordinate, curr + 1);
        }
    }

    var iter = occurrencies.iterator();
    var count: usize = 0;

    while (iter.next()) |entry| {
        if (entry.value_ptr.* > 1) {
            count += 1;
        }
    }

    return count;
}

// decides if it is a vertical/horizontal or a diagonal line, and then generate
// the coordinates using the proper function.
fn line_coordinates(allocator: *Allocator, line: Line) anyerror!ArrayList(u64) {
    if (line.start.x != line.end.x and line.start.y != line.end.y) {
        return vertical_coordinates(allocator, line);
    }

    return horizontal_coordinates(allocator, line);
}

// generates vertical coordinates.
// 1. calculate the x and y "movements", this is how the coordinates are going to be generated;
// 2. iterate until the x and y are equal to the line.end coordinates;
// 3. add the last coordinate since it is inclusive;
fn vertical_coordinates(allocator: *Allocator, line: Line) anyerror!ArrayList(u64) {
    var result = ArrayList(u64).init(allocator);

    const x_move = if (line.start.x > line.end.x) @as(i32, -1) else @as(i32, 1);
    const y_move = if (line.start.y > line.end.y) @as(i32, -1) else @as(i32, 1);

    var x: i32 = line.start.x;
    var y: i32 = line.start.y;

    while (x != line.end.x and y != line.end.y) {
        try result.append(hash_point(x, y));
        x += x_move;
        y += y_move;
    }

    // add the end point.
    try result.append(hash_point(line.end.x, line.end.y));

    return result;
}

// PART 2
// 1. iterates over all lines:
//   1.1 generates coordinates for horizontal/vertical and diagonal lines.
//   1.2 store coordinates at a `ArrayHashMap` using the coordinate hash as key and counter as value;
//       1.2.1 everytime it sees a repeated increase the counter.
// 2. iterate over the `ArrayHashMap` and count the number of coordinates that have more than 2 occurrencies;
pub fn count_line_overlaps_with_diagonal(allocator: *Allocator, lines: ArrayList(Line)) anyerror!usize {
    var occurrencies = AutoArrayHashMap(u64, i32).init(allocator);
    defer occurrencies.deinit();

    for (lines.items) |line| {
        // not an horizontal line.
        var coordinates: ArrayList(u64) = try line_coordinates(allocator, line);
        defer coordinates.deinit();

        for (coordinates.items) |coordinate| {
            var curr = occurrencies.get(coordinate) orelse 0;
            try occurrencies.put(coordinate, curr + 1);
        }
    }

    var iter = occurrencies.iterator();
    var count: usize = 0;

    while (iter.next()) |entry| {
        if (entry.value_ptr.* > 1) {
            count += 1;
        }
    }

    return count;
}

test "line overlap" {
    var lines = ArrayList(Line).init(test_allocator);
    defer lines.deinit();

    try lines.append(Line { .start = Point { .x = 0, .y = 9 }, .end = Point { .x = 5, .y = 9 } });
    try lines.append(Line { .start = Point { .x = 8, .y = 0 }, .end = Point { .x = 0, .y = 8 } });
    try lines.append(Line { .start = Point { .x = 9, .y = 4 }, .end = Point { .x = 3, .y = 4 } });
    try lines.append(Line { .start = Point { .x = 2, .y = 2 }, .end = Point { .x = 2, .y = 1 } });
    try lines.append(Line { .start = Point { .x = 7, .y = 0 }, .end = Point { .x = 7, .y = 4 } });
    try lines.append(Line { .start = Point { .x = 6, .y = 4 }, .end = Point { .x = 2, .y = 0 } });
    try lines.append(Line { .start = Point { .x = 0, .y = 9 }, .end = Point { .x = 2, .y = 9 } });
    try lines.append(Line { .start = Point { .x = 3, .y = 4 }, .end = Point { .x = 1, .y = 4 } });
    try lines.append(Line { .start = Point { .x = 0, .y = 0 }, .end = Point { .x = 8, .y = 8 } });
    try lines.append(Line { .start = Point { .x = 5, .y = 5 }, .end = Point { .x = 8, .y = 2 } });

    var points_with_overlap = try count_line_overlaps(test_allocator, lines);
    try expect(points_with_overlap == 5);

    var points_with_overlap_diagonal = try count_line_overlaps_with_diagonal(test_allocator, lines);
    try expect(points_with_overlap_diagonal == 12);
}

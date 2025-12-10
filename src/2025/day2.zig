const std = @import("std");
const Allocator = std.mem.Allocator;
const Io = std.Io;

pub fn part1(io: Io, allocator: Allocator, input: []const u8) !?i64 {
    var rangesList = try getRanges(allocator, input);
    defer rangesList.deinit(allocator);
    const ranges = rangesList.items;
    _ = try isInvalid(allocator, 1111);
    _ = try isInvalid(allocator, 11111);
    _ = try isInvalid(allocator, 1113);
    _ = try isInvalid(allocator, 1131);
    for (ranges) |range| {
        std.debug.print("{} - {}\n", .{ range.start, range.end });
    }
    _ = .{ io, allocator, input };
    return null;
}

pub fn part2(io: Io, allocator: Allocator, input: []const u8) !?i64 {
    _ = .{ io, allocator, input };
    return null;
}

const IdRange = struct {
    start: u64,
    end: u64,
};

fn isInvalid(allocator: Allocator, id: u64) !bool {
    const strId = try std.fmt.allocPrint(allocator, "{d}", .{id});
    defer allocator.free(strId);
    if (@mod(strId.len, 2) != 0) return false;
    const halfIndex = strId.len / 2;
    for (0..halfIndex) |i| {
        if (strId[i] != strId[i + halfIndex]) return false;
        std.debug.print("{} = {}\n", .{ strId[i], strId[i + halfIndex] });
    }
    return true;
}

fn getRanges(allocator: Allocator, input: []const u8) !std.ArrayList(IdRange) {
    var rangesIter = std.mem.splitScalar(u8, input, ',');
    var ranges = std.ArrayList(IdRange).empty;
    while (rangesIter.next()) |rangeStr| {
        var valuesIter = std.mem.splitScalar(u8, rangeStr, '-');
        const start = valuesIter.next() orelse return error.InvalidInput;
        const end = valuesIter.next() orelse return error.InvalidInput;

        const newRange = IdRange{
            .start = try std.fmt.parseInt(u64, start, 10),
            .end = try std.fmt.parseInt(u64, end, 10),
        };
        try ranges.append(allocator, newRange);
    }
    return ranges;
}

test "it should do nothing" {
    const io = std.testing.io;
    const allocator = std.testing.allocator;
    const input =
        \\11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    ;

    try std.testing.expectEqual(1227775554, try part1(io, allocator, input));
    try std.testing.expectEqual(null, try part2(io, allocator, input));
}


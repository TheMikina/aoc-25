const std = @import("std");
const fmt = std.fmt;
const Allocator = std.mem.Allocator;
const Io = std.Io;

pub fn part1(io: Io, allocator: Allocator, input: []const u8) !?i64 {
    var movesIter = std.mem.splitScalar(u8, input, '\n');
    var currentPos: i64 = 50;
    var zeroCounter: i64 = 0;
    while (movesIter.next()) |move| {
        if (move.len == 0) {
            break;
        }
        const moveValue = getMoveValue(move);
        const from = currentPos;
        currentPos += moveValue;
        currentPos = @mod(currentPos, 100);
        if (currentPos == 0) {
            zeroCounter += 1;
        }
        std.debug.print("Move {s}, {} {} -> {}\n", .{ move, from, moveValue, currentPos });
    }
    _ = .{ io, allocator, input };
    return zeroCounter;
}

fn getMoveValue(move: []const u8) i64 {
    const dir = move[0];
    const distStr = move[1..];
    var dist = fmt.parseInt(i64, distStr, 10) catch |err| {
        std.debug.print("Error: {}, \'{s}\'\n", .{ err, distStr });
        return 0;
    };
    if (dir == 'L') {
        dist = dist * -1;
    }
    return dist;
}

pub fn part2(io: Io, allocator: Allocator, input: []const u8) !?u64 {
    var movesIter = std.mem.splitScalar(u8, input, '\n');
    var currentPos: i64 = 50;
    var zeroCounter: u64 = 0;
    while (movesIter.next()) |move| {
        if (move.len == 0) {
            break;
        }
        const moveValue = getMoveValue(move);
        const from = currentPos;
        currentPos += moveValue;
        if (moveValue > 0) {
            zeroCounter += @abs(try std.math.divFloor(i64, currentPos, 100));
        } else {
            zeroCounter += @abs(try std.math.divCeil(i64, currentPos, 100));
        }
        currentPos = @mod(currentPos, 100);
        if (currentPos == 0) {
            zeroCounter += 1;
        }
        std.debug.print("Move {s}, {} {} -> {}, zero: {}\n", .{ move, from, moveValue, currentPos, zeroCounter });
    }
    _ = .{ io, allocator, input };
    return zeroCounter;
}

test "it should do nothing" {
    const io = std.testing.io;
    const allocator = std.testing.allocator;
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;

    try std.testing.expectEqual(3, try part1(io, allocator, input));
    try std.testing.expectEqual(6, try part2(io, allocator, input));
}

const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

const main = @import("./main.zig");

test "smoke test" {
  main.main() catch unreachable;
}
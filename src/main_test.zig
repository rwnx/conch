const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

const main = @import("./main.zig");

test "smoke test" {
  // can't run main because it blocks (duh) need to force test to compile main
  // At least until we get some actual units to test. 
  const lib = main.main;
}

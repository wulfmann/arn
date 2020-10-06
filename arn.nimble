version       = "0.1.0"
author        = "Joe Snell"
description   = "Create AWS Console URLs from ARNs"
license       = "MIT"

# Dependencies

requires "unpack"

task tests, "Run tests":
    for t in ["services"]:
        exec("nim c -r -d:ssl tests/t" & t)
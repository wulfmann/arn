version       = "0.1.0"
author        = "Aidan Steele"
description   = "AWS SDK for Nim"
license       = "MIT"

# Dependencies

requires "unpack"

task tests, "Run tests":
    for t in ["services"]:
        exec("nim c -r -d:ssl tests/t" & t)
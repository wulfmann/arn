import base, strutils, unpack

type Logs* = ref object of BaseService

method getHash*(service: Logs, resource, resourceName: string): string =
    var resourceType = resource

    if "log-stream" in resourceName:
        resourceType = "log-stream"

    if resourceType == "log-group":
        result = encodeHash({
            "logsV2": "log-groups/log-group" & resourceName
        }, ":")
    elif resourceType == "log-stream":
        [logGroup, _, logStream] <- resourceName.split(":")
        result = encodeHash({
            "logsV2": "log-groups/log-group" & logGroup & "/log-events/" & logStream
        }, ":")
    else:
        result = ""

method getPath*(service: Logs): string =
    "cloudwatch/home"

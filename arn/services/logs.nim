import base, uri, strutils, unpack

type Logs* = ref object of BaseService

proc getHash(resource, resourceName: string): string =
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

proc getPath*(service: Logs): string =
    "cloudwatch/home"

proc getConsoleUrl*(service: Logs, region="us-east-1"): string =
    var baseUri = service.getBaseUri()
    var path = service.getPath()
    var url = parseUri(baseUri) / path ? { "region": service.arn.region  }
    var hash = getHash(service.arn.resource, service.arn.resourceName)
    result = $url & "#" & hash

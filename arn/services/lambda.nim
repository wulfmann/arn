import base, uri, unpack, strutils

type Lambda* = ref object of BaseService

proc getHash(resource, resourceName: string): string =
    if resource == "function":
        var nestedPath = "/functions/" & resourceName
        var nestedUri = parseUri(nestedPath) ? { "tab": "configuration" }
        result = $nestedUri
    elif resource == "layer":
        [name, version] <- resourceName.split(":")
        var nestedPath = "/layers/" & name & "/versions/" & version
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    else:
        result = ""

proc getConsoleUrl*(service: Lambda, region="us-east-1"): string =
    var baseUri = service.getBaseUri()
    var path = service.getPath()
    var url = parseUri(baseUri) / path ? { "region": service.arn.region  }
    var hash = getHash(service.arn.resource, service.arn.resourceName)
    result = $url & "#" & hash

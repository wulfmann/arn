import base, uri, strutils

type IAM* = ref object of BaseService

proc getHash(resource, resourceName: string): string =
    if resource == "policy":
        var nestedPath = "/policies/arn:aws:iam::aws:policy/" & resourceName & "$jsonEditor"
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    elif resource == "role":
        var nestedPath = "/roles/" & resourceName
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    elif resource == "user":
        var nestedPath = "/users/" & resourceName
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    else:
        result = ""

proc getConsoleUrl*(service: IAM): string =
    var baseUri = service.getBaseUri()
    var path = service.getPath()

    var url = parseUri(baseUri) / path
    if not isNilOrWhitespace(service.arn.region):
        url = url ? { "region": service.arn.region  }

    var hash = getHash(service.arn.resource, service.arn.resourceName)
    result = $url & "#" & hash

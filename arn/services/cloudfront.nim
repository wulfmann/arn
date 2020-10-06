import base, uri, strutils, unpack

type Cloudfront* = ref object of BaseService

proc getHash(resource, resourceName: string): string =
    if resource == "distribution":
        result = encodeHash({
            "distribution-settings": resourceName
        }, ":")
    else:
        result = ""

proc getConsoleUrl*(service: Cloudfront): string =
    var baseUri = service.getBaseUri()
    var path = service.getPath()
    var url = parseUri(baseUri) / path
    if not isNilOrWhitespace(service.arn.region):
        url = url ? { "region": service.arn.region  }
    var hash = getHash(service.arn.resource, service.arn.resourceName)
    result = $url & "#" & hash

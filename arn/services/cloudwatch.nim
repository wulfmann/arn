import base, uri, strutils, unpack

type Cloudwatch* = ref object of BaseService

proc getHash(resource, resourceName: string): string =
    if resource == "alarm":
        result = encodeHash({
            "alarmsV2:alarm": resourceName
        }, "/")
    else:
        result = ""

proc getConsoleUrl*(service: Cloudwatch): string =
    var baseUri = service.getBaseUri()
    var path = service.getPath()
    var url = parseUri(baseUri) / path ? { "region": service.arn.region  }
    var hash = getHash(service.arn.resource, service.arn.resourceName)
    result = $url & "#" & hash

import base, uri, strutils, unpack

type Cloudformation* = ref object of BaseService

proc getHash(arn, resource, resourceName: string): string =
    if resource == "stack":
        var nestedPath = "/stacks/stackinfo"
        var hash = parseUri(nestedPath) ? {
            "filteringText": "",
            "filteringStatus": "active",
            "viewNested": "true",
            "hideStacks": "false",
            "stackId": encodeUrl(arn)
        }
        result = $hash
    elif resource == "type":
        var nestedPath = "/registry/resourceTypes/details"
        var hash = parseUri(nestedPath) ? {
            "arn": encodeUrl(arn)
        }
        result = $hash
    else:
        result = ""

proc getConsoleUrl*(service: Cloudformation): string =
    var baseUri = service.getBaseUri()
    var path = service.getPath()
    var url = parseUri(baseUri) / path ? { "region": service.arn.region  }
    var hash = getHash(service.arn.raw, service.arn.resource, service.arn.resourceName)
    result = $url & "#" & hash

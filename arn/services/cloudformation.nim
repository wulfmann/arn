import base, uri

type Cloudformation* = ref object of BaseService

method getHash*(service: Cloudformation, resource, resourceName: string): string =
    if resource == "stack":
        var nestedPath = "/stacks/stackinfo"
        var hash = parseUri(nestedPath) ? {
            "filteringText": "",
            "filteringStatus": "active",
            "viewNested": "true",
            "hideStacks": "false",
            "stackId": encodeUrl(service.arn.raw)
        }
        result = $hash
    elif resource == "type":
        var nestedPath = "/registry/resourceTypes/details"
        var hash = parseUri(nestedPath) ? {
            "arn": encodeUrl(service.arn.raw)
        }
        result = $hash
    else:
        result = ""

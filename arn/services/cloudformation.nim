import base, uri

type Cloudformation* = ref object of BaseService

method getHash*(service: Cloudformation, arn, resource, resourceName: string): string =
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

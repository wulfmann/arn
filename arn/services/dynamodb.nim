import base, uri

type DynamoDB* = ref object of BaseService

proc getHash(resource, resourceName: string): string =
    if resource == "table":
        result = encodeHash({
            "tables:selected": resourceName,
            "tab": "overview"
        })
    else:
        result = ""

proc getConsoleUrl*(service: DynamoDB): string =
    var baseUri = service.getBaseUri()
    var path = service.getPath()
    var url = parseUri(baseUri) / path ? { "region": service.arn.region }
    var hash = getHash(service.arn.resource, service.arn.resourceName)
    result = $url & "#" & hash

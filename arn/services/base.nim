import ../parser
import uri, strutils

type BaseService* = ref object of RootObj
    arn*: Arn

method getPath*(service: BaseService): string {.base.} =
    service.arn.service & "/home"

method getBaseUri*(service: BaseService): string {.base.} =
    "https://console.aws.amazon.com"

# Helpers
proc encodeHash*(hash: openArray[(string, string)], delimeter="="): string =
    for elem in hash:
        if result.len > 0: result.add(';')
        let (key, val) = elem
        result.add(key)
        result.add(delimeter)
        result.add(val)

method getQueryString*(service: BaseService): seq[(string, string)] =
    if not isEmptyOrWhitespace(service.arn.region):
        result.add(("region", service.arn.region))

method getHash*(service: BaseService, resource, resourceName: string): string {.base.} = ""

method getConsoleUrl*(service: BaseService): string {.base.} =
    var baseUri = service.getBaseUri()
    var path = service.getPath()

    var url = parseUri(baseUri) / path

    var queryString = service.getQueryString()
    url = url ? queryString

    var hash = service.getHash(service.arn.resource, service.arn.resourceName)

    result = $url
    if not isEmptyOrWhitespace(hash):
        result = result & "#" & hash

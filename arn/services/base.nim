import ../parser
import uri, strutils

type BaseService* = ref object of RootObj
    arn*: Arn

method getPath*(service: BaseService): string {.base.} =
    service.arn.service & "/home"

proc getBaseUri*(service: BaseService): string =
    "https://console.aws.amazon.com"

# Helpers
proc encodeHash*(hash: openArray[(string, string)], delimeter="="): string =
    for elem in hash:
        if result.len > 0: result.add(';')
        let (key, val) = elem
        result.add(key)
        result.add(delimeter)
        result.add(val)

method getHash*(service: BaseService, resource, resourceName: string): string {.base.} = ""

method getConsoleUrl*(service: BaseService): string {.base.} =
    var baseUri = service.getBaseUri()
    var path = service.getPath()

    var url = parseUri(baseUri) / path
    if not isEmptyOrWhitespace(service.arn.region):
        url = url ? { "region": service.arn.region  }

    var hash = service.getHash(service.arn.resource, service.arn.resourceName)

    result = $url
    if not isEmptyOrWhitespace(hash):
        result = result & "#" & hash

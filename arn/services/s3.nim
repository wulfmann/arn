import base, strutils, sequtils

type S3* = ref object of BaseService

method getBaseUri*(service: S3): string =
    "https://s3.console.aws.amazon.com"

method getPath*(service: S3): string =
    if not isEmptyOrWhitespace(service.arn.resourceName):
        return "s3/object/" & service.arn.resource & "/" & service.arn.resourceName
    else:
        return "s3/buckets/" & service.arn.resource

method getQueryString*(service: S3): seq[(string, string)] =
    if not isEmptyOrWhitespace(service.arn.region):
        result.add(("region", service.arn.region))
    result.add(("tab", "overview"))

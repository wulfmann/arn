import strutils
import unpack

type Arn* = ref object of RootObj
    raw*: string
    service*: string
    resource*: string
    partition*: string
    region*: string
    account*: string
    resourceName*: string
    sep*: string

type InvalidArn* = object of ValueError

proc parseResource(sixth: string, rest: seq[string]): (string, string, string) =
    var
        resource: string
        resourceName: string
        sep: string
        sepIndex = sixth.find("/")

    if sepIndex != -1:
        sep = "/"
    elif rest.len > 0:
        sep = ":"
        sepIndex = -1

    if sepIndex != -1:
        resource = sixth.substr(0, sepIndex - 1)
        resourceName = sixth.substr(sepIndex + 1)
    else:
        resource = sixth

    if rest.len > 0:
        if isEmptyOrWhitespace(resourceName):
            resourceName = ""
        else:
            resourceName &= ":"
        resourceName &= rest.join(":")

    result = (resource, resourceName, sep)

proc parseArn*(arn: string): Arn =
    let components = arn.split(':')

    if components.len < 6:
        raise InvalidArn.newException("ARNs must have at least 6 components")
    
    # var resource, resourceName: string

    [
        prefix,
        partition,
        service,
        region,
        account,
        sixth,
        *rest
    ] <- components

    if prefix != "arn":
        raise InvalidArn.newException("ARNs must start with 'arn'")

    # if "/" in sixth:
    #     var separated = sixth.split("/")
    #     resource = separated[0]
    #     resourceName = separated[1]
    # elif ":" in sixth:
    #     var separated = sixth.split(":")
    #     resource = separated[0]
    #     resourceName = separated[1]
    # else:
    #     resource = ""
    #     resourceName = sixth
    var (resource, resourceName, sep) = parseResource(sixth, rest)

    result = Arn(
        raw: arn,
        service: service,
        resource: resource,
        partition: partition,
        region: region,
        account: account,
        resourceName: resourceName,
        sep: sep
    )

import base, uri

type IAM* = ref object of BaseService

method getHash*(service: IAM, resource, resourceName: string): string =
    if resource == "policy":
        var nestedPath = "/policies/arn:aws:iam::aws:policy/" & resourceName & "$jsonEditor"
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    elif resource == "role":
        var nestedPath = "/roles/" & resourceName
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    elif resource == "user":
        var nestedPath = "/users/" & resourceName
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    else:
        result = ""

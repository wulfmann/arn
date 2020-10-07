import base, uri, unpack, strutils

type Lambda* = ref object of BaseService

method getHash*(service: Lambda, resource, resourceName: string): string =
    if resource == "function":
        var nestedPath = "/functions/" & resourceName
        var nestedUri = parseUri(nestedPath) ? { "tab": "configuration" }
        result = $nestedUri
    elif resource == "layer":
        [name, version] <- resourceName.split(":")
        var nestedPath = "/layers/" & name & "/versions/" & version
        var nestedUri = parseUri(nestedPath)
        result = $nestedUri
    else:
        result = ""

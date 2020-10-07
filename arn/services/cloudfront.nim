import base

type Cloudfront* = ref object of BaseService

method getHash*(service: Cloudfront, resource, resourceName: string): string =
    if resource == "distribution":
        result = encodeHash({
            "distribution-settings": resourceName
        }, ":")
    else:
        result = ""

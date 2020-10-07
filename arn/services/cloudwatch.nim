import base

type Cloudwatch* = ref object of BaseService

method getHash*(service: Cloudwatch, resource, resourceName: string): string =
    if resource == "alarm":
        result = encodeHash({
            "alarmsV2:alarm": resourceName
        }, "/")
    else:
        result = ""

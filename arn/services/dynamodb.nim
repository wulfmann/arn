import base

type DynamoDB* = ref object of BaseService

method getHash*(service: DynamoDB, resource, resourceName: string): string =
    if resource == "table":
        result = encodeHash({
            "tables:selected": resourceName,
            "tab": "overview"
        })
    else:
        result = ""

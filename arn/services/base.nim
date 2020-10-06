import ../parser
import tables, uri

type BaseService* = ref object of RootObj
    arn*: Arn

proc getQueryString*(service: BaseService, region: string): Table[string, string] =
    {
        "region": region
    }.toTable

proc getPath*(service: BaseService): string =
    service.arn.service & "/home"

proc getBaseUri*(service: BaseService): string =
    "https://console.aws.amazon.com"

# Helpers
proc encodeHash*(hash: openArray[(string, string)], delimeter="="): string =
    runnableExamples:
        assert encodeHash({: }) == ""
        assert encodeHash({"a": "1", "b": "2"}) == "a=1;b=2"
        assert encodeHash({"a": "1", "b": ""}) == "a=1;b"
    for elem in hash:
        if result.len > 0: result.add(';')
        let (key, val) = elem
        result.add(key)
        result.add(delimeter)
        result.add(val)
            

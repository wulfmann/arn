import base

type Default* = ref object of BaseService

proc getConsoleUrl*(service: Default): string =
    result = "default console url"

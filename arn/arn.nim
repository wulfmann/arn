import parser, tables, url

proc parse*(arn: string): string =
  var arn: Arn = parseArn(arn)
  result = getConsoleUrl(arn)

import cligen; dispatchMulti([parse])

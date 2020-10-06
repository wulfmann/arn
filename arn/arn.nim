import parser, tables, url, aws, browsers

proc openArn*(arn: string, profile="default"): void =
  var arn: Arn = parseArn(arn)
  var arnUrl = getConsoleUrl(arn)
  var session = getSession(profile)
  var consoleUrl = session.createConsoleUrl(arnUrl)
  openDefaultBrowser(consoleUrl)

proc parse*(arn: string): string =
  var arn: Arn = parseArn(arn)
  result = getConsoleUrl(arn)

when isMainModule:
  import cligen
  dispatchMulti([parse], [openArn])

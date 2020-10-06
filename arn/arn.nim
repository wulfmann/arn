import parser, tables, url, aws, browsers

proc openArn*(arn: string, profile="default", open=true): string =
  var arn: Arn = parseArn(arn)
  var arnUrl = getConsoleUrl(arn)
  var session = getSession(profile)
  result = session.createConsoleUrl(arnUrl)

  if open:
    openDefaultBrowser(result)

proc parse*(arn: string): string =
  var arn: Arn = parseArn(arn)
  result = getConsoleUrl(arn)

when isMainModule:
  import cligen
  dispatchMulti([parse], [openArn])

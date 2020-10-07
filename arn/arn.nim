import parser, tables, url, aws, browsers

proc run*(profile="default", open=true, args: seq[string]): string =
  if args.len > 1:
    raise ValueError.newException("only one arn is allowed to be specified")

  var
    rawArn = args[0]
    arn: Arn

  try:
    arn = parseArn(rawArn)
  except InvalidArn:
    echo getCurrentExceptionMsg()
    quit(1)

  var arnUrl = getConsoleUrl(arn)

  if open:
    var
      session = getSession(profile)
      authenticatedUrl = session.createConsoleUrl(arnUrl)
    openDefaultBrowser(authenticatedUrl)
    return authenticatedUrl
  else:
    return arnUrl

when isMainModule:
  import cligen
  dispatch(run)

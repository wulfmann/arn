import os, parsecfg, httpclient, uri, json

type Session = object
    accessKeyId: string
    secretAccessKey: string
    sessionToken: string

proc getSessionFromEnvironment(): (string, string, string) =
    var
        accessKeyId = getEnv("AWS_ACCESS_KEY_ID")
        secretAccessKey = getEnv("AWS_SECRET_ACCESS_KEY")
        sessionToken = getEnv("AWS_SESSION_TOKEN")

    return (accessKeyId, secretAccessKey, sessionToken)

proc getSessionFromCredentialsFile(profile: string): (string, string, string) =
    var configPath = getHomeDir() & ".aws/credentials"
    var credentials = loadConfig(configPath)

    var accessKeyId = credentials.getSectionValue(profile, "aws_access_key_id")
    var secretAccessKey = credentials.getSectionValue(profile, "aws_secret_access_key")
    var sessionToken = credentials.getSectionValue(profile, "aws_session_token")
    
    return (accessKeyId, secretAccessKey, sessionToken)

proc getSession*(profile: string): Session =
    var (accessKeyId, secretAccessKey, sessionToken) = getSessionFromEnvironment()

    if (accessKeyId == "" or secretAccessKey == ""):
        (accessKeyId, secretAccessKey, sessionToken) = getSessionFromCredentialsFile(profile)

    result = Session(
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        sessionToken: sessionToken
    )

proc createSigninToken*(session: Session): string =
    if session.sessionToken == "":
        raise ValueError.newException("open url does not work without a session token")
    
    var url = parseUri("https://signin.aws.amazon.com/federation") ? {
        "Action": "getSigninToken",
        "Session": $(%*{
            "sessionId": session.accessKeyId,
            "sessionKey": session.secretAccessKey,
            "sessionToken": session.sessionToken
        })
    }

    var client = newHttpClient()
    var response = client.getContent($url)
    result = parseJson(response)["SigninToken"].getStr()

proc createConsoleUrl*(session: Session, destination="https://console.aws.amazon.com/"): string =
    var
        signinToken = session.createSigninToken()
        base = parseUri("https://signin.aws.amazon.com/federation")

    var url = base ? {
        "Action": "login",
        "Issuer": "",
        "Destination": destination,
        "SigninToken": signinToken
    }

    result = $url
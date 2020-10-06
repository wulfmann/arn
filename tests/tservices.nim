import asyncdispatch, macros, strutils
import ../arn/parser

macro mkImport(name: static[string]): untyped =
    result = newNimNode(nnkImportStmt).add(newIdentNode(name))

var numFailures = 0
var allFutures = newSeq[Future[void]]()

template genTest(serviceName: untyped, procName: untyped, checks: seq[(string, string)]) =
    const name = astToStr(serviceName)
    const modName = "../arn/services/" & name.toLowerAscii()
    mkImport modName

    block:
        proc runTest() {.async.} =
            for check in checks:
                let (rawArn, expected) = check
                var arn = parseArn(rawArn)

                echo "Running tests for ", name , " ", rawArn
                let service = serviceName(arn: arn)
                let j = service.procName()
                # echo j
                # echo expected
                assert j == expected

        allFutures.add(runTest())

genTest(DynamoDB, getConsoleUrl, @[
    ("arn:aws:dynamodb:us-east-1:123456789123:table/test", "https://console.aws.amazon.com/dynamodb/home?region=us-east-1#tables:selected=test;tab=overview")
])

genTest(Lambda, getConsoleUrl, @[
    ("arn:aws:lambda:us-east-1:123456789123:function:test-function", "https://console.aws.amazon.com/lambda/home?region=us-east-1#/functions/test-function?tab=configuration"),
    ("arn:aws:lambda:us-east-1:123456789123:layer:test:1", "https://console.aws.amazon.com/lambda/home?region=us-east-1#/layers/test/versions/1")
])

genTest(Logs, getConsoleUrl, @[
    ("arn:aws:logs:us-east-1:123456789123:log-group:/test/log-group", "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logsV2:log-groups/log-group/test/log-group"),
    ("arn:aws:logs:us-east-1:123456789123:log-group:/test/log-group:log-stream:test-log-stream", "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logsV2:log-groups/log-group/test/log-group/log-events/test-log-stream")
])

genTest(IAM, getConsoleUrl, @[
    ("arn:aws:iam::aws:policy/test", "https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/test$jsonEditor"),
    ("arn:aws:iam::123456789123:role/test", "https://console.aws.amazon.com/iam/home#/roles/test"),
    ("arn:aws:iam::123456789123:user/test", "https://console.aws.amazon.com/iam/home#/users/test")
])

genTest(Cloudformation, getConsoleUrl, @[
    ("arn:aws:cloudformation:us-east-1:123456789123:stack/test/test-id", "https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/stackinfo?filteringText&filteringStatus=active&viewNested=true&hideStacks=false&stackId=arn%253Aaws%253Acloudformation%253Aus-east-1%253A123456789123%253Astack%252Ftest%252Ftest-id"),
    ("arn:aws:cloudformation:us-east-1::type/resource/AWS-ACMPCA-Certificate", "https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/registry/resourceTypes/details?arn=arn%253Aaws%253Acloudformation%253Aus-east-1%253A%253Atype%252Fresource%252FAWS-ACMPCA-Certificate")
])

genTest(Cloudfront, getConsoleUrl, @[
    ("arn:aws:cloudfront::123456789123:distribution/ABCDE12345ZXY", "https://console.aws.amazon.com/cloudfront/home#distribution-settings:ABCDE12345ZXY")
])

genTest(Cloudwatch, getConsoleUrl, @[
    ("arn:aws:cloudwatch:us-east-1:080615554596:alarm:test", "https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#alarmsV2:alarm/test")
])

waitFor all(allFutures)
assert(numFailures == 0)
import parser

# Services
import "services/base"
import "services/cloudformation"
import "services/cloudfront"
import "services/cloudwatch"
import "services/default"
import "services/dynamodb"
import "services/iam"
import "services/lambda"
import "services/logs"
import "services/s3"

proc getConsoleUrl*(arn: Arn): string =
    case arn.service:
    of "cloudformation": Cloudformation(arn: arn).getConsoleUrl()
    of "cloudfront": Cloudfront(arn: arn).getConsoleUrl()
    of "cloudwatch": Cloudwatch(arn: arn).getConsoleUrl()
    of "dynamodb": DynamoDB(arn: arn).getConsoleUrl()
    of "iam": IAM(arn: arn).getConsoleUrl()
    of "lambda": Lambda(arn: arn).getConsoleUrl()
    of "logs": Logs(arn: arn).getConsoleUrl()
    of "s3": S3(arn: arn).getConsoleUrl()
    else: Default(arn: arn).getConsoleUrl()

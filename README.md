# arn

Create an AWS Console URL from an ARN.

## Quickstart

Install the cli with the easy installer

```bash

```

After the install is complete you can run it:

```bash

```

For more installation options see the [install section](#install).

For usage and options, see the [usage section](#usage).

## Install

### Easy Install

```bash

```

### Manual Install

```bash

```

### Build from Source

```bash

```

## Usage

```bash
$ arn arn:aws:iam::aws:policy/test
https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/test$jsonEditor
```

### Options

|Name|Required|Default|Description|
|----|--------|-------|-----------|
|`--profile`|false||The AWS profile to use|

## Supported Services

|Name|Resources|Completion|
|----|---------|----------|
|Cloudformation|Stack, ResourceType||
|Cloudfront|Distribution||
|Cloudwatch|Alarm||
|DynamoDB|Table||
|IAM|Policy, Role, User||
|Lambda|Function, Layer||
|Logs|Log Group, Log Stream||

## Credential Resolution

Your AWS session uses the following path to resolve credentials:

- If the following environment variables are found they are used
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
- If an AWS profile name is passed to the command it is used

## Region Resolution

The region for a URL uses the following path to resolve the region:

- If the ARN contains a region it is used
- If the region is passed into the command it is used
- If an `AWS_REGION` environment variable is found it is used
- If a region is set for the specified AWS profile it is used


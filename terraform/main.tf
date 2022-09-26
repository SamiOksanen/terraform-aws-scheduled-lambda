terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "iam_policy_lambda_basic" {
  name       = "iam_policy_lambda_basic"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "js_cron" {
  filename         = "../dist/function.zip"
  function_name    = "js_cron"
  description      = "Simple TypeScript Lambda function for testing"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
  source_code_hash = filebase64sha256("../dist/function.zip")

  environment {
    variables = {
      TEST_ENV_VARIABLE_ONE = var.TEST_ENV_VARIABLE_ONE,
      TEST_ENV_VARIABLE_TWO = var.TEST_ENV_VARIABLE_TWO,
    }
  }
}

resource "aws_cloudwatch_event_rule" "every_hour" {
  name                = "every-hour"
  description         = "Fires at minute 0 of every hour."
  schedule_expression = "cron(0 * ? * * *)"
}

resource "aws_cloudwatch_event_target" "js_cron_every_hour" {
  rule      = aws_cloudwatch_event_rule.every_hour.name
  target_id = "js_cron"
  arn       = aws_lambda_function.js_cron.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_js_cron" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.js_cron.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour.arn
}

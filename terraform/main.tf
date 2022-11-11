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

module "aws_iam_lambda_basic_role" {
  source = "../terraform_modules/aws_iam_lambda_basic_role"
}

resource "aws_lambda_function" "js_cron" {
  function_name    = "js_cron"
  role             = module.aws_iam_lambda_basic_role.role
  description      = "Simple TypeScript Lambda function for testing"
  filename         = "../lambda/dist/function.zip"
  handler          = "index.handler"
  memory_size      = 128
  runtime          = "nodejs16.x"
  source_code_hash = filebase64sha256("../lambda/dist/function.zip")
  timeout          = 10

  environment {
    variables = {
      TEST_ENV_VARIABLE_ONE = var.TEST_ENV_VARIABLE_ONE,
      TEST_ENV_VARIABLE_TWO = var.TEST_ENV_VARIABLE_TWO,
    }
  }
}

module "aws_scheduled_lambda" {
  source = "../terraform_modules/aws_scheduled_lambda"
  schedule = "cron(0 * ? * * *)"
  lambda_arn = aws_lambda_function.js_cron.arn
  function_name = aws_lambda_function.js_cron.function_name
  target_id = "js_cron"
}

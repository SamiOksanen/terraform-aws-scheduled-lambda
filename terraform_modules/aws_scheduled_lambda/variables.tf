variable "schedule" {
  description = "schedule expression to use"
  nullable    = false
}

variable "lambda_arn" {
  description = "arn of the lambda function"
  nullable    = false
}

variable "function_name" {
  description = "function name of the lambda function"
  nullable    = false
}

variable "target_id" {
  description = "lambda function target id"
  nullable    = false
}

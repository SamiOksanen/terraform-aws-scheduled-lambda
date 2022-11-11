resource "aws_cloudwatch_event_rule" "every_hour" {
  name                = "every-hour"
  description         = "Fires at minute 0 of every hour."
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "js_cron_every_hour" {
  rule      = aws_cloudwatch_event_rule.every_hour.name
  target_id = var.target_id
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_js_cron" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_hour.arn
}

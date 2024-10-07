resource "aws_lambda_function" "asg_refresh" {
  function_name = "asgRefresh"
  role          = aws_iam_role.lambda_role.arn
  handler       = "refresh_asg.handler" 
  runtime       = "python3.8"    

  # Assuming you have the zip file in the same directory
  filename      = "refresh_asg.zip"

  source_code_hash = filebase64("refresh_asg.zip")

  environment {
    variables = {
    AUTOSCALING_GROUP_NAME = aws_autoscaling_group.app_asg.name
  }
}
}

resource "aws_cloudwatch_event_rule" "daily_refresh" {
  name        = "DailyRefreshRule"
  description = "Daily refresh for ASG at UTC 12am"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "daily_refresh_target" {
  rule      = aws_cloudwatch_event_rule.daily_refresh.name
  target_id = "asgRefresh"
  arn       = aws_lambda_function.asg_refresh.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg_refresh.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_refresh.arn
}


resource "aws_sns_topic" "scaling_alerts" {
  name = "scaling_alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.scaling_alerts.arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  vpc_zone_identifier = [var.subnet_id]

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "ScaleOutAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "LoadAveragePercentage"
  namespace           = "CustomMetrics"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"
  alarm_actions       = [aws_autoscaling_policy.scale_out_policy.arn]
  dimensions = {
    AutoScalingGroup = "terraform-asg"
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "ScaleInAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "LoadAveragePercentage"
  namespace           = "CustomMetrics"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"
  alarm_actions       = [aws_autoscaling_policy.scale_in_policy.arn]
  dimensions = {
    AutoScalingGroup = "terraform-asg"
  }
}

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "ScaleOutPolicy"
  scaling_adjustment      = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "ScaleInPolicy"
  scaling_adjustment      = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

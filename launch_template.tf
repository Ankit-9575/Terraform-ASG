resource "aws_launch_template" "app" {
  name_prefix   = "app-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = "Cloudwatch-metric"
  }
  user_data = filebase64("user_data.sh")
}

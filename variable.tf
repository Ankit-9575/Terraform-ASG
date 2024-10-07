variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-west-1"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  default     = 5
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  default     = 2
}

variable "subnet_id" {
  description = "The subnet ID for the Auto Scaling Group"
}

variable "email" {
  description = "Email address for SNS notifications"
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  default     = "my-autoscaling-group"
}


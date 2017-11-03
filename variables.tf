variable "ssh_key_pair" {}

variable "github_api_token" {}

variable "github_organization" {}

variable "github_team" {}

variable "associate_public_ip_address" {
  default = true
}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {}

variable "security_groups" {
  type    = "list"
  default = []
}

variable "subnets" {
  type = "list"
}

variable "namespace" {}

variable "stage" {}

variable "name" {}

variable "delimiter" {
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "ec2_ami" {
  default = "ami-cd0f5cb6"
}

variable "user_data" {
  type    = "list"
  default = []
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "welcome_message" {
  default = ""
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. Possible values are: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "metric_name" {
  description = "The name for the alarm's associated metric. Possible values you can find in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html ."
  default     = "StatusCheckFailed_Instance"
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "5"
}

variable "metric_namespace" {
  description = "The namespace for the alarm's associated metric. Possible values you can find in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html ."
  default     = "AWS/EC2"
}

variable "applying_period" {
  description = "The period in seconds over which the specified statistic is applied."
  default     = "60"
}

variable "statistic_level" {
  description = "The statistic to apply to the alarm's associated metric. Possible values are: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Maximum"
}

variable "metric_threshold" {
  description = "The value against which the specified statistic is compared."
  default     = "1"
}

variable "default_alarm_action" {
  default = "action/actions/AWS_EC2.InstanceId.Reboot/1.0"
}

variable "create_default_security_group" {
  description = "Create default Security Group with Egress traffic allowed only"
  default     = "true"
}

variable "instance_enabled" {
  description = "Flag for creating an instance. Set to false if it is necessary to skip instance creation"
  default     = "true"
}

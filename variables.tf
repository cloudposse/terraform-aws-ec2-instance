variable "ssh_key_pair" {
  description = "SSH key pair to be provisioned on the instance"
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the instance"
  default     = "true"
}

variable "assign_eip_address" {
  description = "Assign an Elastic IP address to the instance"
  default     = "true"
}

variable "user_data" {
  description = "Instance user data. Do not pass gzip-compressed data via this argument"
  default     = ""
}

variable "instance_type" {
  description = "The type of the instance"
  default     = "t2.micro"
}

variable "vpc_id" {
  description = "The ID of the VPC that the instance security group belongs to"
}

variable "security_groups" {
  description = "List of Security Group IDs allowed to connect to the instance"
  type        = "list"
  default     = []
}

variable "allowed_ports" {
  type        = "list"
  description = "List of allowed ingress ports"
  default     = []
}

variable "subnet" {
  description = "VPC Subnet ID the instance is launched in"
}

variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`"
}

variable "name" {
  description = "Name  (e.g. `bastion` or `db`)"
}

variable "delimiter" {
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  description = "Additional attributes (e.g. `1`)"
  type        = "list"
  default     = []
}

variable "tags" {
  description = "Additional tags"
  type        = "map"
  default     = {}
}

variable "region" {
  description = "AWS Region the instance is launched in"
  default     = ""
}

variable "availability_zone" {
  description = "Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region"
  default     = ""
}

variable "ami" {
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04"
  default     = ""
}

variable "ebs_optimized" {
  description = "Launched EC2 instance will be EBS-optimized"
  default     = "false"
}

variable "disable_api_termination" {
  description = "Enable EC2 Instance Termination Protection"
  default     = "false"
}

variable "monitoring" {
  description = "Launched EC2 instance will have detailed monitoring enabled"
  default     = "true"
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in the VPC"
  default     = ""
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs"
  default     = "true"
}

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet"
  default     = "0"
}

variable "ipv6_addresses" {
  type        = "list"
  description = "List of IPv6 addresses from the range of the subnet to associate with the primary network interface"
  default     = []
}

variable "root_volume_type" {
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "root_volume_size" {
  description = "Size of the root volume in gigabytes"
  default     = "10"
}

variable "root_iops" {
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1`"
  default     = "0"
}

variable "ebs_device_name" {
  type        = "list"
  description = "Name of the EBS device to mount"
  default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
}

variable "ebs_volume_type" {
  description = "The type of EBS volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in gigabytes"
  default     = "10"
}

variable "ebs_iops" {
  description = "Amount of provisioned IOPS. This must be set with a volume_type of io1"
  default     = "0"
}

variable "ebs_volume_count" {
  description = "Count of EBS volumes that will be attached to the instance"
  default     = "0"
}

variable "delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination"
  default     = "true"
}

variable "welcome_message" {
  default = ""
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. Possible values are: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "metric_name" {
  description = "The name for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html"
  default     = "StatusCheckFailed_Instance"
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  default     = "5"
}

variable "metric_namespace" {
  description = "The namespace for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html"
  default     = "AWS/EC2"
}

variable "applying_period" {
  description = "The period in seconds over which the specified statistic is applied"
  default     = "60"
}

variable "statistic_level" {
  description = "The statistic to apply to the alarm's associated metric. Allowed values are: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Maximum"
}

variable "metric_threshold" {
  description = "The value against which the specified statistic is compared"
  default     = "1"
}

variable "default_alarm_action" {
  default = "action/actions/AWS_EC2.InstanceId.Reboot/1.0"
}

variable "create_default_security_group" {
  description = "Create default Security Group with only Egress traffic allowed"
  default     = "true"
}

variable "instance_enabled" {
  description = "Flag to control the instance creation. Set to false if it is necessary to skip instance creation"
  default     = "true"
}

variable "additional_ips_count" {
  description = "Count of additional EIPs"
  default     = "0"
}

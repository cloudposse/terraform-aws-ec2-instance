variable "ssh_key_pair" {
  type        = string
  description = "SSH key pair to be provisioned on the instance"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = true
}

variable "assign_eip_address" {
  type        = bool
  description = "Assign an Elastic IP address to the instance"
  default     = true
}

variable "user_data" {
  type        = string
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; use `user_data_base64` instead"
  default     = null
}

variable "user_data_base64" {
  type        = string
  description = "Can be used instead of `user_data` to pass base64-encoded binary data directly. Use this instead of `user_data` whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
  default     = "t2.micro"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC that the instance security group belongs to"
}

variable "security_groups" {
  description = "List of Security Group IDs allowed to connect to the instance"
  type        = list(string)
  default     = []
}

variable "allowed_ports" {
  type        = list(number)
  description = "List of allowed ingress TCP ports"
  default     = []
}

variable "allowed_ports_udp" {
  type        = list(number)
  description = "List of allowed ingress UDP ports"
  default     = []
}

variable "subnet" {
  type        = string
  description = "VPC Subnet ID the instance is launched in"
}

variable "region" {
  type        = string
  description = "AWS Region the instance is launched in"
  default     = ""
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region"
  default     = ""
}

variable "ami" {
  type        = string
  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04"
  default     = ""
}

variable "ami_owner" {
  type        = string
  description = "Owner of the given AMI (ignored if `ami` unset)"
  default     = ""
}

variable "ebs_optimized" {
  type        = bool
  description = "Launched EC2 instance will be EBS-optimized"
  default     = false
}

variable "disable_api_termination" {
  type        = bool
  description = "Enable EC2 Instance Termination Protection"
  default     = false
}

variable "monitoring" {
  type        = bool
  description = "Launched EC2 instance will have detailed monitoring enabled"
  default     = true
}

variable "private_ip" {
  type        = string
  description = "Private IP address to associate with the instance in the VPC"
  default     = ""
}

variable "source_dest_check" {
  type        = bool
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs"
  default     = true
}

variable "ipv6_address_count" {
  type        = number
  description = "Number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet (-1 to use subnet default)"
  default     = 0
}

variable "ipv6_addresses" {
  type        = list(string)
  description = "List of IPv6 addresses from the range of the subnet to associate with the primary network interface"
  default     = []
}

variable "root_volume_type" {
  type        = string
  description = "Type of root volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 10
}

variable "root_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1`"
  default     = 0
}

variable "ebs_device_name" {
  type        = list(string)
  description = "Name of the EBS device to mount"
  default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
}

variable "ebs_volume_type" {
  type        = string
  description = "The type of EBS volume. Can be standard, gp2 or io1"
  default     = "gp2"
}

variable "ebs_volume_size" {
  type        = number
  description = "Size of the EBS volume in gigabytes"
  default     = 10
}

variable "ebs_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set with a volume_type of io1"
  default     = 0
}

variable "ebs_volume_count" {
  type        = number
  description = "Count of EBS volumes that will be attached to the instance"
  default     = 0
}

variable "delete_on_termination" {
  type        = bool
  description = "Whether the volume should be destroyed on instance termination"
  default     = true
}

variable "welcome_message" {
  type        = string
  default     = ""
  description = "Welcome message"
}

variable "comparison_operator" {
  type        = string
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. Possible values are: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  default     = "GreaterThanOrEqualToThreshold"
}

variable "metric_name" {
  type        = string
  description = "The name for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html"
  default     = "StatusCheckFailed_Instance"
}

variable "evaluation_periods" {
  type        = number
  description = "The number of periods over which data is compared to the specified threshold."
  default     = 5
}

variable "metric_namespace" {
  type        = string
  description = "The namespace for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html"
  default     = "AWS/EC2"
}

variable "applying_period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied"
  default     = 60
}

variable "statistic_level" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric. Allowed values are: SampleCount, Average, Sum, Minimum, Maximum"
  default     = "Maximum"
}

variable "metric_threshold" {
  type        = number
  description = "The value against which the specified statistic is compared"
  default     = 1
}

variable "default_alarm_action" {
  type        = string
  default     = "action/actions/AWS_EC2.InstanceId.Reboot/1.0"
  description = "Default alarm action"
}

variable "create_default_security_group" {
  type        = bool
  description = "Create default Security Group with only Egress traffic allowed"
  default     = true
}

variable "additional_ips_count" {
  type        = number
  description = "Count of additional EIPs"
  default     = 0
}

variable "permissions_boundary_arn" {
  type        = string
  description = "Policy ARN to attach to instance role as a permissions boundary"
  default     = ""
}

variable "instance_profile" {
  type        = string
  description = "A pre-defined profile to attach to the instance (default is to build our own)"
  default     = ""
}

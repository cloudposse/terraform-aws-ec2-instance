variable "ssh_key_pair" {
  type        = string
  description = "SSH key pair to be provisioned on the instance"
  default     = null
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
  default     = false
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

variable "burstable_mode" {
  type        = string
  description = "Enable burstable mode for the instance. Can be standard or unlimited. Applicable only for T2/T3/T4g instance types."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC that the instance security group belongs to"
}

variable "security_group_enabled" {
  type        = bool
  description = "Whether to create default Security Group for EC2."
  default     = true
}

variable "security_groups" {
  description = "A list of Security Group IDs to associate with EC2 instance."
  type        = list(string)
  default     = []
}

variable "security_group_description" {
  type        = string
  default     = "EC2 Security Group"
  description = "The Security Group description."
}

variable "security_group_use_name_prefix" {
  type        = bool
  default     = false
  description = "Whether to create a default Security Group with unique name beginning with the normalized prefix."
}

variable "security_group_rules" {
  type = list(any)
  default = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
  description = <<-EOT
    A list of maps of Security Group rules.
    The values of map is fully complated with `aws_security_group_rule` resource.
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule .
  EOT
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
  description = "Owner of the given AMI (ignored if `ami` unset, required if set)"
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
  default     = null
}

variable "secondary_private_ips" {
  type        = list(string)
  description = "List of secondary private IP addresses to associate with the instance in the VPC"
  default     = []
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
  description = "Type of root volume. Can be standard, gp2, gp3, io1 or io2"
  default     = "gp2"
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root volume in gigabytes"
  default     = 10
}

variable "root_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set if root_volume_type is set of `io1`, `io2` or `gp3`"
  default     = 0
}

variable "root_throughput" {
  type        = number
  description = "Amount of throughput. This must be set if root_volume_type is set to `gp3`"
  default     = 0
}

variable "ebs_device_name" {
  type        = list(string)
  description = "Name of the EBS device to mount"
  default     = ["/dev/xvdb", "/dev/xvdc", "/dev/xvdd", "/dev/xvde", "/dev/xvdf", "/dev/xvdg", "/dev/xvdh", "/dev/xvdi", "/dev/xvdj", "/dev/xvdk", "/dev/xvdl", "/dev/xvdm", "/dev/xvdn", "/dev/xvdo", "/dev/xvdp", "/dev/xvdq", "/dev/xvdr", "/dev/xvds", "/dev/xvdt", "/dev/xvdu", "/dev/xvdv", "/dev/xvdw", "/dev/xvdx", "/dev/xvdy", "/dev/xvdz"]
}

variable "ebs_volume_type" {
  type        = string
  description = "The type of the additional EBS volumes. Can be standard, gp2, gp3, io1 or io2"
  default     = "gp2"
}

variable "ebs_volume_size" {
  type        = number
  description = "Size of the additional EBS volumes in gigabytes"
  default     = 10
}

variable "ebs_volume_encrypted" {
  type        = bool
  description = "Whether to encrypt the additional EBS volumes"
  default     = true
}

variable "ebs_iops" {
  type        = number
  description = "Amount of provisioned IOPS. This must be set with a volume_type of `io1`, `io2` or `gp3`"
  default     = 0
}

variable "ebs_throughput" {
  type        = number
  description = "Amount of throughput. This must be set if volume_type is set to `gp3`"
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

variable "instance_initiated_shutdown_behavior" {
  type        = string
  description = "Specifies whether an instance stops or terminates when you initiate shutdown from the instance. Can be one of 'stop' or 'terminate'."
  default     = null
}

variable "root_block_device_encrypted" {
  type        = bool
  default     = true
  description = "Whether to encrypt the root block device"
}

variable "root_block_device_kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID used to encrypt EBS volume. When specifying root_block_device_kms_key_id, root_block_device_encrypted needs to be set to true"
}

variable "metadata_http_tokens_required" {
  type        = bool
  default     = true
  description = "Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2."
}

variable "metadata_http_endpoint_enabled" {
  type        = bool
  default     = true
  description = "Whether the metadata service is available"
}

variable "metadata_tags_enabled" {
  type        = bool
  default     = false
  description = "Whether the tags are enabled in the metadata service."
}

variable "metadata_http_put_response_hop_limit" {
  type        = number
  default     = 2
  description = "The desired HTTP PUT response hop limit (between 1 and 64) for instance metadata requests."
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID used to encrypt EBS volume. When specifying kms_key_id, ebs_volume_encrypted needs to be set to true"
}

variable "volume_tags_enabled" {
  type        = bool
  default     = true
  description = "Whether or not to copy instance tags to root and EBS volumes"
}

variable "ssm_patch_manager_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable SSM Patch manager"
}

variable "ssm_patch_manager_iam_policy_arn" {
  type        = string
  default     = null
  description = "IAM policy ARN to allow Patch Manager to manage the instance. If not provided, `arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore` will be used"
}

variable "ssm_patch_manager_s3_log_bucket" {
  type        = string
  default     = null
  description = "The name of the s3 bucket to export the patch log to"
}

variable "tenancy" {
  type        = string
  default     = "default"
  description = "Tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of 'dedicated' runs on single-tenant hardware. The 'host' tenancy is not supported for the import-instance command. Valid values are 'default', 'dedicated', and 'host'."
  validation {
    condition     = contains(["default", "dedicated", "host"], lower(var.tenancy))
    error_message = "Tenancy field can only be one of default, dedicated, host."
  }
}

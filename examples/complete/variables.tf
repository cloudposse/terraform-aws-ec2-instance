variable "region" {
  type        = string
  description = "AWS region"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address with the instance"
}

variable "assign_eip_address" {
  type        = bool
  description = "Assign an Elastic IP address to the instance"
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key directory (e.g. `/secrets`)"
}

variable "security_group_rules" {
  type        = list(any)
  description = <<-EOT
    A list of maps of Security Group rules. 
    The values of map is fully complated with `aws_security_group_rule` resource. 
    To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule .
  EOT
}

variable "tenancy" {
  type        = string
  default     = "default"
  description = "Tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of 'dedicated' runs on single-tenant hardware. The 'host' tenancy is not supported for the import-instance command. Valid values are 'default', 'dedicated', and 'host'."
  validation {
    condition     = contains(["default", "dedicated", "host"], lower(var.tenancy))
    error_message = "Tenancy field can only be one of default, dedicated, host"
  }
}

variable "metric_treat_missing_data" {
  type        = string
  description = "Sets how this alarm is to handle missing data points. The following values are supported: `missing`, `ignore`, `breaching` and `notBreaching`. Defaults to `missing`."
  default     = "missing"
  validation {
    condition     = contains(["missing", "ignore", "breaching", "notBreaching"], var.metric_treat_missing_data)
    error_message = "The value of metric_treat_missing_data must be one of the following: \"missing\", \"ignore\", \"breaching\", and \"notBreaching\"."
  }
}

variable "instance_market_options" {
  type = object({
    market_type = string
    spot_options = optional(object({
      instance_interruption_behavior = optional(string)
      max_price                      = optional(number)
      spot_instance_type             = optional(string)
      valid_until                    = optional(string)
    }))
  })
  description = <<-EOT
    Describes the market (purchasing) option for the instances.
    See [docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#spot-options) for more information.
  EOT
  default     = null
  validation {
    condition     = contains(["spot", "capacity-block"], var.instance_market_options.market_type)
    error_message = "The value of market_type must be one of the following: \"spot\" and \"capacity-block\"."
  }
}

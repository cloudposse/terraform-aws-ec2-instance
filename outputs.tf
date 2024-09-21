output "public_ip" {
  description = "Public IP of instance (or EIP)"
  value       = concat(aws_eip.default[*].public_ip, aws_instance.default[*].public_ip, [""])[0]
}

output "private_ip" {
  description = "Private IP of instance"
  value       = one(aws_instance.default[*].private_ip)
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = one(aws_instance.default[*].private_dns)
}

output "public_dns" {
  description = "Public DNS of instance (or DNS of EIP)"
  value       = local.public_dns
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = one(aws_instance.default[*].id)
}

output "arn" {
  description = "ARN of the instance"
  value       = one(aws_instance.default[*].arn)
}

output "name" {
  description = "Instance name"
  value       = module.this.id
}

output "ssh_key_pair" {
  description = "Name of the SSH key pair provisioned on the instance"
  value       = var.ssh_key_pair
}

output "security_group_ids" {
  description = "IDs on the AWS Security Groups associated with the instance"
  value = compact(
    concat(
      formatlist("%s", module.security_group.id),
      var.security_groups
    )
  )
}

output "role" {
  description = "Name of AWS IAM Role associated with the instance"
  value       = local.instance_profile_count > 0 ? one(aws_iam_role.default[*].name) : (var.instance_profile_enabled ? one(data.aws_iam_instance_profile.given[*].role_name) : one([""]))
}

output "role_arn" {
  description = "ARN of AWS IAM Role associated with the instance"
  value       = local.instance_profile_count > 0 ? one(aws_iam_role.default[*].arn) : (var.instance_profile_enabled ? one(data.aws_iam_instance_profile.given[*].role_arn) : one([""]))
}

output "alarm" {
  description = "CloudWatch Alarm ID"
  value       = one(aws_cloudwatch_metric_alarm.default[*].id)
}

output "additional_eni_ids" {
  description = "Map of ENI to EIP"
  value = zipmap(
    aws_network_interface.additional[*].id,
    aws_eip.additional[*].public_ip
  )
}

output "ebs_ids" {
  description = "IDs of EBSs"
  value       = aws_ebs_volume.default[*].id
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface"
  value       = one(aws_instance.default[*].primary_network_interface_id)
}

output "instance_profile" {
  description = "Name of the instance's profile (either built or supplied)"
  value       = local.instance_profile
}

output "security_group_id" {
  value       = module.security_group.id
  description = "EC2 instance Security Group ID"
}

output "security_group_arn" {
  value       = module.security_group.arn
  description = "EC2 instance Security Group ARN"
}

output "security_group_name" {
  value       = module.security_group.name
  description = "EC2 instance Security Group name"
}

output "instance_lifecycle" {
  value       = length(var.spot_options_attributes[*]) != 0 ? aws_instance.default[*].instance_lifecycle : null
  description = "Indicates whether this is a Spot Instance or a Scheduled Instance"
}

output "spot_instance_request_id" {
  value       = length(var.spot_options_attributes[*]) != 0 && var.market_type == "spot" ? aws_instance.default[*].spot_instance_request_id : null
  description = "ID of the Spot Instance request"
}

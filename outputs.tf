output "public_ip" {
  description = "Public IP of instance (or EIP )"
  value       = "${join(",",coalescelist(concat(aws_eip.default.*.public_ip, list()),aws_instance.default.*.public_ip))}"
}

output "private_ip" {
  description = "Private IP of instance"
  value       = "${join(",", aws_instance.default.*.private_ip)}"
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = "${join(",", aws_instance.default.*.private_dns)}"
}

# Workaround to handle null resource that can have variable values, from strings to empty lists.
locals {
  list_eip            = "${null_resource.eip.0.triggers.created == true ? join(",", null_resource.eip.*.triggers.public_dns) : ""}"
  list_additional_eip = "${null_resource.additional_eip.0.triggers.created == true ? join(",", null_resource.additional_eip.*.triggers.public_dns) : ""}"
  local_dns_output    = "${join(",", distinct(compact(concat(split(",", local.list_additional_eip), split(",", local.list_eip), aws_instance.default.*.public_dns))))}"
}

output "public_dns" {
  description = "Public DNS of instance (or DNS of EIP)"

  value = "${local.local_dns_output}"
}

output "id" {
  description = "Disambiguated ID"
  value       = "${join(",", aws_instance.default.*.id)}"
}

output "aws_key_pair_name" {
  description = "Name of AWS key pair"
  value       = "${signum(length(var.ssh_key_pair)) == 1 ? var.ssh_key_pair : "${var.generate_ssh_key_pair == "true" ? module.ssh_key_pair.key_name : ""}"}"
}

output "new_ssh_keypair_generated" {
  value = "${signum(length(var.ssh_key_pair)) == 1 ? "false" : "true" }"
}

output "ssh_key_pem_path" {
  description = "Path where SSH key pair was created (if applicable)"
  value       = "${local.ssh_key_pair_path}/${module.ssh_key_pair.key_name}.pem"
}

output "security_group_ids" {
  description = "ID on the new AWS Security Group associated with creating instance"
  value       = "${compact(concat(list(var.create_default_security_group == "true" ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}"
}

output "role" {
  description = "Name of AWS IAM Role associated with creating instance"
  value       = "${join(",", aws_iam_role.default.*.name)}"
}

output "alarm" {
  description = "CloudWatch Alarm ID"
  value       = "${join(",", aws_cloudwatch_metric_alarm.default.*.id)}"
}

output "additional_eni_ids" {
  description = "Map of ENI with EIP"
  value       = "${zipmap(aws_network_interface.additional.*.id, aws_eip.additional.*.public_ip)}"
}

output "ebs_ids" {
  description = "ID of EBSs"
  value       = "${join(",", aws_ebs_volume.default.*.id)}"
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface"
  value       = "${join(",", aws_instance.default.*.primary_network_interface_id)}"
}

output "network_interface_id" {
  description = "ID of the network interface that was created with the instance"
  value       = "${join(",", aws_instance.default.*.network_interface_id)}"
}

output "eips_per_instance" {
  value       = "${local.count_default_ips + local.additional_ips_count}"
  description = "Number of EIP's per instance."
}

output "instance_count" {
  value       = "${local.instance_count}"
  description = "Total number of instances created."
}

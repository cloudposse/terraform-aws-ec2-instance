output "public_ip" {
  description = "Public IP of instance (or EIP )"
  value       = "${coalesce(join("", aws_eip.default.*.public_ip), aws_instance.default.public_ip)}"
}

output "private_ip" {
  description = "Private IP of instance"
  value       = "${join("", aws_instance.default.*.private_ip)}"
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = "${join("", aws_instance.default.*.private_dns)}"
}

output "public_dns" {
  description = "Public DNS of instance (or DNS of EIP)"
  value       = "${coalesce(join("", null_resource.eip.*.triggers.public_dns), aws_instance.default.public_dns)}"
}

output "id" {
  description = "Disambiguated ID"
  value       = "${join("", aws_instance.default.*.id)}"
}

output "ssh_key_pair" {
  description = "Name of used AWS SSH key"
  value       = "${var.ssh_key_pair}"
}

output "security_group_ids" {
  description = "ID on the new AWS Security Group associated with creating instance"
  value       = "${compact(concat(list(var.create_default_security_group == "true" ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}"
}

output "role" {
  description = "Name of AWS IAM Role associated with creating instance"
  value       = "${join("", aws_iam_role.default.*.name)}"
}

output "alarm" {
  description = "CloudWatch Alarm ID"
  value       = "${join("", aws_cloudwatch_metric_alarm.default.*.id)}"
}

output "additional_eni_ids" {
  description = "Map of ENI with EIP"
  value       = "${zipmap(aws_network_interface.additional.*.id, aws_eip.additional.*.public_ip)}"
}

output "ebs_ids" {
  description = "ID of EBSs"
  value       = "${aws_ebs_volume.default.*.id}"
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface"
  value       = "${aws_instance.default.primary_network_interface_id}"
}

output "network_interface_id" {
  description = "ID of the network interface that was created with the instance"
  value       = "${aws_instance.default.network_interface_id}"
}

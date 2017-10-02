output "public_ip" {
  value = "${coalesce(join("", aws_eip.default.*.public_ip), aws_instance.default.public_ip)}"
}

output "private_ip" {
  value = "${join("", aws_instance.default.*.private_ip)}"
}

output "private_dns" {
  value = "${join("", aws_instance.default.*.private_dns)}"
}

output "public_dns" {
  value = "${coalesce(join("", null_resource.eip.*.triggers.public_dns), aws_instance.default.public_dns)}"
}

output "id" {
  value = "${join("", aws_instance.default.*.id)}"
}

output "ssh_key_pair" {
  value = "${var.ssh_key_pair}"
}

output "security_group_ids" {
  value = "${compact(concat(list(var.create_default_security_group ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}"
}

output "role" {
  value = "${join("", aws_iam_role.default.*.name)}"
}

output "alarm" {
  value = "${join("", aws_cloudwatch_metric_alarm.default.*.id)}"
}

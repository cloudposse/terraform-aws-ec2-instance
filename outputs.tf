output "public_ip" {
  value = "${aws_eip.default.public_ip}"
}

output "public_hostname" {
  value = "${aws_instance.default.public_dns}"
}

output "id" {
  value = "${aws_instance.default.id}"
}

output "ssh_key" {
  value = "${var.ssh_key}"
}

output "ip" {
  value = "${aws_eip.lb.public_ip}"
}

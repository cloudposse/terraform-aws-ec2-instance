locals {
  additional_ips_count = "${var.associate_public_ip_address == "true" && var.instance_enabled == "true" && var.additional_ips_count > 0 ? var.additional_ips_count : 0}"
}

resource "aws_network_interface" "additional" {
  count     = "${local.additional_ips_count * var.instance_count}"
  subnet_id = "${local.subnet}"

  security_groups = [
    "${compact(concat(list(var.create_default_security_group == "true" ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}",
  ]

  tags = "${module.label.tags}"
}

resource "aws_network_interface_attachment" "additional" {
  count                = "${local.additional_ips_count * var.instance_count}"
  instance_id          = "${aws_instance.default.id}"
  network_interface_id = "${element(aws_network_interface.additional.*.id, floor(count.index / var.instance_count))}"
  device_index         = "${1 + count.index}"
}

resource "aws_eip" "additional" {
  count             = "${local.additional_ips_count * var.instance_count}"
  vpc               = "true"
  network_interface = "${element(aws_network_interface.additional.*.id, floor(count.index / var.instance_count))}"
}

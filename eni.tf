locals {
  additional_ips_count = "${var.associate_public_ip_address == "true" && var.instance_enabled == "true" && var.additional_ips_count > 0 ? var.additional_ips_count : 0}"
}

resource "aws_network_interface" "additional" {
  count     = "${local.additional_ips_count * var.instance_count}"
  subnet_id = "${var.subnet}"

  security_groups = [
    "${compact(concat(list(var.create_default_security_group == "true" ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}",
  ]

  tags       = "${module.label.tags}"
  depends_on = ["aws_instance.default"]
}

resource "aws_network_interface_attachment" "additional" {
  count                = "${local.additional_ips_count * var.instance_count}"
  instance_id          = "${element(aws_instance.default.*.id, count.index % var.instance_count)}"
  network_interface_id = "${element(aws_network_interface.additional.*.id, count.index)}"
  device_index         = "${1 + count.index}"
  depends_on           = ["aws_instance.default"]
}

resource "aws_eip" "additional" {
  count             = "${local.additional_ips_count * var.instance_count}"
  vpc               = "true"
  network_interface = "${element(aws_network_interface.additional.*.id, count.index)}"
  depends_on        = ["aws_instance.default"]
}

resource "null_resource" "additional_eip" {
  # Have at least 1, so that resource exists for output without error, workaround for terraform 0.11.x If instance_count or additional_eips is 0 then the `created` output will be false otherwise it will be true
  count = "${signum(local.instance_count * local.additional_ips_count) == 1 ? local.additional_ips_count * local.instance_count : 1}"

  triggers {
    created    = "${local.instance_count * local.additional_ips_count == 0 ? false : true }"
    public_dns = "ec2-${replace(element(coalescelist(aws_eip.additional.*.public_ip, list("invalid")), count.index), ".", "-")}.${var.region == "us-east-1" ? "compute-1" : "${var.region}.compute"}.amazonaws.com"
  }
}

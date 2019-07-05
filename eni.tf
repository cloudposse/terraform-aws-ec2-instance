locals {
  additional_ips_count = var.associate_public_ip_address && var.instance_enabled && var.additional_ips_count > 0 ? var.additional_ips_count : 0
}

resource "aws_network_interface" "additional" {
  count     = local.additional_ips_count
  subnet_id = var.subnet

  security_groups = compact(
    concat(
      [
        var.create_default_security_group ? join("", aws_security_group.default.*.id) : ""
      ],
      var.security_groups
    )
  )

  tags = module.label.tags
}

resource "aws_network_interface_attachment" "additional" {
  count                = local.additional_ips_count
  instance_id          = join("", aws_instance.default.*.id)
  network_interface_id = aws_network_interface.additional[count.index].id
  device_index         = 1 + count.index
}

resource "aws_eip" "additional" {
  count             = local.additional_ips_count
  vpc               = true
  network_interface = aws_network_interface.additional[count.index].id
}

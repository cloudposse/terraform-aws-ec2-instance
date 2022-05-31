locals {
  additional_ips_count = module.this.enabled && var.associate_public_ip_address && var.additional_ips_count > 0 ? var.additional_ips_count : 0
}

locals {
  security_groups = compact(
    concat(
      formatlist("%s", module.security_group.id),
      var.security_groups
    )
  )
}

resource "aws_network_interface" "additional" {
  count     = local.additional_ips_count
  subnet_id = local.subnet_id

  security_groups = local.security_groups

  tags = module.this.tags
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

resource "aws_network_interface_sg_attachment" "existing" {
  count                = var.existing_network_interface_id == null ? 0 : length(local.security_groups)
  security_group_id    = local.security_groups[count.index]
  network_interface_id = var.existing_network_interface_id
}

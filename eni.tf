locals {
  additional_ips_count = module.this.enabled && var.associate_public_ip_address && var.additional_ips_count > 0 ? var.additional_ips_count : 0
}

resource "aws_network_interface" "additional" {
  count     = local.additional_ips_count
  subnet_id = var.subnet

  security_groups = compact(
    concat(
      formatlist("%s", module.security_group.id),
      var.security_groups
    )
  )

  tags = module.this.tags
}

resource "aws_network_interface_attachment" "additional" {
  count                = local.additional_ips_count
  instance_id          = one(aws_instance.default[*].id)
  network_interface_id = aws_network_interface.additional[count.index].id
  device_index         = 1 + count.index
}

resource "aws_eip" "additional" {
  #bridgecrew:skip=BC_AWS_NETWORKING_48: Skiping `Ensure all EIP addresses allocated to a VPC are attached to EC2 instances` because it is incorrectly flagging that this instance does not belong to a VPC even though subnet_id is configured.
  count             = local.additional_ips_count
  domain            = "vpc"
  network_interface = aws_network_interface.additional[count.index].id
}

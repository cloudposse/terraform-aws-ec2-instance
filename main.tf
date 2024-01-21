locals {
  enabled        = module.this.enabled
  instance_count = local.enabled ? 1 : 0
  volume_count   = var.ebs_volume_count > 0 && local.instance_count > 0 ? var.ebs_volume_count : 0
  # create an instance profile if the instance is enabled and we aren't given one to use
  instance_profile_count = module.this.enabled && var.instance_profile_enabled && var.instance_profile == "" ? 1 : 0
  instance_profile       = var.instance_profile_enabled && var.instance_profile != "" ? var.instance_profile : (var.instance_profile_enabled ? one(aws_iam_instance_profile.default[*].name) : "")
  security_group_enabled = module.this.enabled && var.security_group_enabled
  region                 = var.region != "" ? var.region : data.aws_region.default.name
  root_iops              = contains(["io1", "io2", "gp3"], var.root_volume_type) ? var.root_iops : null
  ebs_iops               = contains(["io1", "io2", "gp3"], var.ebs_volume_type) ? var.ebs_iops : null
  root_throughput        = var.root_volume_type == "gp3" ? var.root_throughput : null
  ebs_throughput         = var.ebs_volume_type == "gp3" ? var.ebs_throughput : null
  availability_zone      = var.availability_zone != "" ? var.availability_zone : data.aws_subnet.default.availability_zone
  ami                    = var.ami != "" ? var.ami : one(data.aws_ami.default[*].image_id)
  ami_owner              = var.ami != "" ? var.ami_owner : one(data.aws_ami.default[*].owner_id)
  root_volume_type       = var.root_volume_type != "" ? var.root_volume_type : one(data.aws_ami.info[*].root_device_type)

  region_domain  = local.region == "us-east-1" ? "compute-1.amazonaws.com" : "${local.region}.compute.amazonaws.com"
  eip_public_dns = var.associate_public_ip_address && var.assign_eip_address && module.this.enabled ? "ec2-${replace(one(aws_eip.default[*].public_ip), ".", "-")}.${local.region_domain}" : ""
  public_dns = (
    var.associate_public_ip_address && var.assign_eip_address && module.this.enabled ?
    local.eip_public_dns : one(aws_instance.default[*].public_dns)
  )
}

data "aws_caller_identity" "default" {
}

data "aws_region" "default" {
}

data "aws_partition" "default" {
}

data "aws_subnet" "default" {
  id = var.subnet
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}
data "aws_ami" "default" {
  count       = var.ami == "" ? 1 : 0
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "info" {
  count = var.root_volume_type != "" ? 0 : 1

  filter {
    name   = "image-id"
    values = [local.ami]
  }

  owners = [local.ami_owner]
}

data "aws_iam_instance_profile" "given" {
  count = local.enabled && var.instance_profile_enabled && var.instance_profile != "" ? 1 : 0
  name  = var.instance_profile
}

resource "aws_iam_instance_profile" "default" {
  count = var.instance_profile_enabled ? local.instance_profile_count : 0
  name  = module.this.id
  role  = one(aws_iam_role.default[*].name)
}

resource "aws_iam_role" "default" {
  count                = var.instance_profile_enabled ? local.instance_profile_count : 0
  name                 = module.this.id
  path                 = "/"
  assume_role_policy   = data.aws_iam_policy_document.default.json
  permissions_boundary = var.permissions_boundary_arn
  tags                 = module.this.tags
}

resource "aws_instance" "default" {
  #bridgecrew:skip=BC_AWS_GENERAL_31: Skipping `Ensure Instance Metadata Service Version 1 is not enabled` check until BridgeCrew supports conditional evaluation. See https://github.com/bridgecrewio/checkov/issues/793
  #bridgecrew:skip=BC_AWS_NETWORKING_47: Skiping `Ensure AWS EC2 instance is configured with VPC` because it is incorrectly flagging that this instance does not belong to a VPC even though subnet_id is configured.
  count                                = local.instance_count
  ami                                  = local.ami
  availability_zone                    = local.availability_zone
  instance_type                        = var.instance_type
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  user_data                            = var.user_data
  user_data_base64                     = var.user_data_base64
  iam_instance_profile                 = var.instance_profile_enabled ? local.instance_profile : ""
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  associate_public_ip_address          = var.external_network_interface_enabled ? null : var.associate_public_ip_address
  key_name                             = var.ssh_key_pair
  subnet_id                            = var.external_network_interface_enabled ? null : var.subnet
  monitoring                           = var.monitoring
  private_ip                           = var.private_ip
  secondary_private_ips                = var.external_network_interface_enabled ? null : var.secondary_private_ips
  source_dest_check                    = var.external_network_interface_enabled ? null : var.source_dest_check
  ipv6_address_count                   = var.external_network_interface_enabled && var.ipv6_address_count == 0 ? null : var.ipv6_address_count
  ipv6_addresses                       = length(var.ipv6_addresses) == 0 ? null : var.ipv6_addresses
  tenancy                              = var.tenancy

  vpc_security_group_ids = var.external_network_interface_enabled ? null : compact(
    concat(
      formatlist("%s", module.security_group.id),
      var.security_groups
    )
  )

  dynamic "network_interface" {
    for_each = var.external_network_interface_enabled ? var.external_network_interfaces : []
    content {
      delete_on_termination = network_interface.value.delete_on_termination
      device_index          = network_interface.value.device_index
      network_card_index    = network_interface.value.network_card_index
      network_interface_id  = network_interface.value.network_interface_id
    }

  }
  root_block_device {
    volume_type           = local.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = local.root_iops
    throughput            = local.root_throughput
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
    kms_key_id            = var.root_block_device_kms_key_id
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint_enabled ? "enabled" : "disabled"
    instance_metadata_tags      = var.metadata_tags_enabled ? "enabled" : "disabled"
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = var.metadata_http_tokens_required ? "required" : "optional"
  }

  credit_specification {
    cpu_credits = var.burstable_mode
  }

  lifecycle {
    ignore_changes = [
      ami
    ]
  }

  tags = module.this.tags

  volume_tags = var.volume_tags_enabled ? module.this.tags : {}
}

resource "aws_eip" "default" {
  #bridgecrew:skip=BC_AWS_NETWORKING_48: Skiping `Ensure all EIP addresses allocated to a VPC are attached to EC2 instances` because it is incorrectly flagging that this instance does not belong to a VPC even though subnet_id is configured.
  count    = var.associate_public_ip_address && var.assign_eip_address && module.this.enabled ? 1 : 0
  instance = one(aws_instance.default[*].id)
  domain   = "vpc"
  tags     = module.this.tags
}

resource "aws_ebs_volume" "default" {
  count             = local.volume_count
  availability_zone = local.availability_zone
  size              = var.ebs_volume_size
  iops              = local.ebs_iops
  throughput        = local.ebs_throughput
  type              = var.ebs_volume_type
  tags              = module.this.tags
  encrypted         = var.ebs_volume_encrypted
  kms_key_id        = var.kms_key_id
}

resource "aws_volume_attachment" "default" {
  count       = local.volume_count
  device_name = var.ebs_device_name[count.index]
  volume_id   = aws_ebs_volume.default[count.index].id
  instance_id = one(aws_instance.default[*].id)
}

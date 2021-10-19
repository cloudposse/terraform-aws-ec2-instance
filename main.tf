locals {
  enabled        = module.this.enabled
  instance_count = local.enabled ? 1 : 0
  volume_count   = var.ebs_volume_count > 0 && local.instance_count > 0 ? var.ebs_volume_count : 0
  # create an instance profile if the instance is enabled and we aren't given one to use
  instance_profile_count = module.this.enabled ? (length(var.instance_profile) > 0 ? 0 : 1) : 0
  instance_profile       = local.instance_profile_count == 0 ? var.instance_profile : join("", aws_iam_instance_profile.default.*.name)
  security_group_enabled = module.this.enabled && var.security_group_enabled
  region                 = var.region != "" ? var.region : data.aws_region.default.name
  root_iops              = var.root_volume_type == "io1" ? var.root_iops : "0"
  ebs_iops               = var.ebs_volume_type == "io1" ? var.ebs_iops : "0"
  availability_zone      = var.availability_zone != "" ? var.availability_zone : data.aws_subnet.default.availability_zone
  ami                    = var.ami != "" ? var.ami : join("", data.aws_ami.default.*.image_id)
  ami_owner              = var.ami != "" ? var.ami_owner : join("", data.aws_ami.default.*.owner_id)
  root_volume_type       = var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info.root_device_type

  region_domain  = local.region == "us-east-1" ? "compute-1.amazonaws.com" : "${local.region}.compute.amazonaws.com"
  eip_public_dns = "ec2-${replace(join("", aws_eip.default.*.public_ip), ".", "-")}.${local.region_domain}"
  public_dns = (
    var.associate_public_ip_address && var.assign_eip_address && module.this.enabled ?
    local.eip_public_dns : join("", aws_instance.default.*.public_dns)
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
  filter {
    name   = "image-id"
    values = [local.ami]
  }

  owners = [local.ami_owner]
}

# https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.13-examples/module-depends-on
resource "null_resource" "instance_profile_dependency" {
  count = local.enabled && length(var.instance_profile) > 0 ? 1 : 0
  triggers = {
    dependency_id = var.instance_profile
  }
}

data "aws_iam_instance_profile" "given" {
  count      = local.enabled && length(var.instance_profile) > 0 ? 1 : 0
  name       = var.instance_profile
  depends_on = [null_resource.instance_profile_dependency]
}

resource "aws_iam_instance_profile" "default" {
  count = local.instance_profile_count
  name  = module.this.id
  role  = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role" "default" {
  count                = local.instance_profile_count
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
  iam_instance_profile                 = local.instance_profile
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  associate_public_ip_address          = var.associate_public_ip_address
  key_name                             = var.ssh_key_pair
  subnet_id                            = var.subnet
  monitoring                           = var.monitoring
  private_ip                           = var.private_ip
  source_dest_check                    = var.source_dest_check
  ipv6_address_count                   = var.ipv6_address_count < 0 ? null : var.ipv6_address_count
  ipv6_addresses                       = length(var.ipv6_addresses) == 0 ? null : var.ipv6_addresses

  vpc_security_group_ids = compact(
    concat(
      formatlist("%s", module.security_group.id),
      var.security_groups
    )
  )

  root_block_device {
    volume_type           = local.root_volume_type
    volume_size           = var.root_volume_size
    iops                  = local.root_iops
    delete_on_termination = var.delete_on_termination
    encrypted             = var.root_block_device_encrypted
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint_enabled ? "enabled" : "disabled"
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    http_tokens                 = var.metadata_http_tokens_required ? "required" : "optional"
  }

  credit_specification {
    cpu_credits = var.burstable_mode
  }

  tags = module.this.tags

  volume_tags = var.volume_tags_enabled ? module.this.tags : {}
}

resource "aws_eip" "default" {
  count    = var.associate_public_ip_address && var.assign_eip_address && module.this.enabled ? 1 : 0
  instance = join("", aws_instance.default.*.id)
  vpc      = true
  tags     = module.this.tags
}

resource "aws_ebs_volume" "default" {
  count             = local.volume_count
  availability_zone = local.availability_zone
  size              = var.ebs_volume_size
  iops              = local.ebs_iops
  type              = var.ebs_volume_type
  tags              = module.this.tags
  encrypted         = var.ebs_volume_encrypted
  kms_key_id        = var.kms_key_id
}

resource "aws_volume_attachment" "default" {
  count       = local.volume_count
  device_name = var.ebs_device_name[count.index]
  volume_id   = aws_ebs_volume.default.*.id[count.index]
  instance_id = join("", aws_instance.default.*.id)
}

locals {
  instance_count       = "${var.instance_enabled == "true" ? var.instance_count : 0}"
  security_group_count = "${var.create_default_security_group == "true" ? 1 : 0}"
  region               = "${var.region}"
  root_iops            = "${var.root_volume_type == "io1" ? var.root_iops : "0"}"
  ebs_iops             = "${var.ebs_volume_type == "io1" ? var.ebs_iops : "0"}"
  availability_zone    = "${var.availability_zone}"
  ami                  = "${var.ami != "" ? var.ami : data.aws_ami.default.image_id}"
  root_volume_type     = "${var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info.root_device_type}"
  count_default_ips    = "${var.associate_public_ip_address == "true" && var.assign_eip_address == "true" && var.instance_enabled == "true" && var.instance_count > 0 ? 1 : 0}"
  ssh_key_pair_path    = "${var.ssh_key_pair_path == "" ? path.cwd : var.ssh_key_pair_path }"
}

data "aws_caller_identity" "default" {}

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
  most_recent = "true"

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
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
    values = ["${local.ami}"]
  }
}

# Apply the tf_label module for this resource
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  tags       = "${merge(map("AZ", "${local.availability_zone}"), var.tags)}"
  enabled    = "${local.instance_count > 0 ? "true" : "false"}"
}

resource "aws_iam_instance_profile" "default" {
  count = "${signum(local.instance_count)}"
  name  = "${module.label.id}"
  role  = "${element(aws_iam_role.default.*.name, 0)}"
}

resource "aws_iam_role" "default" {
  count              = "${signum(local.instance_count)}"
  name               = "${module.label.id}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_instance" "default" {
  count                       = "${local.instance_count}"
  ami                         = "${local.ami}"
  availability_zone           = "${local.availability_zone}"
  instance_type               = "${var.instance_type}"
  ebs_optimized               = "${var.ebs_optimized}"
  disable_api_termination     = "${var.disable_api_termination}"
  user_data                   = "${var.user_data}"
  iam_instance_profile        = "${element(aws_iam_instance_profile.default.*.name, 0)}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${signum(length(var.ssh_key_pair)) == 1 ? var.ssh_key_pair : module.ssh_key_pair.key_name}"
  subnet_id                   = "${var.subnet}"
  monitoring                  = "${var.monitoring}"
  private_ip                  = "${var.private_ip}"
  source_dest_check           = "${var.source_dest_check}"
  ipv6_address_count          = "${var.ipv6_address_count}"
  ipv6_addresses              = "${var.ipv6_addresses}"

  vpc_security_group_ids = [
    "${compact(concat(list(var.create_default_security_group == "true" ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}",
  ]

  root_block_device {
    volume_type           = "${local.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    iops                  = "${local.root_iops}"
    delete_on_termination = "${var.delete_on_termination}"
  }

  tags = "${merge(module.label.tags, map("instance_index", "${count.index}"))}"
}

##
## Create keypair if one isn't provided
##

module "ssh_key_pair" {
  #  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  source                = "../terraform-aws-key-pair"
  namespace             = "${var.namespace}"
  stage                 = "${var.stage}"
  name                  = "${var.name}"
  ssh_public_key_path   = "${local.ssh_key_pair_path}"
  private_key_extension = ".pem"
  generate_ssh_key      = "${var.generate_ssh_key_pair}"
}

resource "aws_eip" "default" {
  count             = "${local.count_default_ips}"
  network_interface = "${element(aws_instance.default.*.primary_network_interface_id, count.index)}"
  vpc               = "true"
  depends_on        = ["aws_instance.default"]
}

resource "null_resource" "eip" {
  # Have at least 1, so that resource exists for output without error, workaround for terraform 0.11.x If instance_count or additional_eips is 0 then the `created` output will be false otherwise it will be true
  count = "${signum(local.instance_count * local.count_default_ips) == 1 ? local.count_default_ips * local.instance_count : 1}"

  triggers {
    created    = "${local.instance_count * local.count_default_ips == 0 ? false : true }"
    public_dns = "ec2-${replace(element(coalescelist(aws_eip.default.*.public_ip, list("invalid")), count.index), ".", "-")}.${var.region == "us-east-1" ? "compute-1" : "${var.region}.compute"}.amazonaws.com"
  }
}

resource "aws_ebs_volume" "default" {
  count             = "${var.ebs_volume_count * local.instance_count}"
  availability_zone = "${local.availability_zone}"
  size              = "${var.ebs_volume_size}"
  iops              = "${local.ebs_iops}"
  type              = "${var.ebs_volume_type}"
  tags              = "${module.label.tags}"
}

resource "aws_volume_attachment" "default" {
  count       = "${signum(local.instance_count) == 1 ? floor(var.ebs_volume_count / max(local.instance_count, 1)) : 0 }"
  device_name = "${element(var.ebs_device_name, count.index)}"
  volume_id   = "${element(aws_ebs_volume.default.*.id, count.index)}"
  instance_id = "${aws_instance.default.id}"
}

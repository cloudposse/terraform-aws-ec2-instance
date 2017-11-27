locals {
  instance_count       = "${var.instance_enabled ? 1 : 0}"
  security_group_count = "${var.create_default_security_group ? 1 : 0}"
  region               = "${var.region != "" ? var.region : data.aws_region.default.name}"
  root_iops            = "${var.root_volume_type == "io1" ? var.root_iops : "0"}"
  ebs_iops             = "${var.ebs_volume_type == "io1" ? var.ebs_iops : "0"}"
  availability_zone    = "${var.availability_zone != "" ? var.availability_zone : data.aws_subnet.default.availability_zone}"
  ami                  = "${var.ami != "" ? var.ami : data.aws_ami.default.image_id}"
  root_volume_type     = "${var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info.root_device_type}"
  user_data            = "${length(var.custom_user_data) > 0 ? var.custom_user_data : join("", data.template_file.user_data.*.rendered)}"
}

data "aws_caller_identity" "default" {}

data "aws_region" "default" {
  current = "true"
}

data "aws_subnet" "default" {
  id = "${var.subnet}"
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
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
  tags       = "${merge(map("AZ", "${local.availability_zone}"), var.tags)}"
  enabled    = "${local.instance_count ? "true" : "false"}"
}

resource "aws_iam_instance_profile" "default" {
  count = "${local.instance_count}"
  name  = "${module.label.id}"
  role  = "${aws_iam_role.default.name}"
}

resource "aws_iam_role" "default" {
  count              = "${local.instance_count}"
  name               = "${module.label.id}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

# Apply the tf_github_authorized_keys module for this resource
module "github_authorized_keys" {
  source              = "git::https://github.com/cloudposse/terraform-template-user-data-github-authorized-keys.git?ref=tags/0.1.2"
  github_api_token    = "${var.github_api_token}"
  github_organization = "${var.github_organization}"
  github_team         = "${var.github_team}"
}

resource "aws_instance" "default" {
  count                       = "${local.instance_count}"
  ami                         = "${local.ami}"
  availability_zone           = "${local.availability_zone}"
  instance_type               = "${var.instance_type}"
  ebs_optimized               = "${var.ebs_optimized}"
  disable_api_termination     = "${var.disable_api_termination}"
  user_data                   = "${local.user_data}"
  iam_instance_profile        = "${aws_iam_instance_profile.default.name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${var.ssh_key_pair}"
  subnet_id                   = "${var.subnet}"
  monitoring                  = "${var.monitoring}"
  private_ip                  = "${var.private_ip}"
  source_dest_check           = "${var.source_dest_check}"
  ipv6_address_count          = "${var.ipv6_address_count}"
  ipv6_addresses              = "${var.ipv6_addresses}"

  vpc_security_group_ids = [
    "${compact(concat(list(var.create_default_security_group ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}",
  ]

  root_block_device {
    volume_type           = "${local.root_volume_type}"
    volume_size           = "${var.root_volume_size}"
    iops                  = "${local.root_iops}"
    delete_on_termination = "${var.delete_on_termination}"
  }

  tags = "${module.label.tags}"
}

resource "aws_eip" "default" {
  count             = "${var.associate_public_ip_address && var.instance_enabled ? 1 : 0}"
  network_interface = "${aws_instance.default.primary_network_interface_id}"
  vpc               = "true"
}

resource "null_resource" "eip" {
  count = "${var.associate_public_ip_address && var.instance_enabled ? 1 : 0}"

  triggers {
    public_dns = "ec2-${replace(aws_eip.default.public_ip, ".", "-")}.${local.region == "us-east-1" ? "compute-1" : "${local.region}.compute"}.amazonaws.com"
  }
}

resource "aws_ebs_volume" "default" {
  count             = "${var.ebs_volume_count}"
  availability_zone = "${local.availability_zone}"
  size              = "${var.ebs_volume_size}"
  iops              = "${local.ebs_iops}"
  type              = "${var.ebs_volume_type}"
  tags              = "${module.label.tags}"
}

resource "aws_volume_attachment" "default" {
  count       = "${var.ebs_volume_count}"
  device_name = "${element(var.ebs_device_name, count.index)}"
  volume_id   = "${element(aws_ebs_volume.default.*.id, count.index)}"
  instance_id = "${aws_instance.default.id}"
}

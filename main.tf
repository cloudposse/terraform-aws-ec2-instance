locals {
  instance_count       = "${var.instance_enabled == "true" ? var.instance_count : 0}"
  security_group_count = "${var.create_default_security_group == "true" ? 1 : 0}"
  region               = "${var.region != "" ? var.region : data.aws_region.default.name}"
  root_iops            = "${var.root_volume_type == "io1" ? var.root_iops : "0"}"
  ebs_iops             = "${var.ebs_volume_type == "io1" ? var.ebs_iops : "0"}"
  availability_zone    = "${var.availability_zone != "" ? var.availability_zone : data.aws_subnet.default.availability_zone}"
  ami                  = "${var.ami != "" ? var.ami : data.aws_ami.default.image_id}"
  root_volume_type     = "${var.root_volume_type != "" ? var.root_volume_type : data.aws_ami.info.root_device_type}"
  subnet               = "${var.subnet == "" ? data.aws_subnet.default.id : var.subnet}"
  vpc_id               = "${var.vpc_id == "" ? data.aws_vpc.default.id : var.vpc_id }"
  additional_eips      = "${var.associate_public_ip_address == "true" && var.assign_eip_address == "true" && var.instance_enabled == "true" ? var.instance_count : 0}"
}

data "aws_caller_identity" "default" {}

data "aws_region" "default" {}

data "aws_subnet" "default" {
  id = "${signum(length(var.subnet)) == 1 ? var.subnet : data.aws_subnet_ids.all.ids[0]}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
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
  key_name                    = "${signum(length(var.ssh_key_pair)) == 1 ? var.ssh_key_pair : element(aws_key_pair.ssh.*.key_name, 0)}"
  subnet_id                   = "${local.subnet}"
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

  tags = "${module.label.tags}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

##
## Create keypair if one isn't provided
##

locals {
  key_pair_path = "${var.generate_ssh_key_pair == "true" && signum(length(var.ssh_key_pair)) == 0 && signum(var.instance_count) == 1 ? "${path.cwd}/${element(aws_key_pair.ssh.*.key_name, 0)}.pem" : "" }"
}
resource "aws_key_pair" "ssh" {
  count = "${var.generate_ssh_key_pair == "true" && signum(length(var.ssh_key_pair)) == 1 && signum(var.instance_count) == 1 ? 0 : 1}"
  key_name_prefix = "${module.label.id}"
  public_key      = "${tls_private_key.ssh.public_key_openssh}"
}

resource "local_file" "keypair" {
    count = "${var.generate_ssh_key_pair == "true" && signum(length(var.ssh_key_pair)) == 0 && signum(var.instance_count) == 1 ? 1 : 0 }"
    content     = "${tls_private_key.ssh.private_key_pem}"
    filename = "${path.cwd}/${element(aws_key_pair.ssh.*.key_name, 0)}.pem"
}

resource "aws_eip" "default" {
  count             = "${local.additional_eips * var.instance_count}"
  network_interface = "${element(aws_instance.default.*.primary_network_interface_id, count.index / var.instance_count)}"
  vpc               = "true"
}



resource "null_resource" "eip" {
  count             = "${local.additional_eips * local.instance_count}"

  triggers {
    public_dns = "ec2-${replace(element(aws_eip.default.*.public_ip, count.index), ".", "-")}.${local.region == "us-east-1" ? "compute-1" : "${local.region}.compute"}.amazonaws.com"
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
  count       = "${signum(local.instance_count) == 1 ? var.ebs_volume_count / max(local.instance_count, 1) : 0 }"
  device_name = "${element(var.ebs_device_name, count.index)}"
  volume_id   = "${element(aws_ebs_volume.default.*.id, count.index)}"
  instance_id = "${aws_instance.default.id}"
}

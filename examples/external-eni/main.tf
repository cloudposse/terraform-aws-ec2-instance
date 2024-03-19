provider "aws" {
  region = var.region
}

module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.18.3"
  namespace           = module.this.namespace
  stage               = module.this.stage
  name                = module.this.name
  attributes          = module.this.attributes
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = true
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.0"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.3.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "instance_profile_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = distinct(compact(concat(module.this.attributes, ["profile"])))

  context = module.this.context
}

data "aws_iam_policy_document" "test" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "test" {
  name               = module.instance_profile_label.id
  assume_role_policy = data.aws_iam_policy_document.test.json
  tags               = module.instance_profile_label.tags
}

resource "aws_iam_instance_profile" "test" {
  name = module.instance_profile_label.id
  role = aws_iam_role.test.name
}

resource "aws_network_interface" "one" {
  subnet_id       = module.subnets.private_subnet_ids[0]
  security_groups = [module.vpc.vpc_default_security_group_id]
  tags            = module.this.tags
}

resource "aws_network_interface" "two" {
  subnet_id       = module.subnets.private_subnet_ids[0]
  security_groups = [module.vpc.vpc_default_security_group_id]
  tags            = module.this.tags
}

module "ec2_instance" {
  source = "../../"

  ssh_key_pair                       = module.aws_key_pair.key_name
  vpc_id                             = module.vpc.vpc_id
  subnet                             = module.subnets.private_subnet_ids[0]
  security_groups                    = [module.vpc.vpc_default_security_group_id]
  assign_eip_address                 = var.assign_eip_address
  associate_public_ip_address        = var.associate_public_ip_address
  instance_type                      = var.instance_type
  security_group_rules               = var.security_group_rules
  instance_profile                   = aws_iam_instance_profile.test.name
  tenancy                            = var.tenancy
  external_network_interface_enabled = true

  external_network_interfaces = [
    {
      delete_on_termination = false
      device_index          = 0
      network_card_index    = 0
      network_interface_id  = aws_network_interface.one.id
    },
    {
      delete_on_termination = false
      device_index          = 1
      network_card_index    = 0
      network_interface_id  = aws_network_interface.two.id
    }
  ]

  context = module.this.context

  depends_on = [aws_iam_instance_profile.test]
}

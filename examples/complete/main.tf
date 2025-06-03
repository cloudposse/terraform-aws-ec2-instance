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

  context = module.this.context
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.0"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

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
  count = module.this.enabled ? 1 : 0
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
  count = module.this.enabled ? 1 : 0

  name               = module.instance_profile_label.id
  assume_role_policy = one(data.aws_iam_policy_document.test[*].json)
  tags               = module.instance_profile_label.tags
}

# https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.13-examples/module-depends-on
resource "aws_iam_instance_profile" "test" {
  count = module.this.enabled ? 1 : 0

  name = module.instance_profile_label.id
  role = aws_iam_role.test[0].name
}

module "ec2_instance" {
  source = "../../"

  ssh_key_pair                = module.aws_key_pair.key_name
  vpc_id                      = module.vpc.vpc_id
  subnet                      = module.this.enabled ? module.subnets.private_subnet_ids[0] : null
  security_groups             = [module.vpc.vpc_default_security_group_id]
  assign_eip_address          = var.assign_eip_address
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  security_group_rules        = var.security_group_rules
  instance_profile            = module.this.enabled ? aws_iam_instance_profile.test[0].name : null
  tenancy                     = var.tenancy
  metric_treat_missing_data   = var.metric_treat_missing_data

  depends_on = [aws_iam_instance_profile.test]

  context = module.this.context
}

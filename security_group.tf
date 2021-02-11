module "default_sg" {
  source  = "cloudposse/security-group/aws"
  version = "0.1.2"
  rules   = var.security_group_rules
  vpc_id  = var.vpc_id

  enabled = local.security_group_enabled
  context = module.this.context
}

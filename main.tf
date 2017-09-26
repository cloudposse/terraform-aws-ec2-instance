# Using tf_ansible module

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

# Apply the tf_label module for this resource
module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${var.instance_enabled ? var.instance_enabled : ""}"]
}

resource "aws_iam_instance_profile" "default" {
  count = "${var.instance_enabled}"
  name  = "${module.label.id}"
  role  = "${aws_iam_role.default.name}"
}

resource "aws_iam_role" "default" {
  count = "${var.instance_enabled}"
  name  = "${module.label.id}"
  path  = "/"

  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_security_group" "default" {
  count       = "${var.create_default_security_group}"
  name        = "${module.label.id}"
  vpc_id      = "${var.vpc_id}"
  description = "Instance default security group (only egress access is allowed)"

  tags {
    Name      = "${module.label.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }

  egress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Apply the tf_github_authorized_keys module for this resource
module "github_authorized_keys" {
  source              = "git::https://github.com/cloudposse/tf_github_authorized_keys.git?ref=tags/0.1.0"
  github_api_token    = "${var.github_api_token}"
  github_organization = "${var.github_organization}"
  github_team         = "${var.github_team}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    user_data       = "${join("\n", compact(concat(var.user_data, list(module.github_authorized_keys.user_data))))}"
    welcome_message = "${var.welcome_message}"
    ssh_user        = "${var.ssh_user}"
  }
}

resource "aws_instance" "default" {
  count         = "${var.instance_enabled}"
  ami           = "${var.ec2_ami}"
  instance_type = "${var.instance_type}"

  user_data = "${data.template_file.user_data.rendered}"

  vpc_security_group_ids = [
    "${compact(concat(list(var.create_default_security_group ? join("", aws_security_group.default.*.id) : ""), var.security_groups))}",
  ]

  iam_instance_profile        = "${aws_iam_instance_profile.default.name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  key_name = "${var.ssh_key_pair}"

  subnet_id = "${var.subnets[0]}"

  tags {
    Name      = "${module.label.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }
}

resource "aws_eip" "default" {
  count    = "${var.associate_public_ip_address && var.instance_enabled ? 1 : 0}"
  instance = "${aws_instance.default.id}"
  vpc      = true
}

# Apply the provisioner module for this resource
module "ansible" {
  source    = "git::https://github.com/cloudposse/terraform-null-ansible.git?ref=tags/0.3.8"
  arguments = "${var.ansible_arguments}"
  envs      = "${compact(concat(var.ansible_envs, list("host=${var.associate_public_ip_address ? join("", aws_eip.default.*.public_ip) : join("", aws_instance.default.*.private_ip)}")))}"
  playbook  = "${var.ansible_playbook}"
  dry_run   = "${var.ansible_dry_run}"
}

# Restart dead or hung instance
data "aws_region" "default" {
  current = true
}

data "aws_caller_identity" "default" {}

resource "null_resource" "check_alarm_action" {
  count = "${var.instance_enabled}"

  triggers = {
    action = "arn:aws:swf:${data.aws_region.default.name}:${data.aws_caller_identity.default.account_id}:${var.default_alarm_action}"
  }
}

resource "aws_cloudwatch_metric_alarm" "default" {
  count               = "${var.instance_enabled}"
  alarm_name          = "${module.label.id}"
  comparison_operator = "${var.comparison_operator}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.metric_name}"
  namespace           = "${var.metric_namespace}"
  period              = "${var.applying_period}"
  statistic           = "${var.statistic_level}"
  threshold           = "${var.metric_threshold}"
  depends_on          = ["null_resource.check_alarm_action"]

  dimensions {
    InstanceId = "${aws_instance.default.id}"
  }

  alarm_actions = [
    "${null_resource.check_alarm_action.triggers.action}",
  ]
}

resource "null_resource" "eip" {
  count = "${var.associate_public_ip_address && var.instance_enabled ? 1 : 0}"

  triggers {
    public_dns = "ec2-${replace(aws_eip.default.public_ip, ".", "-")}.${data.aws_region.default.name == "us-east-1" ? "compute-1" : "${data.aws_region.default.name}.compute"}.amazonaws.com"
  }
}

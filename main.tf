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
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=tags/0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

# Apply the tf_github_authorized_keys module for this resource
module "github_authorized_keys" {
  source              = "git::https://github.com/cloudposse/tf_github_authorized_keys.git?ref=tags/0.1.0"
  github_api_token    = "${var.github_api_token}"
  github_organization = "${var.github_organization}"
  github_team         = "${var.github_team}"
}

resource "aws_iam_instance_profile" "default" {
  name = "${module.label.id}"
  role = "${aws_iam_role.default.name}"
}

resource "aws_iam_role" "default" {
  name = "${module.label.id}"
  path = "/"

  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_security_group" "default" {
  name        = "${module.label.id}"
  vpc_id      = "${var.vpc_id}"
  description = "Instance security group (only SSH inbound access is allowed)"

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

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = ["${var.security_groups}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "default" {
  ami           = "${var.ec2_ami}"
  instance_type = "${var.instance_type}"

  user_data = "${module.github_authorized_keys.user_data}"

  vpc_security_group_ids = [
    "${aws_security_group.default.id}",
    "${var.security_groups}",
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
  count    = "${signum(length(var.associate_public_ip_address)) == 1 ? 1 : 0}"
  instance = "${aws_instance.default.id}"
  vpc      = true
}

# Apply the provisioner module for this resource
module "ansible" {
  source    = "git::https://github.com/cloudposse/tf_ansible.git?ref=tags/0.2.0"
  arguments = "${var.ansible_arguments}"
  envs      = ["host=${aws_eip.default.public_ip}"]
  playbook  = "${var.ansible_playbook}"
}

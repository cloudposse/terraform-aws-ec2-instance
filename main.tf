# Using tf_ansible module

resource "aws_key_pair" "default" {
  key_name   = "admin-key"
  public_key = "${var.ssh_key}"
  tags = "${module.tf_label.tags}"
}

resource "aws_instance" "default" {
  ami           = "ami-408c7f28"
  instance_type = "t1.micro"

  tags {
    Name = "admin"
  }

  key_name = "${aws_key_pair.default.key_name}"
}

# Apply the tf_github_authorized_keys module for this resource
module "github_authorized_keys" {
  source              = "git::https://github.com/cloudposse/tf_github_authorized_keys?ref=init"
  github_api_token    = "${var.github_api_token}"
  github_organization = "${var.github_organization}"
  github_team         = "${var.github_team}"
}

# Apply the provisioner module for this resource
module "ansible_provisioner" {
  source   = "git::https://github.com/cloudposse/tf_ansible?ref=master"
  envs     = ["host=${aws_instance.default.private_ip}"]
  playbook = "${var.playbook}"
}

# Apply the tf_label module for this resource
module "tf_label" {
  source    = "git::https://github.com/cloudposse/tf_label?ref=master"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

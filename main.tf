# Using tf_ansible module

resource "aws_instance" "default" {
  ami           = "${var.ec2_ami}"
  instance_type = "var.instance_type"
  tags          = "${module.tf_label.tags}"
  key_name      = "${var.ssh_key_pair}"
  user_data     = "${module.tf_github_authorized_keys.user_data}"
}

resource "aws_eip" "default" {
  instance = "${aws_instance.default.id}"
  vpc      = true
}

# Apply the tf_github_authorized_keys module for this resource
module "tf_github_authorized_keys" {
  source              = "git::https://github.com/cloudposse/tf_github_authorized_keys.git?ref=0.1.0"
  github_api_token    = "${var.github_api_token}"
  github_organization = "${var.github_organization}"
  github_team         = "${var.github_team}"
}

# Apply the provisioner module for this resource
module "ansible_provisioner" {
  source   = "git::https://github.com/cloudposse/tf_ansible.git?ref=tags/0.1.0"
  envs     = ["host=${aws_instance.default.private_ip}"]
  playbook = "${var.playbook}"
}

# Apply the tf_label module for this resource
module "tf_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=tags/0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

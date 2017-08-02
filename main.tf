### Using tf_ansible module

resource "aws_key_pair" "admin" {
  key_name   = "admin-key"
  public_key = "${var.ssh-key}"
}

resource "aws_instance" "manager" {
  ami           = "ami-408c7f28"
  instance_type = "t1.micro"

  tags {
    Name = "manager"
  }

  key_name = "${aws_key_pair.admin.key_name}"
}

### Apply the tf_github_authorized_keys module for this resource
module "github_authorized_keys" {
  source              = "github.com/cloudposse/tf_github_authorized_keys"
  github_api_token    = "${var.github_api_token}"
  github_organization = "${var.github_organization}"
  github_team         = "${var.github_team}"
}

### Apply the provisioner module to this resource
module "ansible_provisioner" {
  source   = "github.com/cloudposse/tf_ansible"
  envs     = ["host=${aws_instance.manager.public_ip}"]
  playbook = "../ansible/playbooks/provisioner.yml"
}

# tf_instance

Terraform Module for providing a server capable of running admin tasks. Use `tf_instance` to create and manage an admin instance.

## Usage

Include this repository as a module in your existing terraform code:

```
module "admin_tier" {
  source              = "git::https://github.com/cloudposse/tf_instance.git?ref=tags/0.1.0"
  playbook            = "../ansible/playbooks/admin_tier.yml"
  ssh_key_pair        = "${var.ssh_key_pair}"
  github_api_token    = "${var.github_api_token}"
  github_organization = "${var.github_organization}"
  github_team         = "${var.github_team}"
  instance_type       = "${var.instance_type}"
}
```

This will create a `id`, `public_hostname` and `public_ip`.

This module uses next modules:

* tf_label
* tf_github_authorized_keys
* ansible_provisioner

It is necessary to run `terraform get` to download those modules.

Now reference the label when creating an instance (for example):
```
resource "aws_ami_from_instance" "example" {
  name               = "terraform-example"
  source_instance_id = "${module.admin_tier.id}"
}
```

## Variables

|  Name                        |  Default       |  Description                                             | Required        |
|:----------------------------:|:--------------:|:--------------------------------------------------------:|:---------------:|
| namespace                    | `global`       | Namespace (e.g. `cp` or `cloudposse`) - required for tf_label module | Yes |
| stage                        | `default`      | Stage (e.g. `prod`, `dev`, `staging` - required for tf_label module  | Yes |
| name                         | `admin`        | Name  (e.g. `bastion` or `db`) - required for tf_label module        | Yes |
| ec2_ami                      | `ami-408c7f28` | By default it is an AMI provided by Amazon with Ubuntu 14.04         | Yes |
| ssh_key_pair                 | ``             | SSH key pair to be provisioned on instance                           | Yes |
| github_api_token             | ``             | GitHub API token                                                     | Yes |
| github_organization          | ``             | GitHub organization name                                             | Yes |
| github_team                  | ``             | GitHub team                                                          | Yes |
| playbook                     | ``             | Path to the playbook - required for ansible_provisioner              | Yes |
| instance_type                | ``             | The type of the creating instance (e.g. `t1.micro`)                  | Yes |

## Outputs

| Name              | Decription            |
|:-----------------:|:---------------------:|
| id                | Disambiguated ID      |
| public_hostname   | Normalized name       |
| public_ip         | Normalized namespace  |



# terraform-aws-ec2-instance

Terraform Module for providing a server capable of running admin tasks. Use `terraform-aws-ec2-instance` to create and manage an admin instance.

## Usage

Note: add `${var.ssh_key_pair}` private key to the `ssh agent`.

Include this repository as a module in your existing terraform code:

```terraform
module "admin_tier" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-ec2-instance.git?ref=master"
  ssh_key_pair                = "${var.ssh_key_pair}"
  github_api_token            = "${var.github_api_token}"
  github_organization         = "${var.github_organization}"
  github_team                 = "${var.github_team}"
  instance_type               = "${var.instance_type}"
  vpc_id                      = "${var.vpc_id}"
  security_groups             = ["${var.security_groups}"]
  subnets                     = ["${var.subnets}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  name                        = "${var.name}"
  namespace                   = "${var.namespace}"
  stage                       = "${var.stage}"
}
```

This will create a `id`, `public_hostname` and `public_ip`.

This module depends on these modules:

* [terraform-null-label](https://github.com/cloudposse/terraform-null-label)
* [tf_github_authorized_keys](https://github.com/cloudposse/tf_github_authorized_keys)

It is necessary to run `terraform get` to download those modules.

Now reference the label when creating an instance (for example):
```terraform
resource "aws_ami_from_instance" "example" {
  name               = "terraform-example"
  source_instance_id = "${module.admin_tier.id}"
}
```

## Variables

| Name                            |                    Default                     | Description                                                                              | Required |
|:--------------------------------|:----------------------------------------------:|:-----------------------------------------------------------------------------------------|:--------:|
| `namespace`                     |                    `global`                    | Namespace (e.g. `cp` or `cloudposse`) - required for `tf_label` module                   |   Yes    |
| `stage`                         |                   `default`                    | Stage (e.g. `prod`, `dev`, `staging` - required for `tf_label` module                    |   Yes    |
| `name`                          |                    `admin`                     | Name  (e.g. `bastion` or `db`) - required for `tf_label` module                          |   Yes    |
| `attributes`                    |                       []                       | Additional attributes (e.g. `policy` or `role`)                                          |    No    |
| `tags`                          |                       {}                       | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                       |    No    |
| `ec2_ami`                       |                 `ami-cd0f5cb6`                 | By default it is an AMI provided by Amazon with Ubuntu 16.04                             |    No    |
| `instance_enabled`              |                     `true`                     | Flag for creating an instance. Set to false if it is necessary to skip instance creation |    No    |
| `create_default_security_group` |                     `true`                     | Flag for creation default Security Group with Egress traffic allowed only                |    No    |
| `ssh_key_pair`                  |                       ``                       | SSH key pair to be provisioned on instance                                               |   Yes    |
| `github_api_token`              |                       ``                       | GitHub API token                                                                         |   Yes    |
| `github_organization`           |                       ``                       | GitHub organization name                                                                 |   Yes    |
| `github_team`                   |                       ``                       | GitHub team                                                                              |   Yes    |
| `instance_type`                 |                   `t2.micro`                   | The type of the creating instance (e.g. `t2.micro`)                                      |    No    |
| `vpc_id`                        |                       ``                       | The id of the VPC that the creating instance security group belongs to                   |   Yes    |
| `security_groups`               |                       []                       | List of Security Group IDs allowed to connect to creating instance                       |   Yes    |
| `subnets`                       |                       []                       | List of VPC Subnet IDs creating instance launched in                                     |   Yes    |
| `associate_public_ip_address`   |                     `true`                     | Associate a public ip address with the creating instance. Boolean value                  |    No    |
| `comparison_operator`           |        `GreaterThanOrEqualToThreshold`         | Arithmetic operation to use when comparing the specified Statistic and Threshold         |   Yes    |
| `metric_name`                   |          `StatusCheckFailed_Instance`          | Name for the alarm's associated metric                                                   |   Yes    |
| `evaluation_periods`            |                      `5`                       | Number of periods over which data is compared to the specified threshold                 |   Yes    |
| `metric_namespace`              |                   `AWS/EC2`                    | Namespace for the alarm's associated metric                                              |   Yes    |
| `applying_period`               |                      `60`                      | Period in seconds over which the specified statistic is applied                          |   Yes    |
| `statistic_level`               |                   `Maximum`                    | Statistic to apply to the alarm's associated metric                                      |   Yes    |
| `metric_threshold`              |                      `1`                       | Value against which the specified statistic is compared                                  |   Yes    |
| `default_alarm_action`          | `action/actions/AWS_EC2.InstanceId.Reboot/1.0` | String of action to execute when this alarm transitions into an ALARM state              |   Yes    |

## Outputs

| Name                | Description                                                        |
|:--------------------|:-------------------------------------------------------------------|
| `id`                | Disambiguated ID                                                   |
| `private_dns`       | Normalized name                                                    |
| `private_ip`        | Normalized namespace                                               |
| `public_ip`         | Public IP of instance (or EIP )                                    |
| `public_dns`        | Public DNS of instance (or DNS of EIP)                             |
| `ssh_key_pair`      | Name of used AWS SSH key                                           |
| `security_group_id` | ID on the new AWS Security Group associated with creating instance |
| `role`              | Name of AWS IAM Role associated with creating instance             |
| `alarm`             | CloudWatch Alarm ID                                                |

## References
* Thanks to https://github.com/cloudposse/tf_bastion for the inspiration

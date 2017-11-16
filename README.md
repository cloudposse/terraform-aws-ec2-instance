# terraform-aws-ec2-instance [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-ec2-instance.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-ec2-instance)

Terraform Module for providing a `EC2` instance. Use `terraform-aws-ec2-instance` to create and manage an `EC2` instance.

## Usage

Note: add `${var.ssh_key_pair}` private key to the `ssh agent`.

Include this repository as a module in your existing terraform code.

### Simple example:

```terraform
module "instance" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-ec2-instance.git?ref=master"
  ssh_key_pair                = "${var.ssh_key_pair}"
  instance_type               = "${var.instance_type}"
  vpc_id                      = "${var.vpc_id}"
  security_groups             = ["${var.security_groups}"]
  subnet                      = "${var.subnet}"
  name                        = "${var.name}"
  namespace                   = "${var.namespace}"
  stage                       = "${var.stage}"
}
```

### Example with [tf_github_authorized_keys](https://github.com/cloudposse/tf_github_authorized_keys):

```terraform
module "instance_github" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-ec2-instance.git?ref=master"
  ssh_key_pair                = "${var.ssh_key_pair}"
  github_api_token            = "${var.github_api_token}"
  github_organization         = "${var.github_organization}"
  github_team                 = "${var.github_team}"
  instance_type               = "${var.instance_type}"
  vpc_id                      = "${var.vpc_id}"
  security_groups             = ["${var.security_groups}"]
  subnet                      = "${var.subnet}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  name                        = "${var.name}"
  namespace                   = "${var.namespace}"
  stage                       = "${var.stage}"
}
```

### Example with additional volumes and EIP

```terraform
module "kafka_instance" {
  source                      = "git::https://github.com/cloudposse/terraform-aws-ec2-instance.git?ref=master"
  ssh_key_pair                = "${var.ssh_key_pair}"
  github_api_token            = "${var.github_api_token}"
  github_organization         = "${var.github_organization}"
  github_team                 = "${var.github_team}"
  vpc_id                      = "${var.vpc_id}"
  security_groups             = ["${var.security_groups}"]
  subnet                      = "${var.subnet}"
  associate_public_ip_address = "true"
  name                        = "kafka"
  namespace                   = "cp"
  stage                       = "dev"
  additional_ips_count        = "1"
  ebs_volume_count            = "2"
  allowed_ports               = ["22", "80", "443"]
}
```

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

| Name                            |                    Default                     | Description                                                                                            | Required |
|:--------------------------------|:----------------------------------------------:|:-------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                     |                       ``                       | Namespace (e.g. `cp` or `cloudposse`)                                                                  |   Yes    |
| `stage`                         |                       ``                       | Stage (e.g. `prod`, `dev`, `staging`                                                                   |   Yes    |
| `name`                          |                       ``                       | Name  (e.g. `bastion` or `db`)                                                                         |   Yes    |
| `attributes`                    |                      `[]`                      | Additional attributes (e.g. `policy` or `role`)                                                        |    No    |
| `tags`                          |                      `{}`                      | Additional tags  (e.g. `map("BusinessUnit","XYZ")`                                                     |    No    |
| `ami`                           |                       ``                       | By default it is an AMI provided by Amazon with Ubuntu 16.04                                           |    No    |
| `instance_enabled`              |                     `true`                     | Flag for creating an instance. Set to false if it is necessary to skip instance creation               |    No    |
| `create_default_security_group` |                     `true`                     | Flag for creation default Security Group with Egress traffic allowed only                              |    No    |
| `ssh_key_pair`                  |                       ``                       | SSH key pair to be provisioned on instance                                                             |   Yes    |
| `github_api_token`              |                       ``                       | GitHub API token                                                                                       |    No    |
| `github_organization`           |                       ``                       | GitHub organization name                                                                               |    No    |
| `github_team`                   |                       ``                       | GitHub team                                                                                            |    No    |
| `instance_type`                 |                   `t2.micro`                   | The type of the creating instance (e.g. `t2.micro`)                                                    |    No    |
| `vpc_id`                        |                       ``                       | The ID of the VPC that the creating instance security group belongs to                                 |   Yes    |
| `security_groups`               |                      `[]`                      | List of Security Group IDs allowed to connect to creating instance                                     |   Yes    |
| `allowed_ports`                 |                      `[]`                      | List of allowed ingress ports e.g. ["22", "80", "443"]                                                 |    No    |
| `subnet`                        |                       ``                       | VPC Subnet ID creating instance launched in                                                            |   Yes    |
| `associate_public_ip_address`   |                     `true`                     | Associate a public ip address with the creating instance. Boolean value                                |    No    |
| `additional_ips_count`          |                      `0`                       | Count of additional EIPs                                                                               |    No    |
| `private_ip`                    |                       ``                       | Private IP address to associate with the instance in a VPC                                             |    No    |
| `source_dest_check`             |                     `true`                     | Controls if traffic is routed to the instance when the destination address does not match the instance |    No    |
| `ipv6_address_count`            |                      `0`                       | Number of IPv6 addresses to associate with the primary network interface                               |    No    |
| `ipv6_addresses`                |                      `[]`                      | List of IPv6 addresses from the range of the subnet to associate with the primary network interface    |    No    |
| `root_volume_type`              |                     `gp2`                      | Type of root volume. Can be `standard`, `gp2` or `io1`                                                 |    No    |
| `root_volume_size`              |                      `10`                      | Size of the root volume in gigabytes                                                                   |    No    |
| `root_iops`                     |                      `0`                       | Amount of provisioned IOPS. This must be set with a `root_volume_type` of `io1`                        |    No    |
| `ebs_device_name`               |                 `[/dev/xvdb]`                  | Name of the ebs device to mount                                                                        |    No    |
| `ebs_volume_type`               |                     `gp2`                      | Type of EBS volume. Can be standard, `gp2` or `io1`                                                    |    No    |
| `ebs_volume_size`               |                      `10`                      | Size of the EBS volume in gigabytes                                                                    |    No    |
| `ebs_iops`                      |                      `0`                       | Amount of provisioned IOPS. This must be set with a `ebs_volume_type` of `io1`                         |    No    |
| `ebs_volume_count`              |                      `0`                       | Count of EBS which will be attched to instance                                                         |    No    |
| `delete_on_termination`         |                     `true`                     | Whether the volume should be destroyed on instance termination                                         |    No    |
| `comparison_operator`           |        `GreaterThanOrEqualToThreshold`         | Arithmetic operation to use when comparing the specified Statistic and Threshold                       |    No    |
| `metric_name`                   |          `StatusCheckFailed_Instance`          | Name for the alarm's associated metric                                                                 |    No    |
| `evaluation_periods`            |                      `5`                       | Number of periods over which data is compared to the specified threshold                               |    No    |
| `metric_namespace`              |                   `AWS/EC2`                    | Namespace for the alarm's associated metric                                                            |    No    |
| `applying_period`               |                      `60`                      | Period in seconds over which the specified statistic is applied                                        |    No    |
| `statistic_level`               |                   `Maximum`                    | Statistic to apply to the alarm's associated metric                                                    |    No    |
| `metric_threshold`              |                      `1`                       | Value against which the specified statistic is compared                                                |    No    |
| `default_alarm_action`          | `action/actions/AWS_EC2.InstanceId.Reboot/1.0` | String of action to execute when this alarm transitions into an ALARM state                            |    No    |

## Outputs

| Name                 | Description                                                        |
|:---------------------|:-------------------------------------------------------------------|
| `id`                 | Disambiguated ID                                                   |
| `private_dns`        | Private DNS of instance                                            |
| `private_ip`         | Private IP of instance                                             |
| `public_ip`          | Public IP of instance (or EIP )                                    |
| `public_dns`         | Public DNS of instance (or DNS of EIP)                             |
| `ssh_key_pair`       | Name of used AWS SSH key                                           |
| `security_group_id`  | ID on the new AWS Security Group associated with creating instance |
| `role`               | Name of AWS IAM Role associated with creating instance             |
| `alarm`              | CloudWatch Alarm ID                                                |
| `additional_eni_ids` | Map of ENI with EIP                                                |
| `ebs_ids`            | ID of EBSs                                                         |

## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

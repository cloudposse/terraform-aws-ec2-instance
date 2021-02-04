<!-- markdownlint-disable -->
# terraform-aws-ec2-instance [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-ec2-instance.svg)](https://github.com/cloudposse/terraform-aws-ec2-instance/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)
<!-- markdownlint-restore -->

[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

Terraform Module for provisioning a general purpose EC2 host.

Included features:
* Automatically create a Security Group
* Option to switch EIP attachment
* CloudWatch monitoring and automatic reboot if instance hangs
* Assume Role capability


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps.
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out!







## Security & Compliance [<img src="https://cloudposse.com/wp-content/uploads/2020/11/bridgecrew.svg" width="250" align="right" />](https://bridgecrew.io/)

Security scanning is graciously provided by Bridgecrew. Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

| Benchmark | Description |
|--------|---------------|
| [![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=INFRASTRUCTURE+SECURITY) | Infrastructure Security Compliance |
| [![CIS KUBERNETES](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/cis_kubernetes)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=CIS+KUBERNETES+V1.5) | Center for Internet Security, KUBERNETES Compliance |
| [![CIS AWS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=CIS+AWS+V1.2) | Center for Internet Security, AWS Compliance |
| [![CIS AZURE](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=CIS+AZURE+V1.1) | Center for Internet Security, AZURE Compliance |
| [![PCI-DSS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=PCI-DSS+V3.2) | Payment Card Industry Data Security Standards Compliance |
| [![NIST-800-53](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=NIST-800-53) | National Institute of Standards and Technology Compliance |
| [![ISO27001](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=ISO27001) | Information Security Management System, ISO/IEC 27001 Compliance |
| [![SOC2](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=SOC2)| Service Organization Control 2 Compliance |
| [![CIS GCP](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=CIS+GCP+V1.1) | Center for Internet Security, GCP Compliance |
| [![HIPAA](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-ec2-instance/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-ec2-instance&benchmark=HIPAA) | Health Insurance Portability and Accountability Compliance |



## Usage


**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

Also, because of a bug in the Terraform registry ([hashicorp/terraform#21417](https://github.com/hashicorp/terraform/issues/21417)),
the registry shows many of our inputs as required when in fact they are optional.
The table below correctly indicates which inputs are required.


Note: add `${var.ssh_key_pair}` private key to the `ssh agent`.

Include this repository as a module in your existing terraform code.

### Simple example:

```hcl
module "instance" {
  source = "cloudposse/ec2-instance/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  ssh_key_pair                = var.ssh_key_pair
  instance_type               = var.instance_type
  vpc_id                      = var.vpc_id
  security_groups             = var.security_groups
  subnet                      = var.subnet
  name                        = "ec2"
  namespace                   = "eg"
  stage                       = "dev"
}
```

### Example with additional volumes and EIP

```hcl
module "kafka_instance" {
  source = "cloudposse/ec2-instance/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  ssh_key_pair                = var.ssh_key_pair
  vpc_id                      = var.vpc_id
  security_groups             = var.security_groups
  subnet                      = var.subnet
  associate_public_ip_address = true
  name                        = "kafka"
  namespace                   = "eg"
  stage                       = "dev"
  additional_ips_count        = 1
  ebs_volume_count            = 2
  security_group_rules = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
```






<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 2.0 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |
| null | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_ips\_count | Count of additional EIPs | `number` | `0` | no |
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| ami | The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04 | `string` | `""` | no |
| ami\_owner | Owner of the given AMI (ignored if `ami` unset) | `string` | `""` | no |
| applying\_period | The period in seconds over which the specified statistic is applied | `number` | `60` | no |
| assign\_eip\_address | Assign an Elastic IP address to the instance | `bool` | `true` | no |
| associate\_public\_ip\_address | Associate a public IP address with the instance | `bool` | `false` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| availability\_zone | Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region | `string` | `""` | no |
| comparison\_operator | The arithmetic operation to use when comparing the specified Statistic and Threshold. Possible values are: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold. | `string` | `"GreaterThanOrEqualToThreshold"` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| create\_default\_security\_group | Create default Security Group with only Egress traffic allowed | `bool` | `true` | no |
| default\_alarm\_action | Default alarm action | `string` | `"action/actions/AWS_EC2.InstanceId.Reboot/1.0"` | no |
| delete\_on\_termination | Whether the volume should be destroyed on instance termination | `bool` | `true` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| disable\_api\_termination | Enable EC2 Instance Termination Protection | `bool` | `false` | no |
| ebs\_device\_name | Name of the EBS device to mount | `list(string)` | <pre>[<br>  "/dev/xvdb",<br>  "/dev/xvdc",<br>  "/dev/xvdd",<br>  "/dev/xvde",<br>  "/dev/xvdf",<br>  "/dev/xvdg",<br>  "/dev/xvdh",<br>  "/dev/xvdi",<br>  "/dev/xvdj",<br>  "/dev/xvdk",<br>  "/dev/xvdl",<br>  "/dev/xvdm",<br>  "/dev/xvdn",<br>  "/dev/xvdo",<br>  "/dev/xvdp",<br>  "/dev/xvdq",<br>  "/dev/xvdr",<br>  "/dev/xvds",<br>  "/dev/xvdt",<br>  "/dev/xvdu",<br>  "/dev/xvdv",<br>  "/dev/xvdw",<br>  "/dev/xvdx",<br>  "/dev/xvdy",<br>  "/dev/xvdz"<br>]</pre> | no |
| ebs\_iops | Amount of provisioned IOPS. This must be set with a volume\_type of io1 | `number` | `0` | no |
| ebs\_optimized | Launched EC2 instance will be EBS-optimized | `bool` | `false` | no |
| ebs\_volume\_count | Count of EBS volumes that will be attached to the instance | `number` | `0` | no |
| ebs\_volume\_encrypted | Size of the EBS volume in gigabytes | `bool` | `true` | no |
| ebs\_volume\_size | Size of the EBS volume in gigabytes | `number` | `10` | no |
| ebs\_volume\_type | The type of EBS volume. Can be standard, gp2 or io1 | `string` | `"gp2"` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| evaluation\_periods | The number of periods over which data is compared to the specified threshold. | `number` | `5` | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| instance\_profile | A pre-defined profile to attach to the instance (default is to build our own) | `string` | `""` | no |
| instance\_type | The type of the instance | `string` | `"t2.micro"` | no |
| ipv6\_address\_count | Number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet (-1 to use subnet default) | `number` | `0` | no |
| ipv6\_addresses | List of IPv6 addresses from the range of the subnet to associate with the primary network interface | `list(string)` | `[]` | no |
| kms\_key\_id | KMS key ID used to encrypt EBS volume. When specifying kms\_key\_id, ebs\_volume\_encrypted needs to be set to true | `string` | `null` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| metadata\_http\_endpoint\_enabled | Whether the metadata service is available | `bool` | `true` | no |
| metadata\_http\_tokens\_required | Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2. | `bool` | `true` | no |
| metric\_name | The name for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html | `string` | `"StatusCheckFailed_Instance"` | no |
| metric\_namespace | The namespace for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html | `string` | `"AWS/EC2"` | no |
| metric\_threshold | The value against which the specified statistic is compared | `number` | `1` | no |
| monitoring | Launched EC2 instance will have detailed monitoring enabled | `bool` | `true` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| permissions\_boundary\_arn | Policy ARN to attach to instance role as a permissions boundary | `string` | `""` | no |
| private\_ip | Private IP address to associate with the instance in the VPC | `string` | `""` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| region | AWS Region the instance is launched in | `string` | `""` | no |
| root\_block\_device\_encrypted | Whether to encrypt the root block device | `bool` | `true` | no |
| root\_iops | Amount of provisioned IOPS. This must be set if root\_volume\_type is set to `io1` | `number` | `0` | no |
| root\_volume\_size | Size of the root volume in gigabytes | `number` | `10` | no |
| root\_volume\_type | Type of root volume. Can be standard, gp2 or io1 | `string` | `"gp2"` | no |
| security\_group\_rules | A list of maps of Security Group rules. <br>The values of map is fully complated with `aws_security_group_rule` resource. <br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule . | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 65535,<br>    "type": "egress"<br>  }<br>]</pre> | no |
| security\_groups | List of Security Group IDs allowed to connect to the instance | `list(string)` | `[]` | no |
| source\_dest\_check | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs | `bool` | `true` | no |
| ssh\_key\_pair | SSH key pair to be provisioned on the instance | `string` | n/a | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| statistic\_level | The statistic to apply to the alarm's associated metric. Allowed values are: SampleCount, Average, Sum, Minimum, Maximum | `string` | `"Maximum"` | no |
| subnet | VPC Subnet ID the instance is launched in | `string` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| user\_data | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; use `user_data_base64` instead | `string` | `null` | no |
| user\_data\_base64 | Can be used instead of `user_data` to pass base64-encoded binary data directly. Use this instead of `user_data` whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption | `string` | `null` | no |
| vpc\_id | The ID of the VPC that the instance security group belongs to | `string` | n/a | yes |
| welcome\_message | Welcome message | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_eni\_ids | Map of ENI to EIP |
| alarm | CloudWatch Alarm ID |
| arn | ARN of the instance |
| ebs\_ids | IDs of EBSs |
| id | Disambiguated ID of the instance |
| instance\_profile | Name of the instance's profile (either built or supplied) |
| name | Instance name |
| primary\_network\_interface\_id | ID of the instance's primary network interface |
| private\_dns | Private DNS of instance |
| private\_ip | Private IP of instance |
| public\_dns | Public DNS of instance (or DNS of EIP) |
| public\_ip | Public IP of instance (or EIP) |
| role | Name of AWS IAM Role associated with the instance |
| security\_group\_ids | IDs on the AWS Security Groups associated with the instance |
| ssh\_key\_pair | Name of the SSH key pair provisioned on the instance |

<!-- markdownlint-restore -->



## Share the Love

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-ec2-instance)! (it helps us **a lot**)

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-ec2-ami-backup](https://github.com/cloudposse/terraform-aws-ec2-ami-backup) - Terraform module for automatic & scheduled AMI creation
- [terraform-aws-ec2-ami-snapshot](https://github.com/cloudposse/terraform-aws-ec2-ami-snapshot) - Terraform module to easily generate AMI snapshots to create replica instances
- [terraform-aws-ec2-cloudwatch-sns-alarms](https://github.com/cloudposse/terraform-aws-ec2-cloudwatch-sns-alarms) - Terraform module that configures CloudWatch SNS alerts for EC2 instances
- [terraform-null-label](https://github.com/cloudposse/terraform-null-label) - Terraform Module to define a consistent naming convention by (namespace, stage, name, [attributes])




## References

For additional context, refer to some of these links.

- [terraform-aws-ec2-bastion-server](https://github.com/cloudposse/terraform-aws-ec2-bastion-server) - Terraform Module to define a generic Bastion host with parameterized user_data


## Help

**Got a question?** We got answers.

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-ec2-instance/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-ec2-instance/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2021 [Cloud Posse, LLC](https://cpco.io/copyright)



## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

<!-- markdownlint-disable -->
|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Sergey Vasilyev][s2504s_avatar]][s2504s_homepage]<br/>[Sergey Vasilyev][s2504s_homepage] | [![Valeriy][drama17_avatar]][drama17_homepage]<br/>[Valeriy][drama17_homepage] | [![Ivan Pinatti][ivan-pinatti_avatar]][ivan-pinatti_homepage]<br/>[Ivan Pinatti][ivan-pinatti_homepage] | [![Vladimir][SweetOps_avatar]][SweetOps_homepage]<br/>[Vladimir][SweetOps_homepage] | [![Konstantin B][comeanother_avatar]][comeanother_homepage]<br/>[Konstantin B][comeanother_homepage] | [![Maarten van der Hoef][maartenvanderhoef_avatar]][maartenvanderhoef_homepage]<br/>[Maarten van der Hoef][maartenvanderhoef_homepage] | [![Chris Weyl][rsrchboy_avatar]][rsrchboy_homepage]<br/>[Chris Weyl][rsrchboy_homepage] |
|---|---|---|---|---|---|---|---|---|---|
<!-- markdownlint-restore -->

  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png
  [goruha_homepage]: https://github.com/goruha
  [goruha_avatar]: https://img.cloudposse.com/150x150/https://github.com/goruha.png
  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png
  [s2504s_homepage]: https://github.com/s2504s
  [s2504s_avatar]: https://img.cloudposse.com/150x150/https://github.com/s2504s.png
  [drama17_homepage]: https://github.com/drama17
  [drama17_avatar]: https://img.cloudposse.com/150x150/https://github.com/drama17.png
  [ivan-pinatti_homepage]: https://github.com/ivan-pinatti
  [ivan-pinatti_avatar]: https://img.cloudposse.com/150x150/https://github.com/ivan-pinatti.png
  [SweetOps_homepage]: https://github.com/SweetOps
  [SweetOps_avatar]: https://img.cloudposse.com/150x150/https://github.com/SweetOps.png
  [comeanother_homepage]: https://github.com/comeanother
  [comeanother_avatar]: https://img.cloudposse.com/150x150/https://github.com/comeanother.png
  [maartenvanderhoef_homepage]: https://github.com/maartenvanderhoef
  [maartenvanderhoef_avatar]: https://img.cloudposse.com/150x150/https://github.com/maartenvanderhoef.png
  [rsrchboy_homepage]: https://github.com/rsrchboy
  [rsrchboy_avatar]: https://img.cloudposse.com/150x150/https://github.com/rsrchboy.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=newsletter
  [discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=discourse
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-ec2-instance&url=https://github.com/cloudposse/terraform-aws-ec2-instance
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-ec2-instance&url=https://github.com/cloudposse/terraform-aws-ec2-instance
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-ec2-instance
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-ec2-instance
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-ec2-instance
  [share_email]: mailto:?subject=terraform-aws-ec2-instance&body=https://github.com/cloudposse/terraform-aws-ec2-instance
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-ec2-instance?pixel&cs=github&cm=readme&an=terraform-aws-ec2-instance

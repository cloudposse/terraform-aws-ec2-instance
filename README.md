

<!-- markdownlint-disable -->
# terraform-aws-ec2-instance <a href="https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content="><img align="right" src="https://cloudposse.com/logo-300x69.svg" width="150" /></a>
<a href="https://github.com/cloudposse/terraform-aws-ec2-instance/releases/latest"><img src="https://img.shields.io/github/release/cloudposse/terraform-aws-ec2-instance.svg" alt="Latest Release"/></a><a href="https://slack.cloudposse.com"><img src="https://slack.cloudposse.com/badge.svg" alt="Slack Community"/></a>
<!-- markdownlint-restore -->

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `cloudposse/build-harness`.
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



> [!TIP]
> #### 👽 Use Atmos with Terraform
> Cloud Posse uses [`atmos`](https://atmos.tools) to easily orchestrate multiple environments using Terraform. <br/>
> Works with [Github Actions](https://atmos.tools/integrations/github-actions/), [Atlantis](https://atmos.tools/integrations/atlantis), or [Spacelift](https://atmos.tools/integrations/spacelift).
>
> <details>
> <summary><strong>Watch demo of using Atmos with Terraform</strong></summary>
> <img src="https://github.com/cloudposse/atmos/blob/master/docs/demo.gif?raw=true"/><br/>
> <i>Example of running <a href="https://atmos.tools"><code>atmos</code></a> to manage infrastructure from our <a href="https://atmos.tools/quick-start/">Quick Start</a> tutorial.</i>
> </detalis>







## Usage

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

> [!IMPORTANT]
> In Cloud Posse's examples, we avoid pinning modules to specific versions to prevent discrepancies between the documentation
> and the latest released versions. However, for your own projects, we strongly advise pinning each module to the exact version
> you're using. This practice ensures the stability of your infrastructure. Additionally, we recommend implementing a systematic
> approach for updating versions to avoid unexpected changes.









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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label_ssm_patch_s3_log_policy"></a> [label\_ssm\_patch\_s3\_log\_policy](#module\_label\_ssm\_patch\_s3\_log\_policy) | cloudposse/label/null | 0.25.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | cloudposse/security-group/aws | 0.4.3 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ebs_volume.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_eip.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.ssm_patch_s3_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_network_interface.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_attachment) | resource |
| [aws_volume_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [null_resource.check_alarm_action](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.info](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_instance_profile.given](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_patch_s3_log_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ips_count"></a> [additional\_ips\_count](#input\_additional\_ips\_count) | Count of additional EIPs | `number` | `0` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_ami"></a> [ami](#input\_ami) | The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04 | `string` | `""` | no |
| <a name="input_ami_owner"></a> [ami\_owner](#input\_ami\_owner) | Owner of the given AMI (ignored if `ami` unset, required if set) | `string` | `""` | no |
| <a name="input_applying_period"></a> [applying\_period](#input\_applying\_period) | The period in seconds over which the specified statistic is applied | `number` | `60` | no |
| <a name="input_assign_eip_address"></a> [assign\_eip\_address](#input\_assign\_eip\_address) | Assign an Elastic IP address to the instance | `bool` | `true` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associate a public IP address with the instance | `bool` | `false` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region | `string` | `""` | no |
| <a name="input_burstable_mode"></a> [burstable\_mode](#input\_burstable\_mode) | Enable burstable mode for the instance. Can be standard or unlimited. Applicable only for T2/T3/T4g instance types. | `string` | `null` | no |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | The arithmetic operation to use when comparing the specified Statistic and Threshold. Possible values are: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold. | `string` | `"GreaterThanOrEqualToThreshold"` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_default_alarm_action"></a> [default\_alarm\_action](#input\_default\_alarm\_action) | Default alarm action | `string` | `"action/actions/AWS_EC2.InstanceId.Reboot/1.0"` | no |
| <a name="input_delete_on_termination"></a> [delete\_on\_termination](#input\_delete\_on\_termination) | Whether the volume should be destroyed on instance termination | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_disable_alarm_action"></a> [disable\_alarm\_action](#input\_disable\_alarm\_action) | Disable the creation of Alarm Action | `bool` | `false` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | Enable EC2 Instance Termination Protection | `bool` | `false` | no |
| <a name="input_ebs_device_name"></a> [ebs\_device\_name](#input\_ebs\_device\_name) | Name of the EBS device to mount | `list(string)` | <pre>[<br>  "/dev/xvdb",<br>  "/dev/xvdc",<br>  "/dev/xvdd",<br>  "/dev/xvde",<br>  "/dev/xvdf",<br>  "/dev/xvdg",<br>  "/dev/xvdh",<br>  "/dev/xvdi",<br>  "/dev/xvdj",<br>  "/dev/xvdk",<br>  "/dev/xvdl",<br>  "/dev/xvdm",<br>  "/dev/xvdn",<br>  "/dev/xvdo",<br>  "/dev/xvdp",<br>  "/dev/xvdq",<br>  "/dev/xvdr",<br>  "/dev/xvds",<br>  "/dev/xvdt",<br>  "/dev/xvdu",<br>  "/dev/xvdv",<br>  "/dev/xvdw",<br>  "/dev/xvdx",<br>  "/dev/xvdy",<br>  "/dev/xvdz"<br>]</pre> | no |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | Amount of provisioned IOPS. This must be set with a volume\_type of `io1`, `io2` or `gp3` | `number` | `0` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | Launched EC2 instance will be EBS-optimized | `bool` | `true` | no |
| <a name="input_ebs_throughput"></a> [ebs\_throughput](#input\_ebs\_throughput) | Amount of throughput. This must be set if volume\_type is set to `gp3` | `number` | `0` | no |
| <a name="input_ebs_volume_count"></a> [ebs\_volume\_count](#input\_ebs\_volume\_count) | Count of EBS volumes that will be attached to the instance | `number` | `0` | no |
| <a name="input_ebs_volume_encrypted"></a> [ebs\_volume\_encrypted](#input\_ebs\_volume\_encrypted) | Whether to encrypt the additional EBS volumes | `bool` | `true` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Size of the additional EBS volumes in gigabytes | `number` | `10` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | The type of the additional EBS volumes. Can be standard, gp2, gp3, io1 or io2 | `string` | `"gp2"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | The number of periods over which data is compared to the specified threshold. | `number` | `5` | no |
| <a name="input_external_network_interface_enabled"></a> [external\_network\_interface\_enabled](#input\_external\_network\_interface\_enabled) | Wheter to attach an external ENI as the eth0 interface for the instance. Any change to the interface will force instance recreation. | `bool` | `false` | no |
| <a name="input_external_network_interfaces"></a> [external\_network\_interfaces](#input\_external\_network\_interfaces) | The external interface definitions to attach to the instances. This depends on the instance type | <pre>list(object({<br>    delete_on_termination = bool<br>    device_index          = number<br>    network_card_index    = number<br>    network_interface_id  = string<br>  }))</pre> | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Specifies whether an instance stops or terminates when you initiate shutdown from the instance. Can be one of 'stop' or 'terminate'. | `string` | `null` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | A pre-defined profile to attach to the instance (default is to build our own) | `string` | `""` | no |
| <a name="input_instance_profile_enabled"></a> [instance\_profile\_enabled](#input\_instance\_profile\_enabled) | Whether an IAM instance profile is created to pass a role to an Amazon EC2 instance when the instance starts | `bool` | `true` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of the instance | `string` | `"t2.micro"` | no |
| <a name="input_ipv6_address_count"></a> [ipv6\_address\_count](#input\_ipv6\_address\_count) | Number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet (-1 to use subnet default) | `number` | `0` | no |
| <a name="input_ipv6_addresses"></a> [ipv6\_addresses](#input\_ipv6\_addresses) | List of IPv6 addresses from the range of the subnet to associate with the primary network interface | `list(string)` | `[]` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID used to encrypt EBS volume. When specifying kms\_key\_id, ebs\_volume\_encrypted needs to be set to true | `string` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_metadata_http_endpoint_enabled"></a> [metadata\_http\_endpoint\_enabled](#input\_metadata\_http\_endpoint\_enabled) | Whether the metadata service is available | `bool` | `true` | no |
| <a name="input_metadata_http_put_response_hop_limit"></a> [metadata\_http\_put\_response\_hop\_limit](#input\_metadata\_http\_put\_response\_hop\_limit) | The desired HTTP PUT response hop limit (between 1 and 64) for instance metadata requests. | `number` | `2` | no |
| <a name="input_metadata_http_tokens_required"></a> [metadata\_http\_tokens\_required](#input\_metadata\_http\_tokens\_required) | Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2. | `bool` | `true` | no |
| <a name="input_metadata_tags_enabled"></a> [metadata\_tags\_enabled](#input\_metadata\_tags\_enabled) | Whether the tags are enabled in the metadata service. | `bool` | `false` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | The name for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html | `string` | `"StatusCheckFailed_Instance"` | no |
| <a name="input_metric_namespace"></a> [metric\_namespace](#input\_metric\_namespace) | The namespace for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html | `string` | `"AWS/EC2"` | no |
| <a name="input_metric_threshold"></a> [metric\_threshold](#input\_metric\_threshold) | The value against which the specified statistic is compared | `number` | `1` | no |
| <a name="input_metric_treat_missing_data"></a> [metric\_treat\_missing\_data](#input\_metric\_treat\_missing\_data) | Sets how this alarm is to handle missing data points. The following values are supported: `missing`, `ignore`, `breaching` and `notBreaching`. Defaults to `missing`. | `string` | `"missing"` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Launched EC2 instance will have detailed monitoring enabled | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | Policy ARN to attach to instance role as a permissions boundary | `string` | `""` | no |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP address to associate with the instance in the VPC | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region the instance is launched in | `string` | `""` | no |
| <a name="input_root_block_device_encrypted"></a> [root\_block\_device\_encrypted](#input\_root\_block\_device\_encrypted) | Whether to encrypt the root block device | `bool` | `true` | no |
| <a name="input_root_block_device_kms_key_id"></a> [root\_block\_device\_kms\_key\_id](#input\_root\_block\_device\_kms\_key\_id) | KMS key ID used to encrypt EBS volume. When specifying root\_block\_device\_kms\_key\_id, root\_block\_device\_encrypted needs to be set to true | `string` | `null` | no |
| <a name="input_root_iops"></a> [root\_iops](#input\_root\_iops) | Amount of provisioned IOPS. This must be set if root\_volume\_type is set of `io1`, `io2` or `gp3` | `number` | `0` | no |
| <a name="input_root_throughput"></a> [root\_throughput](#input\_root\_throughput) | Amount of throughput. This must be set if root\_volume\_type is set to `gp3` | `number` | `0` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of the root volume in gigabytes | `number` | `10` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Type of root volume. Can be standard, gp2, gp3, io1 or io2 | `string` | `"gp2"` | no |
| <a name="input_secondary_private_ips"></a> [secondary\_private\_ips](#input\_secondary\_private\_ips) | List of secondary private IP addresses to associate with the instance in the VPC | `list(string)` | `[]` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | The Security Group description. | `string` | `"EC2 Security Group"` | no |
| <a name="input_security_group_enabled"></a> [security\_group\_enabled](#input\_security\_group\_enabled) | Whether to create default Security Group for EC2. | `bool` | `true` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | A list of maps of Security Group rules.<br>The values of map is fully complated with `aws_security_group_rule` resource.<br>To get more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule . | `list(any)` | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow all outbound traffic",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "to_port": 65535,<br>    "type": "egress"<br>  }<br>]</pre> | no |
| <a name="input_security_group_use_name_prefix"></a> [security\_group\_use\_name\_prefix](#input\_security\_group\_use\_name\_prefix) | Whether to create a default Security Group with unique name beginning with the normalized prefix. | `bool` | `false` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of Security Group IDs to associate with EC2 instance. | `list(string)` | `[]` | no |
| <a name="input_source_dest_check"></a> [source\_dest\_check](#input\_source\_dest\_check) | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs | `bool` | `true` | no |
| <a name="input_ssh_key_pair"></a> [ssh\_key\_pair](#input\_ssh\_key\_pair) | SSH key pair to be provisioned on the instance | `string` | `null` | no |
| <a name="input_ssm_patch_manager_enabled"></a> [ssm\_patch\_manager\_enabled](#input\_ssm\_patch\_manager\_enabled) | Whether to enable SSM Patch manager | `bool` | `false` | no |
| <a name="input_ssm_patch_manager_iam_policy_arn"></a> [ssm\_patch\_manager\_iam\_policy\_arn](#input\_ssm\_patch\_manager\_iam\_policy\_arn) | IAM policy ARN to allow Patch Manager to manage the instance. If not provided, `arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore` will be used | `string` | `null` | no |
| <a name="input_ssm_patch_manager_s3_log_bucket"></a> [ssm\_patch\_manager\_s3\_log\_bucket](#input\_ssm\_patch\_manager\_s3\_log\_bucket) | The name of the s3 bucket to export the patch log to | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_statistic_level"></a> [statistic\_level](#input\_statistic\_level) | The statistic to apply to the alarm's associated metric. Allowed values are: SampleCount, Average, Sum, Minimum, Maximum | `string` | `"Maximum"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | VPC Subnet ID the instance is launched in | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenancy"></a> [tenancy](#input\_tenancy) | Tenancy of the instance (if the instance is running in a VPC). An instance with a tenancy of 'dedicated' runs on single-tenant hardware. The 'host' tenancy is not supported for the import-instance command. Valid values are 'default', 'dedicated', and 'host'. | `string` | `"default"` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; use `user_data_base64` instead | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | Can be used instead of `user_data` to pass base64-encoded binary data directly. Use this instead of `user_data` whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption | `string` | `null` | no |
| <a name="input_volume_tags_enabled"></a> [volume\_tags\_enabled](#input\_volume\_tags\_enabled) | Whether or not to copy instance tags to root and EBS volumes | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that the instance security group belongs to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_eni_ids"></a> [additional\_eni\_ids](#output\_additional\_eni\_ids) | Map of ENI to EIP |
| <a name="output_alarm"></a> [alarm](#output\_alarm) | CloudWatch Alarm ID |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the instance |
| <a name="output_ebs_ids"></a> [ebs\_ids](#output\_ebs\_ids) | IDs of EBSs |
| <a name="output_id"></a> [id](#output\_id) | Disambiguated ID of the instance |
| <a name="output_instance_profile"></a> [instance\_profile](#output\_instance\_profile) | Name of the instance's profile (either built or supplied) |
| <a name="output_name"></a> [name](#output\_name) | Instance name |
| <a name="output_primary_network_interface_id"></a> [primary\_network\_interface\_id](#output\_primary\_network\_interface\_id) | ID of the instance's primary network interface |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | Private DNS of instance |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IP of instance |
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | Public DNS of instance (or DNS of EIP) |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP of instance (or EIP) |
| <a name="output_role"></a> [role](#output\_role) | Name of AWS IAM Role associated with the instance |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of AWS IAM Role associated with the instance |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | EC2 instance Security Group ARN |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | EC2 instance Security Group ID |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | IDs on the AWS Security Groups associated with the instance |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | EC2 instance Security Group name |
| <a name="output_ssh_key_pair"></a> [ssh\_key\_pair](#output\_ssh\_key\_pair) | Name of the SSH key pair provisioned on the instance |
<!-- markdownlint-restore -->


## Related Projects

Check out these related projects.

- [terraform-aws-ec2-ami-backup](https://github.com/cloudposse/terraform-aws-ec2-ami-backup) - Terraform module for automatic & scheduled AMI creation
- [terraform-aws-ec2-ami-snapshot](https://github.com/cloudposse/terraform-aws-ec2-ami-snapshot) - Terraform module to easily generate AMI snapshots to create replica instances
- [terraform-aws-ec2-cloudwatch-sns-alarms](https://github.com/cloudposse/terraform-aws-ec2-cloudwatch-sns-alarms) - Terraform module that configures CloudWatch SNS alerts for EC2 instances
- [terraform-null-label](https://github.com/cloudposse/terraform-null-label) - Terraform Module to define a consistent naming convention by (namespace, stage, name, [attributes])


## References

For additional context, refer to some of these links.

- [terraform-aws-ec2-bastion-server](https://github.com/cloudposse/terraform-aws-ec2-bastion-server) - Terraform Module to define a generic Bastion host with parameterized user_data


## ✨ Contributing

This project is under active development, and we encourage contributions from our community.
Many thanks to our outstanding contributors:

<a href="https://github.com/cloudposse/terraform-aws-ec2-instance/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudposse/terraform-aws-ec2-instance&max=24" />
</a>

### 🐛 Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-ec2-instance/issues) to report any bugs or file feature requests.

### 💻 Developing

If you are interested in being a contributor and want to get involved in developing this project or help out with Cloud Posse's other projects, we would love to hear from you!
Hit us up in [Slack](https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=slack), in the `#cloudposse` channel.

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.
 1. Review our [Code of Conduct](https://github.com/cloudposse/terraform-aws-ec2-instance/?tab=coc-ov-file#code-of-conduct) and [Contributor Guidelines](https://github.com/cloudposse/.github/blob/main/CONTRIBUTING.md).
 2. **Fork** the repo on GitHub
 3. **Clone** the project to your own machine
 4. **Commit** changes to your own branch
 5. **Push** your work back up to your fork
 6. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

### 🌎 Slack Community

Join our [Open Source Community](https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=slack) on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

### 📰 Newsletter

Sign up for [our newsletter](https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=newsletter) and join 3,000+ DevOps engineers, CTOs, and founders who get insider access to the latest DevOps trends, so you can always stay in the know.
Dropped straight into your Inbox every week — and usually a 5-minute read.

### 📆 Office Hours <a href="https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=office_hours"><img src="https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png" align="right" /></a>

[Join us every Wednesday via Zoom](https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=office_hours) for your weekly dose of insider DevOps trends, AWS news and Terraform insights, all sourced from our SweetOps community, plus a _live Q&A_ that you can’t find anywhere else.
It's **FREE** for everyone!
## License

<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge" alt="License"></a>

<details>
<summary>Preamble to the Apache License, Version 2.0</summary>
<br/>
<br/>

Complete license is available in the [`LICENSE`](LICENSE) file.

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
</details>

## Trademarks

All other trademarks referenced herein are the property of their respective owners.


---
Copyright © 2017-2024 [Cloud Posse, LLC](https://cpco.io/copyright)


<a href="https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-ec2-instance&utm_content=readme_footer_link"><img alt="README footer" src="https://cloudposse.com/readme/footer/img"/></a>

<img alt="Beacon" width="0" src="https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-ec2-instance?pixel&cs=github&cm=readme&an=terraform-aws-ec2-instance"/>

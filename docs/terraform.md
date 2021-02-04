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
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>    label_key_case      = string<br>    label_value_case    = string<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
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
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| instance\_profile | A pre-defined profile to attach to the instance (default is to build our own) | `string` | `""` | no |
| instance\_type | The type of the instance | `string` | `"t2.micro"` | no |
| ipv6\_address\_count | Number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet (-1 to use subnet default) | `number` | `0` | no |
| ipv6\_addresses | List of IPv6 addresses from the range of the subnet to associate with the primary network interface | `list(string)` | `[]` | no |
| kms\_key\_id | KMS key ID used to encrypt EBS volume. When specifying kms\_key\_id, ebs\_volume\_encrypted needs to be set to true | `string` | `null` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`. <br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation). <br>Default value: `lower`. | `string` | `null` | no |
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

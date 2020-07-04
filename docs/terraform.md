## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 2.0 |
| null | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| null | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_ips\_count | Count of additional EIPs | `number` | `0` | no |
| allowed\_ports | List of allowed ingress ports | `list(number)` | `[]` | no |
| ami | The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04 | `string` | `""` | no |
| ami\_owner | Owner of the given AMI (ignored if `ami` unset) | `string` | `""` | no |
| applying\_period | The period in seconds over which the specified statistic is applied | `number` | `60` | no |
| assign\_eip\_address | Assign an Elastic IP address to the instance | `bool` | `true` | no |
| associate\_public\_ip\_address | Associate a public IP address with the instance | `bool` | `true` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| availability\_zone | Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region | `string` | `""` | no |
| comparison\_operator | The arithmetic operation to use when comparing the specified Statistic and Threshold. Possible values are: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold. | `string` | `"GreaterThanOrEqualToThreshold"` | no |
| create\_default\_security\_group | Create default Security Group with only Egress traffic allowed | `bool` | `true` | no |
| default\_alarm\_action | Default alerm action | `string` | `"action/actions/AWS_EC2.InstanceId.Reboot/1.0"` | no |
| delete\_on\_termination | Whether the volume should be destroyed on instance termination | `bool` | `true` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | `string` | `"-"` | no |
| disable\_api\_termination | Enable EC2 Instance Termination Protection | `bool` | `false` | no |
| ebs\_device\_name | Name of the EBS device to mount | `list(string)` | <pre>[<br>  "/dev/xvdb",<br>  "/dev/xvdc",<br>  "/dev/xvdd",<br>  "/dev/xvde",<br>  "/dev/xvdf",<br>  "/dev/xvdg",<br>  "/dev/xvdh",<br>  "/dev/xvdi",<br>  "/dev/xvdj",<br>  "/dev/xvdk",<br>  "/dev/xvdl",<br>  "/dev/xvdm",<br>  "/dev/xvdn",<br>  "/dev/xvdo",<br>  "/dev/xvdp",<br>  "/dev/xvdq",<br>  "/dev/xvdr",<br>  "/dev/xvds",<br>  "/dev/xvdt",<br>  "/dev/xvdu",<br>  "/dev/xvdv",<br>  "/dev/xvdw",<br>  "/dev/xvdx",<br>  "/dev/xvdy",<br>  "/dev/xvdz"<br>]</pre> | no |
| ebs\_iops | Amount of provisioned IOPS. This must be set with a volume\_type of io1 | `number` | `0` | no |
| ebs\_optimized | Launched EC2 instance will be EBS-optimized | `bool` | `false` | no |
| ebs\_volume\_count | Count of EBS volumes that will be attached to the instance | `number` | `0` | no |
| ebs\_volume\_size | Size of the EBS volume in gigabytes | `number` | `10` | no |
| ebs\_volume\_type | The type of EBS volume. Can be standard, gp2 or io1 | `string` | `"gp2"` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| evaluation\_periods | The number of periods over which data is compared to the specified threshold. | `number` | `5` | no |
| instance\_enabled | Flag to control the instance creation. Set to false if it is necessary to skip instance creation | `bool` | `true` | no |
| instance\_profile | A pre-defined profile to attach to the instance (default is to build our own) | `string` | `""` | no |
| instance\_type | The type of the instance | `string` | `"t2.micro"` | no |
| ipv6\_address\_count | Number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet (-1 to use subnet default) | `number` | `0` | no |
| ipv6\_addresses | List of IPv6 addresses from the range of the subnet to associate with the primary network interface | `list(string)` | `[]` | no |
| metric\_name | The name for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html | `string` | `"StatusCheckFailed_Instance"` | no |
| metric\_namespace | The namespace for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html | `string` | `"AWS/EC2"` | no |
| metric\_threshold | The value against which the specified statistic is compared | `number` | `1` | no |
| monitoring | Launched EC2 instance will have detailed monitoring enabled | `bool` | `true` | no |
| name | Name  (e.g. `bastion` or `db`) | `string` | n/a | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | `string` | `""` | no |
| permissions\_boundary\_arn | Policy ARN to attach to instance role as a permissions boundary | `string` | `""` | no |
| private\_ip | Private IP address to associate with the instance in the VPC | `string` | `""` | no |
| region | AWS Region the instance is launched in | `string` | `""` | no |
| root\_iops | Amount of provisioned IOPS. This must be set if root\_volume\_type is set to `io1` | `number` | `0` | no |
| root\_volume\_size | Size of the root volume in gigabytes | `number` | `10` | no |
| root\_volume\_type | Type of root volume. Can be standard, gp2 or io1 | `string` | `"gp2"` | no |
| security\_groups | List of Security Group IDs allowed to connect to the instance | `list(string)` | `[]` | no |
| source\_dest\_check | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs | `bool` | `true` | no |
| ssh\_key\_pair | SSH key pair to be provisioned on the instance | `string` | n/a | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging` | `string` | `""` | no |
| statistic\_level | The statistic to apply to the alarm's associated metric. Allowed values are: SampleCount, Average, Sum, Minimum, Maximum | `string` | `"Maximum"` | no |
| subnet | VPC Subnet ID the instance is launched in | `string` | n/a | yes |
| tags | Additional tags | `map(string)` | `{}` | no |
| user\_data | Instance user data. Do not pass gzip-compressed data via this argument | `string` | `""` | no |
| vpc\_id | The ID of the VPC that the instance security group belongs to | `string` | n/a | yes |
| welcome\_message | Welcome message | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_eni\_ids | Map of ENI to EIP |
| alarm | CloudWatch Alarm ID |
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


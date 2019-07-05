## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_ips_count | Count of additional EIPs | number | `0` | no |
| allowed_ports | List of allowed ingress ports | list(number) | `<list>` | no |
| ami | The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04 | string | `` | no |
| ami_owner | Owner of the given AMI (ignored if `ami` unset) | string | `` | no |
| applying_period | The period in seconds over which the specified statistic is applied | number | `60` | no |
| assign_eip_address | Assign an Elastic IP address to the instance | bool | `true` | no |
| associate_public_ip_address | Associate a public IP address with the instance | bool | `true` | no |
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| availability_zone | Availability Zone the instance is launched in. If not set, will be launched in the first AZ of the region | string | `` | no |
| comparison_operator | The arithmetic operation to use when comparing the specified Statistic and Threshold. Possible values are: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold. | string | `GreaterThanOrEqualToThreshold` | no |
| create_default_security_group | Create default Security Group with only Egress traffic allowed | bool | `true` | no |
| default_alarm_action | Default alerm action | string | `action/actions/AWS_EC2.InstanceId.Reboot/1.0` | no |
| delete_on_termination | Whether the volume should be destroyed on instance termination | bool | `true` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| disable_api_termination | Enable EC2 Instance Termination Protection | bool | `false` | no |
| ebs_device_name | Name of the EBS device to mount | list(string) | `<list>` | no |
| ebs_iops | Amount of provisioned IOPS. This must be set with a volume_type of io1 | number | `0` | no |
| ebs_optimized | Launched EC2 instance will be EBS-optimized | bool | `false` | no |
| ebs_volume_count | Count of EBS volumes that will be attached to the instance | number | `0` | no |
| ebs_volume_size | Size of the EBS volume in gigabytes | number | `10` | no |
| ebs_volume_type | The type of EBS volume. Can be standard, gp2 or io1 | string | `gp2` | no |
| evaluation_periods | The number of periods over which data is compared to the specified threshold. | number | `5` | no |
| instance_enabled | Flag to control the instance creation. Set to false if it is necessary to skip instance creation | bool | `true` | no |
| instance_type | The type of the instance | string | `t2.micro` | no |
| ipv6_address_count | Number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet | number | `0` | no |
| ipv6_addresses | List of IPv6 addresses from the range of the subnet to associate with the primary network interface | list(string) | `<list>` | no |
| metric_name | The name for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ec2-metricscollected.html | string | `StatusCheckFailed_Instance` | no |
| metric_namespace | The namespace for the alarm's associated metric. Allowed values can be found in https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html | string | `AWS/EC2` | no |
| metric_threshold | The value against which the specified statistic is compared | number | `1` | no |
| monitoring | Launched EC2 instance will have detailed monitoring enabled | bool | `true` | no |
| name | Name  (e.g. `bastion` or `db`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | `` | no |
| private_ip | Private IP address to associate with the instance in the VPC | string | `` | no |
| region | AWS Region the instance is launched in | string | `` | no |
| root_iops | Amount of provisioned IOPS. This must be set if root_volume_type is set to `io1` | number | `0` | no |
| root_volume_size | Size of the root volume in gigabytes | number | `10` | no |
| root_volume_type | Type of root volume. Can be standard, gp2 or io1 | string | `gp2` | no |
| security_groups | List of Security Group IDs allowed to connect to the instance | list(string) | `<list>` | no |
| source_dest_check | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs | bool | `true` | no |
| ssh_key_pair | SSH key pair to be provisioned on the instance | string | - | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging` | string | `` | no |
| statistic_level | The statistic to apply to the alarm's associated metric. Allowed values are: SampleCount, Average, Sum, Minimum, Maximum | string | `Maximum` | no |
| subnet | VPC Subnet ID the instance is launched in | string | - | yes |
| tags | Additional tags | map(string) | `<map>` | no |
| user_data | Instance user data. Do not pass gzip-compressed data via this argument | string | `` | no |
| vpc_id | The ID of the VPC that the instance security group belongs to | string | - | yes |
| welcome_message | Welcome message | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional_eni_ids | Map of ENI to EIP |
| alarm | CloudWatch Alarm ID |
| ebs_ids | IDs of EBSs |
| id | Disambiguated ID of the instance |
| primary_network_interface_id | ID of the instance's primary network interface |
| private_dns | Private DNS of instance |
| private_ip | Private IP of instance |
| public_dns | Public DNS of instance (or DNS of EIP) |
| public_ip | Public IP of instance (or EIP) |
| role | Name of AWS IAM Role associated with the instance |
| security_group_ids | IDs on the AWS Security Groups associated with the instance |
| ssh_key_pair | Name of the SSH key pair provisioned on the instance |


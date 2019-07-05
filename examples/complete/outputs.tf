output "key_name" {
  value       = module.aws_key_pair.key_name
  description = "Name of SSH key"
}

output "public_key" {
  value       = module.aws_key_pair.public_key
  description = "Content of the generated public key"
}

output "public_key_filename" {
  description = "Public Key Filename"
  value       = module.aws_key_pair.public_key_filename
}

output "private_key_filename" {
  description = "Private Key Filename"
  value       = module.aws_key_pair.private_key_filename
}

output "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  value       = module.subnets.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  value       = module.subnets.private_subnet_cidrs
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr_block
}

output "public_ip" {
  description = "Public IP of instance (or EIP)"
  value       = module.ec2_instance.public_ip
}

output "private_ip" {
  description = "Private IP of instance"
  value       = module.ec2_instance.private_ip
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = module.ec2_instance.private_dns
}

output "public_dns" {
  description = "Public DNS of instance (or DNS of EIP)"
  value       = module.ec2_instance.public_dns
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = module.ec2_instance.id
}

output "ssh_key_pair" {
  description = "Name of the SSH key pair provisioned on the instance"
  value       = module.ec2_instance.ssh_key_pair
}

output "security_group_ids" {
  description = "IDs on the AWS Security Groups associated with the instance"
  value       = module.ec2_instance.security_group_ids
}

output "role" {
  description = "Name of AWS IAM Role associated with the instance"
  value       = module.ec2_instance.role
}

output "additional_eni_ids" {
  description = "Map of ENI to EIP"
  value       = module.ec2_instance.additional_eni_ids
}

output "ebs_ids" {
  description = "IDs of EBSs"
  value       = module.ec2_instance.ebs_ids
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface"
  value       = module.ec2_instance.primary_network_interface_id
}

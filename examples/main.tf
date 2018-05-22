data "aws_region" "default" {}

data "aws_subnet" "default" {
  id = "${data.aws_subnet_ids.all.ids[0]}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

provider "aws" {
  region = "us-east-1"
}

module "zero_servers" {
  source = "../"

  instance_count = "0"

  namespace = "cp"
  stage     = "prod"
  name      = "zero"

  create_default_security_group = "true"
  region                        = "${data.aws_region.default.name}"
  availability_zone             = "${data.aws_subnet.default.availability_zone}"
  subnet                        = "${data.aws_subnet.default.id}"
  vpc_id                        = "${data.aws_vpc.default.id}"
  generate_ssh_key_pair         = "true"
}

module "one_server" {
  source = "../"

  instance_count = "1"

  namespace = "cp"
  stage     = "prod"
  name      = "one"

  create_default_security_group = "true"
  region                        = "${data.aws_region.default.name}"
  availability_zone             = "${data.aws_subnet.default.availability_zone}"
  subnet                        = "${data.aws_subnet.default.id}"
  vpc_id                        = "${data.aws_vpc.default.id}"
  additional_ips_count          = "1"
  generate_ssh_key_pair         = "true"
  instance_type                 = "m1.large"                                     // Allows up to 3 ENI, the default t2.micro allows only 1
}

module "two_servers" {
  source = "../"

  instance_count = "2"

  namespace = "cp"
  stage     = "prod"
  name      = "two"

  create_default_security_group = "true"
  region                        = "${data.aws_region.default.name}"
  availability_zone             = "${data.aws_subnet.default.availability_zone}"
  subnet                        = "${data.aws_subnet.default.id}"
  vpc_id                        = "${data.aws_vpc.default.id}"
  additional_ips_count          = "1"
  generate_ssh_key_pair         = "true"
  instance_type                 = "m1.large"                                     // Allows up to 3 ENI, the default t2.micro allows only 1
}

output "public_dns" {
  value = {
    zero = "${module.zero_servers.public_dns}"
    one  = "${module.one_server.public_dns}"
    two  = "${module.two_servers.public_dns}"
  }
}

output "instance_count" {
  value = {
    zero = "${module.zero_servers.instance_count}"
    one  = "${module.one_server.instance_count}"
    two  = "${module.two_servers.instance_count}"
  }
}

output "eips_per_instance" {
  value = {
    zero = "${module.zero_servers.eips_per_instance}"
    one  = "${module.one_server.eips_per_instance}"
    two  = "${module.two_servers.eips_per_instance}"
  }
}

output "private_ips" {
  value = {
    zero = "${module.zero_servers.private_ip}"
    one  = "${module.one_server.private_ip}"
    two  = "${module.two_servers.private_ip}"
  }
}

output "private_dns" {
  value = {
    zero = "${module.zero_servers.private_dns}"
    one  = "${module.one_server.private_dns}"
    two  = "${module.two_servers.private_dns}"
  }
}

output "aws_key_pair_name" {
  value = {
    zero = "${module.zero_servers.aws_key_pair_name}"
    one  = "${module.one_server.aws_key_pair_name}"
    two  = "${module.two_servers.aws_key_pair_name}"
  }
}

output "alarm" {
  value = {
    zero = "${module.zero_servers.alarm}"
    one  = "${module.one_server.alarm}"
    two  = "${module.two_servers.alarm}"
  }
}

output "ssh_key_pem_path" {
  value = {
    zero = "${module.zero_servers.ssh_key_pem_path}"
    one  = "${module.one_server.ssh_key_pem_path}"
    two  = "${module.two_servers.ssh_key_pem_path}"
  }
}

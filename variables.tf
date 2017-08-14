variable "ssh_key_pair" {}

variable "github_api_token" {}

variable "github_organization" {}

variable "github_team" {}

variable "playbook" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_id" {}

variable "security_groups" {
  type = "list"
}

variable "subnets" {
  type = "list"
}

variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "admin"
}

variable "ec2_ami" {
  default = "ami-cd0f5cb6"
}

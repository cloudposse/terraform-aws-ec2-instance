variable "ssh_key_pair" {}

variable "github_api_token" {}

variable "github_organization" {}

variable "github_team" {}

variable "ansible_playbook" {
  default = ""
}

variable "associate_public_ip_address" {
  default = "true"
}

variable "ansible_arguments" {
  type = "list"
}

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

variable "user_data" {
  type    = "list"
  default = []
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "welcome_message" {
  default = ""
}

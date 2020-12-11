enabled = true

region = "us-east-2"

namespace = "eg"

stage = "test"

name = "ec2-instance"

availability_zones = ["us-east-2a", "us-east-2b"]

assign_eip_address = false

associate_public_ip_address = true

instance_type = "t3.micro"

allowed_ports = [22, 80, 443]

ssh_public_key_path = "/secrets"

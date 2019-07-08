region = "us-west-1"

namespace = "eg"

stage = "test"

name = "ec2-instance"

availability_zones = ["us-west-1b", "us-west-1c"]

assign_eip_address = false

associate_public_ip_address = true

instance_type = "t2.micro"

allowed_ports = [22, 80, 443]

ssh_public_key_path = "/secrets"

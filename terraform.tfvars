region = "us-east-1"

environment = "dev"

application_name = "test_app"
container_name = "test_app"
container_port = 5000
image_url = "jpolara2016/test_app:latest"

vpc_cidr = "10.0.0.0/16"
public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]

public_subnet_count = 2
private_subnet_count = 2

asg_min = 1
asg_max = 2
asg_desired = 1
service_desired = 1

key_name = "test_app"
instance_type = "t2.medium"
aws_ami = "ami-093400f992dcccd75"

scheduling_strategy = "DAEMON"
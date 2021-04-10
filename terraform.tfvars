# Specify environment
environment = "dev"

# Application details, such as name, container name, port and image url
application_name = "test-app"
container_name = "test-app"
container_port = 5000
image_url = "jpolara2016/test_app:latest"

# VPC CIDR range
vpc_cidr = "10.0.0.0/16"

# Public/Private CIDR range
public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]

# AWS region
region = "us-east-1"

# Make sure you specify AZ accordinly based on Subnets
availability_zones = ["us-east-1a", "us-east-1b"]

# Add your local ipv4 for SSH access
my_ipv4 = ["97.102.162.197/32"]

# Destination IP for outside world
destination_ip = ["0.0.0.0/0"]

# Auto Scaling Capacity
asg_min = 1
asg_max = 2
asg_desired = 2

# For Auto Scaling Configuration
key_name = "test_app"
instance_type = "t2.medium"
aws_ami = "ami-093400f992dcccd75"

# Bid Spot instance price, keep in mind this is hourly charge
spot_price = 0.020

# Define # of Task your ECS service will manage
service_desired = 2

# Scheduling strategy to use for the service
scheduling_strategy = "REPLICA" # or DEAMON

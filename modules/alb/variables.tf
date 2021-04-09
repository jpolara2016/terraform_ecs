variable "environment" {}

variable "application_name" {
    description = "Give a nice application name e.g. test_app"
}

variable "asg_min" {
    description = "Minimum Capacity"
}

variable "asg_max" {
    default = "Maximum Capacity"
}

variable "asg_desired" {
    description = "Desired Capacity" 
}

variable "vpc_id" {}
variable "private_subnets" {}
variable "public_subnets" {}

variable "region" {}
variable "key_name" {}
variable "instance_type" {}
variable "aws_ecs_cluster" {}
variable "aws_cloudwatch_log_group_ecs" {}
variable "aws_iam_instance_profile" {}

variable "aws_ami" {}

variable "spot_price" {
    description = "Bid Spot instance price" 
}

variable "my_ipv4" {
    description = "Your local ipv4" 
}

variable "destination_ip" {
    description = "Destination IP / for outside world" 
}
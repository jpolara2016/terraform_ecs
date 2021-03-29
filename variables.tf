variable "region" {
    description = "specify region"
}

variable "aws_profile" {
     default = "default"
}

variable "environment" {
    description = "dev, prod etc" 
}

variable "application_name" {
    description = "Give a nice application name e.g. test_app"
}

variable "container_name" {
  description = "Docker Container name e.g. test_app"
}

variable "container_port" {
  description = "Port number of the container e.g. test_app"
}

variable "image_url" {
  description = "Docker Image erl e.g. jpolara2016/test_app:latest"
}

variable "vpc_cidr" {
    description = "cidr range"
}

variable "public_subnets_cidr" {
    description = "public range"
}

variable "private_subnets_cidr" {
    description = "private range"
}

variable "availability_zones" {
    description = "az"
}

variable "public_subnet_count" {
}

variable "private_subnet_count" {
}

variable "service_desired" {
  description = "Number of services you want to run"
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

variable "key_name" {}
variable "instance_type" {}
variable "aws_ami" {}

variable "scheduling_strategy" {
    description = "service type 1) REPLICA 2) DAEMON"
}
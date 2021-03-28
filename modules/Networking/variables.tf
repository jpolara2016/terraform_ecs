variable "region" {
    description = "specify region"
}

variable "environment" {
    description = "dev, prod etc" 
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
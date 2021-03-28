variable "region" {}

variable "application_name" {
    description = "Give a nice application name e.g. test_app"
}

variable "image_url" {
  description = "Docker Image erl e.g. jpolara2016/test_app:latest"
}

variable "container_name" {
  description = "Docker Container name e.g. test_app"
}

variable "aws_cloudwatch_log_group_app" {
  description = "cloudwatch log group for app logs"
}
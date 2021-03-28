output "aws_alb" {
    value = "Now paste this URL in the browser : ${module.alb.aws_alb}:${var.container_port}"
}
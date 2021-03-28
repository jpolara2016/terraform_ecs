output "aws_alb_target_group" {
    value = aws_alb_target_group.test.arn
}

output "aws_alb" {
    value = aws_alb.main.dns_name
}
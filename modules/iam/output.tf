output "aws_cloudwatch_log_group_app" {
  value = aws_cloudwatch_log_group.app.name
}

output "aws_cloudwatch_log_group_ecs" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "ecs_service_role" {
  value = aws_iam_role.ecs_service.name
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.app.name
}
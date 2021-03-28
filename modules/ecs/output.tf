output "aws_ecs_cluster" {
    value = aws_ecs_cluster.main.name
}

output "aws_ecs_task_definition" {
    value = aws_ecs_task_definition.ghost.arn
}
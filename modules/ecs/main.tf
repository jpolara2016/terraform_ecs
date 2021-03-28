/* Create ECS Cluster */
resource "aws_ecs_cluster" "main" {
  name = "${var.application_name}_ecs_cluster"
}

/* Create Task Desinition */
data "template_file" "task_definition" {
  template = file("${path.module}/task-definition.json")

  vars = {
    image_url        = var.image_url
    container_name   = var.application_name
    log_group_region = var.region
    log_group_name   = var.aws_cloudwatch_log_group_app
  }
}

resource "aws_ecs_task_definition" "ghost" {
  family                = "${var.application_name}_td"
  container_definitions = data.template_file.task_definition.rendered
}

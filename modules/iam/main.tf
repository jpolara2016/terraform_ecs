/* Create IAM role for ECS */
resource "aws_iam_role" "ecs_service" {
  name = "${var.application_name}_ecs_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

/* Create Role Policy for ECS */
resource "aws_iam_role_policy" "ecs_service" {
  name = "${var.application_name}_ecs_policy"
  role = aws_iam_role.ecs_service.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

/* Create IAM role for ECS */
resource "aws_iam_role" "app_instance" {
  name = "${var.application_name}-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

/* Create Instance Role for Instance */
resource "aws_iam_instance_profile" "app" {
  name = "${var.application_name}-ecs-instprofile"
  role = aws_iam_role.app_instance.name
}

data "template_file" "instance_profile" {
  template = file("${path.module}/instance-profile-policy.json")

  vars = {
    app_log_group_arn = aws_cloudwatch_log_group.app.arn
    ecs_log_group_arn = aws_cloudwatch_log_group.ecs.arn
  }
}

/* Attach Policy */
resource "aws_iam_role_policy" "instance" {
  name   = "${var.application_name}-EcsExampleInstanceRole"
  role   = aws_iam_role.app_instance.name
  policy = data.template_file.instance_profile.rendered
}

/* Create CloudWatch Logs Groups */
resource "aws_cloudwatch_log_group" "ecs" {
  name = "tf-ecs-group/ecs-agent"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "tf-ecs-group/app-ghost"
}
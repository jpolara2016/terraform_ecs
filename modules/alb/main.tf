/* Create Security Group for ALB */
resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = var.vpc_id

  # allow ingress
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = var.my_ipv4
  }
  
    ingress {
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = var.destination_ip
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.destination_ip
  }

  tags = {
    Environment = var.environment
  }
}

/* Create Security Group for Auto Scaling/Instances */
resource "aws_security_group" "asg" {
  name        = "${var.environment}-asg-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = var.vpc_id

  # allow ingress
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = var.my_ipv4
  }

  ingress {
    from_port         = 0
    to_port           = 65535
    protocol          = "tcp"
    security_groups = [aws_security_group.alb.id] 
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.destination_ip
  }

  tags = {
    Environment = var.environment
  }
}

/* Create Target Group for ALB */
resource "aws_alb_target_group" "test" {
  name     = "${var.application_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

/* Create ALB */
resource "aws_alb" "main" {
  name            = "${var.application_name}-alb"
  subnets         = var.public_subnets
  security_groups = [aws_security_group.alb.id]
}

/* Create ALB Listner : 80 */
resource "aws_alb_listener" "front_end_80" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.test.id
    type             = "forward"
  }
}

/* Create Autoscaling Group */
resource "aws_autoscaling_group" "app" {
  name                 = "${var.application_name}_asg"
  vpc_zone_identifier  = var.private_subnets
  min_size             = var.asg_min
  max_size             = var.asg_max
  desired_capacity     = var.asg_desired
  launch_configuration = aws_launch_configuration.app.name

  tag {
    key                 = "Name"
    value               = "${var.application_name}_ecs"
    propagate_at_launch = "true"
  }

}

/* Look for ECS optimised AMI if not specified */
data "aws_ami" "stable_coreos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

/* Pass Userdata While Instance Booting */
data "template_file" "cloud_config" {
  template = file("${path.module}/cloud-config.sh")

  vars = {
    aws_region         = var.region
    ecs_cluster_name   = var.aws_ecs_cluster
    ecs_log_level      = "info"
    ecs_agent_version  = "latest"
    ecs_log_group_name = var.aws_cloudwatch_log_group_ecs
  }
}

/* Create Launch Confifuration for AutoScaling */
resource "aws_launch_configuration" "app" {
  security_groups = [aws_security_group.asg.id]

  key_name                    = var.key_name
  image_id                    = var.aws_ami != "" ? var.aws_ami : data.aws_ami.stable_coreos.id  #ami-093400f992dcccd75
  instance_type               = var.instance_type
  spot_price                  = var.spot_price
  iam_instance_profile        = var.aws_iam_instance_profile
  user_data                   = data.template_file.cloud_config.rendered
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}



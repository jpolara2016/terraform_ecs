/* Provider */
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

/* Networking Module to create VPC, Subnets, IG, NAT Gateway, Route Tables etc */
module "networking" {
  source = "./modules/networking"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
  public_subnet_count  = var.public_subnet_count
  private_subnet_count  = var.private_subnet_count
}

/* IAM Module to create Role, Policy, and all type access require for ECS cluster to work */
module "iam" {
  source = "./modules/iam"

  application_name = var.application_name
}

/* ECS Module to create ECS cluster & Task Definition */
module "ecs" {
  source = "./modules/ecs"

  region = var.region
  application_name = var.application_name
  container_name = var.container_name
  image_url = var.image_url
  aws_cloudwatch_log_group_app = module.iam.aws_cloudwatch_log_group_app

  depends_on = [module.networking]
}

/* ALB Module to create ALB, SG, Listner, Target Group, and Auto Scaling */
module "alb" {
  source = "./modules/alb"

  vpc_id = module.networking.vpc_id
  security_groups = [module.networking.security_groups]
  private_subnets = module.networking.private_subnet_id
  public_subnets  = module.networking.public_subnet_id
  application_name = var.application_name
  environment = var.environment
  asg_min = var.asg_min
  asg_max = var.asg_max
  region = var.region
  key_name = var.key_name
  asg_desired = var. asg_desired
  aws_ecs_cluster = module.ecs.aws_ecs_cluster
  aws_cloudwatch_log_group_ecs = module.iam.aws_cloudwatch_log_group_ecs
  aws_iam_instance_profile = module.iam.aws_iam_instance_profile
  instance_type = var.instance_type
  aws_ami = var.aws_ami

  depends_on = [module.ecs]
}

/* Manage Deployments/Tasks */
resource "aws_ecs_service" "test" {
  name            = "${var.application_name}_service"
  cluster         = module.ecs.aws_ecs_cluster #aws_ecs_cluster.main.id
  task_definition = module.ecs.aws_ecs_task_definition  #aws_ecs_task_definition.ghost.arn
  desired_count   = var.service_desired
  iam_role        = module.iam.ecs_service_role

  load_balancer {
    target_group_arn = module.alb.aws_alb_target_group
    container_name   = var.container_name
    container_port   = var.container_port
  }
  depends_on = [module.alb]
}
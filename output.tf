output "aws_alb" {
    value = "You have successfully deploy a Flask application on ECS service. This may take a while. Now paste this URL in the browser and keep patience : ${module.alb.aws_alb}"
}
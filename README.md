# ECS Cluster Using Terraform 
---------
I assume you have some knowledge about ECS as you are already here looking at my Github and trying to figure out how you can provision ECS cluster using Terraform. 

Let's get started. The script has different modules for Networking, IAM, Load Balancer(ALB) and ECS. You can launch ECS cluster in any region in AWS. If you would like to override any variable, you can define it in `terraform.tfvars` file.    

## `Architecture:`
---------
![ECS Architecture](images/ecs_diagram.png)    

## `Commands:`
---------
```bash
git clone https://github.com/jpolara2016/terraform_ecs.git
cd terraform_ecs
terraform init
terraform plan
terraform apply
```
  
---------

## `Features:`

* Isolated in a VPC
    * High-availability (Multi-AZ deployment)
      * Public Subnet (Internet access via IG)
      * Private Subnet (Internet access via NAT Gateway)
    * Route Table for each subnet
    * NAT Gateway in each public subnet
* Security
    * Security Groups for ALB and EC2
    * Application instances in private subnets
* Load Balancer (ALB)
    * Target Group
    * Listener
    * Auto-scaling
* Dynamic Port Mapping
* ECS Cluster
    * Task Definition
    * Service
    * Tasks
* Fault-tolerant architecture
    * Application update in 0 min downtime when you update ECS service
* Cost-effective
    * Use Spot instance with Auto Scaling to save $$$


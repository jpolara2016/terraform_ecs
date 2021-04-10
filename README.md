# ECS Cluster Using Terraform 

I assume you have some knowledge about ECS as you are already here looking at my Github and trying to figure out how you can provision ECS cluster using Terraform. 

Let's get started. The script has different modules for Networking, IAM, Load Balancer(ALB) and ECS. You can launch ECS cluster in any region in AWS. If you want to override any variable, you just have to define in `terraform.tfvars` file. 

### `Architecture`
![ECS Architecture](images/ecs_diagram.png)

### `Commands`

```bash
git clone https://github.com/jpolara2016/terraform_ecs.git
cd terraform_ecs
terraform init
terraform plan
terraform apply
```

- Once your cluster is up, it will have the following features:

* Isolated in a VPC
* High-availability (Multi-AZ deployment)
    * Public Subnet (Internet access via IG)
    * Private Subnet (Internet access via NAT Gateway)
* Route Table for each subnet
* Loadbalanced (ALB) & Auto-scaling
* Dynamic Port Mapping
* Fault-tolerant architecture
* ECS Cluster
    * Task Definition
    * Service
    * Tasks



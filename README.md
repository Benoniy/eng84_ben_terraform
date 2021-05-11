# Terrfarom and Benefits
* Orchestration Tool
* Made by HashiCorp


### Setup:
1. terraform.exe should be in PATH  
2. Create two environment variables:
    * AWS_ACCESS_KEY_ID - access key
    * AWS_SECRET_ACCESS_KEY - secret key


### Terraform commands
* `init` - Prepare your working directory for other commands (runs main.tf). 
* `validate` - Check whether the configuration is valid.  
* `plan` - Show changes required by the current configuration.  
* `apply` - Create or update infrastructure.  
* `destroy` - Destroy previously created infrastructure.  


### Terraform to launch ec2 with VPC, subnets, SG services of AWS
AMI id's:  
* app - `ami-0e54d0fc3adbf4d11`  
* db - `ami-094805cb688e716e3`  


1. Connect to AWS in main.tf:
   ```
   # Use the keyword "provider" to define what cloud service we will use:
   provider "aws" {
       region = "eu-west-1"
   }
   ```


2. Start and instance in the same file:  
   ```
   resource "aws_instance" "terraform_app" {
       ami = "ami-0e54d0fc3adbf4d11"
       instance_type = "t2.micro"
       associate_public_ip_address = true
       subnet_id = "subnet-0b96bde6482352562"
       security_groups = ["sg-00aa81fddf8fca6bc"]
       key_name = "eng84devops"
   
       tags = {
           Name = "eng84_ben_terraform_app"
       }
   }
   ```


### Infrastructure as code Software:
Configuration management:  
* Ansible
* 


Orchestration:  
* Terraform
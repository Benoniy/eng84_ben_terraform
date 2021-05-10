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


### Something else
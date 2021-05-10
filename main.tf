# Initialize Terraform

# Connect to and use AWS:


# Use the keyword "provider" to define what cloud service we will use:
provider "aws" {
    region = "eu-west-1"
}


# Creating a vpc

resource "aws_vpc" "eng84_ben_terraform_vpc"{
    cidr_block = "13.37.0.0/16"
    instance_tenacity = "default"

    tags = {
        Name = "eng_84_ben_terraform_vpc"
    }
}


# Launching an EC2 using our app ami
# The resource keyword is used to create instances
# Resource type followed by name

resource "aws_instance" "terraform_app" {
    ami = "ami-0e54d0fc3adbf4d11"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = "eng84devops"

    tags = {
        Name = "eng84_ben_terraform_app"
    }
}
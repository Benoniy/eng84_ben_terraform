# Initialize Terraform

# Connect to and use AWS:


# Use the keyword "provider" to define what cloud service we will use:
provider "aws" {
    region = "eu-west-1"
}

# Creating a vpc
resource "aws_vpc" "eng84_ben_terraform_vpc"{
    cidr_block = "13.37.0.0/16"

    tags = {
        Name = "eng_84_ben_terraform_vpc"
    }
}


# Create an internet gateway that attaches to our vpc
resource "aws_internet_gateway" "eng84_ben_terraform_igw" {
  vpc_id = aws_vpc.eng84_ben_terraform_vpc.id

  tags = {
    Name = "eng84_ben_terraform_igw"
  }
}

# Edit the main route table
resource "aws_default_route_table" "eng84_ben_terraform_rt" {
  default_route_table_id = aws_vpc.eng84_ben_terraform_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eng84_ben_terraform_igw.id
  }

  tags = {
    Name = "eng84_ben_terraform_rt"
  }
}

# Creating a subnet for out vpc
resource "aws_subnet" "eng84_ben_terraform_public_subnet"{
    vpc_id = aws_vpc.eng84_ben_terraform_vpc.id
    cidr_block = "13.37.1.0/24"


    tags = {
        Name = "eng84_ben_terraform_public_subnet"
    }
}

# Associate route table with subnet
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.eng84_ben_terraform_public_subnet.id
  route_table_id = aws_route_table.eng84_ben_terraform_rt.id
}

# Launching an EC2 using our app ami
# The resource keyword is used to create instances
# Resource type followed by name

resource "aws_instance" "terraform_app" {
    ami = "ami-0e54d0fc3adbf4d11"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = "eng84devops"
    subnet_id = aws_subnet.eng84_ben_terraform_public_subnet.id

    tags = {
        Name = "eng84_ben_terraform_app"
    }
}
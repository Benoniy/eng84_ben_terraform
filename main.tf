# Initialize Terraform
# Connect to and use AWS:

# Use the keyword "provider" to define what cloud service we will use:
provider "aws" {
    region = "eu-west-1"
}



# Creating a vpc
resource "aws_vpc" "terraform_vpc"{
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
    }
}
# Create an internet gateway that attaches to our vpc
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = var.igw_name
  }
}



# Edit the main route table
resource "aws_default_route_table" "terraform_rt_pub" {
  default_route_table_id = aws_vpc.terraform_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = {
    Name = var.pub_rt_name
  }
}
# Create Private route table
resource "aws_route_table" "terraform_rt_priv" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = var.priv_rt_name
  }
}



# Creating a few public for out vpc
resource "aws_subnet" "terraform_public_subnet"{
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = var.pub_cidr
    tags = {
        Name = var.pub_subnet_name
    }
}
resource "aws_subnet" "terraform_private_subnet"{
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = var.priv_cidr
    tags = {
        Name = var.priv_subnet_name
    }
}



# Associate route tables with subnets
resource "aws_route_table_association" "a1" {
  subnet_id = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_vpc.terraform_vpc.default_route_table_id
}
resource "aws_route_table_association" "a2" {
  subnet_id = aws_subnet.terraform_private_subnet.id
  route_table_id = aws_route_table.terraform_rt_priv.id
}



# Create security groups
resource "aws_security_group" "public_sec_group" {
  name = var.pub_sec_name
  description = "Public security group"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "my_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.public_sec_group.id
}
resource "aws_security_group_rule" "vpc_access" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.public_sec_group.id
}

resource "aws_security_group" "priv_sec_group" {
  name = var.priv_sec_name
  description = "Private security group"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port         = "22"
    to_port           = "22"
    protocol          = "tcp"
    cidr_blocks       = [var.my_ip]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "priv_vpc_access" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.pub_cidr]
  security_group_id = aws_security_group.priv_sec_group.id
}



# Launching an EC2 using our app ami
# The resource keyword is used to create instances
# Resource type followed by name
resource "aws_instance" "terraform_webapp" {
    ami = var.app_ami
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.key
    subnet_id = aws_subnet.terraform_public_subnet.id
    private_ip = var.webapp_ip
    security_groups = [aws_security_group.public_sec_group.id]

    tags = {
        Name = var.webapp_name
    }
}
resource "aws_instance" "terraform_db" {
    ami =  var.db_ami
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.key
    subnet_id = aws_subnet.terraform_private_subnet.id
    private_ip = var.db_ip
    security_groups = [aws_security_group.priv_sec_group.id]

    tags = {
        Name = var.db_name
    }
}
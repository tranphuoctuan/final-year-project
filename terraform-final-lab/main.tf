//create resource
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {

  region = "ap-southeast-1"
}
# // create VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
      "Name" = "VPC-WordPress"
    }  
}
// create IGW
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "IGW-wordPress"
    }  
}
// create subnet (2 public, 2 private)
locals {
  private = ["10.0.1.0/24", "10.0.2.0/24"]
  public =  ["10.0.3.0/24", "10.0.4.0/24"]
  zone =    ["ap-southeast-1a", "ap-southeast-1c"]
  name_public =    ["public_subnet_a", "public_subnet_c"]
  name_private =   ["private_subnet_a", "private_subnet_c"]

}
// public subnet
resource "aws_subnet" "public_subnet" { 
    count = length(local.public)
    vpc_id = aws_vpc.vpc.id
    cidr_block = local.public[count.index]
    map_public_ip_on_launch = true
    availability_zone = local.zone[count.index % length(local.zone)]
    tags = {
      Name = local.name_public[count.index]
    }
}
// private subnet
resource "aws_subnet" "private_subnet" {
    count = length(local.private)
    vpc_id = aws_vpc.vpc.id
    cidr_block = local.private[count.index]
    availability_zone = local.zone[count.index % length(local.zone)]
    tags = {
      Name = local.name_private[count.index]
    }
}
// create route table for public_subnet
resource "aws_route_table" "rtb_public" {
    vpc_id = aws_vpc.vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Rtb_public_subnet"
    }
}
// gan cac pubclic_subnet vao route_table public
resource "aws_route_table_association" "public_ass" {
    for_each = { for k, v in aws_subnet.public_subnet : k => v}
    subnet_id = each.value.id
    route_table_id = aws_route_table.rtb_public.id 
}


// security group for ec2 íntance nat+ bastion host
resource "aws_security_group" "sg_public" {
  name   = "sg_public_subnet"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "sg_public_subnet"
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["116.105.225.184/32", "14.236.9.8/32", "14.241.120.232/32"]
  }
   ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
// create  ENI for Nat instance
resource "aws_network_interface" "network_interface" {
    subnet_id = aws_subnet.public_subnet[0].id
    source_dest_check = false
    
    security_groups = [aws_security_group.sg_public.id]
    tags = {
      Name = "nat_instance_network_interface"
    }
  
}
// create Elastic IP for network_interface
resource "aws_eip" "eip" {
  network_border_group = "ap-southeast-1"
  tags = {
    Name = "eip_for_network_interface"
    
  }
}
// associate eip to network_interface
resource "aws_eip_association" "ass_eip" {
  network_interface_id = aws_network_interface.network_interface.id
  allocation_id = aws_eip.eip.id
}

  
 // create ec2, nat_instance, bastion host
resource "aws_instance" "ec2_pub" {
    # vpc_security_group_ids = [aws_security_group.sg_public.id]
    # iam_instance_profile = data.aws_iam_instance_profile.ecs_instance_profile.name
     ami = "ami-0f98860b8bc09bd5c"
  instance_type = "t3.nano"      
  tags = {
      Name = "Nat_instance_Bastion_host"
  }
  key_name = "tuankey"
  network_interface {
    network_interface_id = aws_network_interface.network_interface.id
    device_index = 0
  }
  user_data = "${file("user_data_for_nat_ec2_pub")}"
}
// create route table for private subnet to network_interface_nat_instane
resource "aws_route_table" "rtb_private" {
    vpc_id = aws_vpc.vpc.id
    route  {
        cidr_block = "0.0.0.0/0"
        network_interface_id = aws_network_interface.network_interface.id
    }
    tags = {
        Name = "Rtb_private_subnet"
    }
}
// gan cac private_subnet vao route_table private
resource "aws_route_table_association" "private_ass" {
    for_each = { for k, v in aws_subnet.private_subnet : k => v}
    subnet_id = each.value.id
    route_table_id = aws_route_table.rtb_private.id 
}
//create security group for ec2_private
resource "aws_security_group" "sg_ec2_pri" {
  name = "sg_private_subnet"
  description = "allows ssh from sg_public"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "SG_Private_subnet"
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
     ingress {
    from_port       = 80
    to_port         = 81
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


   ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

//# Trích xuất khóa công khai từ EC2 public instance
data "aws_key_pair" "ssh_my_keypair" {
  filter {
    name = "key-name"
    values = ["tuankey"]
  }
}
// tạo iam role gán cho ec2-ecs
data "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceRole"
  
}

// create ec2_private
resource "aws_instance" "ec2_pri" {
  vpc_security_group_ids = [aws_security_group.sg_ec2_pri.id]
  ami = "ami-05ca6e8f0e96437e4"
  instance_type = "t3.medium"

  key_name = data.aws_key_pair.ssh_my_keypair.key_name
  iam_instance_profile = data.aws_iam_instance_profile.ecs_instance_profile.name
  subnet_id = aws_subnet.private_subnet[0].id
  # security_groups = [aws_security_group.sg_ec2_pri.id]
  tags = {
    Name = "Ec2-Private-container"
    }
   user_data = "${file("user_data_for_ecs")}"
}



# // create VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
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

 // create ec2, nat_instance, bastion host
resource "aws_instance" "ec2_pub" {
    # vpc_security_group_ids = [aws_security_group.sg_public.id]
    # iam_instance_profile = data.aws_iam_instance_profile.ecs_instance_profile.name
  ami = var.ami_ec2_nat
  instance_type = var.type_ec2_nat  
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
// create ec2_private
resource "aws_instance" "ec2_pri" {
  vpc_security_group_ids = [aws_security_group.sg_ec2_pri.id]
  ami = var.ami_ec2_ecs
  instance_type = var.type_ec2_ecs

  key_name = data.aws_key_pair.ssh_my_keypair.key_name
  iam_instance_profile = data.aws_iam_instance_profile.ecs_instance_profile.name
  subnet_id = aws_subnet.private_subnet[0].id
  # security_groups = [aws_security_group.sg_ec2_pri.id]
  tags = {
    Name = "Ec2-Private-container"
    }
   user_data = "${file("user_data_for_ecs")}"
}



// create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "VPC-WordPress"
  }
}
// create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.igw
  }
}

// public subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.sub_pub_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.sub_pub_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.zone_pub[count.index % length(var.zone_pub)]
  tags = {
    Name = "${var.name_pub[count.index]}-final_lab"
  }
}
// private subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.sub_pri_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.sub_pri_cidr[count.index]
  availability_zone = var.zone_pri[count.index % length(var.zone_pri)]
  tags = {
    Name = "${var.name_pri[count.index]}-final_lab"
  }
}
// create route table for public_subnet
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Rtb_public_subnet"
  }
}
// associate  pubclic_subnet into route_table public
resource "aws_route_table_association" "public_ass" {
  for_each       = { for k, v in aws_subnet.public_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rtb_public.id
}

// create ec2, nat_instance, bastion host
resource "aws_instance" "ec2_pub" {
  # vpc_security_group_ids = [aws_security_group.sg_public.id]
  # iam_instance_profile = data.aws_iam_instance_profile.ecs_instance_profile.name
  ami           = "${data.aws_ami.nat_bastion.id}"
  instance_type = var.type_ec2_nat
  tags = {
    Name = var.name_ec2_pub
  }
  key_name = var.key_ssh
  network_interface {
    network_interface_id = aws_network_interface.network_interface.id
    device_index         = 0
  }
  user_data = file("user_data_for_nat_ec2_pub")
   lifecycle {
    ignore_changes = [ 
      ami
     ]
  }
}
// create route table for private subnet to network_interface_nat_instane
resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.network_interface.id
  }
  tags = {
    Name = "Rtb_private_subnet"
  }
 
}
// associate private_subnet into route_table private
resource "aws_route_table_association" "private_ass" {
  for_each       = { for k, v in aws_subnet.private_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rtb_private.id
}
// create ec2_private
resource "aws_instance" "ec2_pri" {
  vpc_security_group_ids = [aws_security_group.sg_ec2_pri.id]
  ami                    = data.aws_ami.ecs.id
  instance_type          = var.type_ec2_ecs
  key_name               = data.aws_key_pair.ssh_my_keypair.key_name
  iam_instance_profile   = data.aws_iam_instance_profile.ecs_instance_profile.name
  subnet_id              = aws_subnet.private_subnet[0].id
  # security_groups = [aws_security_group.sg_ec2_pri.id]
  tags = {
    Name = var.name_ec2_pri
  }
  user_data = file("user_data_for_ecs")
  lifecycle {
    ignore_changes = [ 
      ami
     ]
  }
}


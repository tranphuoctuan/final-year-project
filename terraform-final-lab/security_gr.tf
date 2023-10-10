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
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.my_list_ip.id]
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
    # cidr_blocks = [data.aws_ec2_managed_prefix_list.my_list_ip]
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.my_list_ip.id]
  }
    ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    # cidr_blocks = [data.aws_ec2_managed_prefix_list.my_list_ip]
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.my_list_ip.id]
  }
     ingress {
    from_port       = 80
    to_port         = 81
    protocol        = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }


#    ingress {
#     from_port       = 443
#     to_port         = 443
#     protocol        = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
// create security group for rds
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.vpc.id
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
  
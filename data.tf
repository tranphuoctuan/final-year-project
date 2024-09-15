// data resourcr prefix-list
data "aws_ec2_managed_prefix_list" "my_list_ip" {
  filter {
    name   = "prefix-list-id"
    values = ["pl-0a31d951c465dd7e7"]
  }
}

// Trích xuất khóa công khai từ EC2 public instance
data "aws_key_pair" "ssh_my_keypair" {
  filter {
    name   = "key-name"
    values = ["tuankey"]
  }
}

// data resource  iam role gán cho ec2-ecs
data "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceRole"
}

// data resource iam role gán cho ec2-cloudwatch
data "aws_iam_role" "ec2_iam_cloudwatch_role" {
  name = "CloudWatch-monitoring-ec2"
  
}
// data resource iam_role_task_difinition
data "aws_iam_role" "role_ecs" {
  name = "ExecutionRole"
}

// data resource ACM
data "aws_acm_certificate" "acm" {
  domain   = "blog.tuantranlee.shop"
  statuses = ["ISSUED"]
}

// data resource route53_hosted_zone
data "aws_route53_zone" "hosted_zone" {
  name         = "tuantranlee.shop"
  private_zone = false

}
// data resource get newest AMI
data "aws_ami" "nat_bastion" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp3"]
  }
}
// data resource ami for ec2-ecs
data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-ecs*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "user_data_ecs" {
  template = file("${path.module}/templates/userdata-ecs.sh.tpl") 
}

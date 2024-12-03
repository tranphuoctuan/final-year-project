#!bin/sh

# Create terraform.tfvars file
touch backend.tfvars
touch terraform.tfvars 

## config file environment for BE init resource
echo 'region = "ap-southeast-1"' >> backend.tfvars
echo 'bucket = "final-project-year-prod-tfstate-zhixow-ap-southeast-1"' >> backend.tfvars
echo 'key = "terraform.tfstate"' >> backend.tfvars
echo 'dynamodb_table = "final-project-year-prod-tfstate"' >> backend.tfvars

## config file environment for Infra init resource
echo 'profile = "final-project-year"' >> terraform.tfvars
echo 'environment = "dev"' >> terraform.tfvars
echo 'region = "ap-southeast-1"' >> terraform.tfvars
echo 'type_ec2_nat = "t3.nano"' >> terraform.tfvars
echo 'type_ec2_ecs = "t3.medium"' >> terraform.tfvars

# Variables secret for RDS
# echo "user_rds = ${{ secrets.DEV_RDS_USER }}" >> terraform.tfvars
# echo "pass_rds = ${{ secrets.DEV_RDS_PASS }}" >> terraform.tfvars
# echo "db_rds = ${{ secrets.DEV_RDS_TABLE }}" >> terraform.tfvars
echo 'type_rds = "db.t3.micro"' >> terraform.tfvars
echo 'name_rds = "rds-final-project-year"' >> terraform.tfvars

echo 'name_acm = "blog.tuantranlee.shop"' >> terraform.tfvars
echo 'key_ssh = "tuankey"' >> terraform.tfvars

echo 'name_ec2_pub = "Nat_instance_Bastion_host"' >> terraform.tfvars
echo 'name_ec2_pri = "Ec2-Private-container"' >> terraform.tfvars
echo 'record_53 = "blog.tuantranlee.shop"' >> terraform.tfvars
echo 'eip = "eip-nat-bastion"' >> terraform.tfvars
echo 'igw = "IGW-final-project-year"' >> terraform.tfvars

# VPC Private subnet setting
echo 'sub_pri_cidr = ["10.0.1.0/24", "10.0.2.0/24"]' >> terraform.tfvars
echo 'zone_pri = ["ap-southeast-1a", "ap-southeast-1b"]' >> terraform.tfvars
echo 'name_pri = ["private-subnet-a", "private-subnet-b"]' >> terraform.tfvars

# VPC Public subnet setting
echo 'sub_pub_cidr = ["10.0.3.0/24", "10.0.4.0/24"]' >> terraform.tfvars
echo 'zone_pub = ["ap-southeast-1a", "ap-southeast-1b"]' >> terraform.tfvars
echo 'name_pub = ["public-subnet-a", "public-subnet-b"]' >> terraform.tfvars

echo 'image_phpmyadmin = "public.ecr.aws/bitnami/phpmyadmin:5.2.1"' >> terraform.tfvars
echo 'image_wordpress = "public.ecr.aws/bitnami/wordpress:latest"' >> terraform.tfvars

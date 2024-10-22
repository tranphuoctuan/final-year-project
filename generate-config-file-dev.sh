#!bin/sh

# Create terraform-prod.tfvars file

mkdir -p ../config  
touch ../config/terraform-prod.tfvars 


echo 'profile = final-project-year"' >> ../config/terraform-prod.tfvars
echo 'environment = "prod"' >> ../config/terraform-prod.tfvars
echo 'region = "ap-southeast-1"' >> ../config/terraform-prod.tfvars
echo 'type_ec2_nat = "t3.nano"' >> ../config/terraform-prod.tfvars
echo 'type_ec2_ecs = "t3.medium"' >> ../config/terraform-prod.tfvars

# Variables secret for RDS
echo "user_rds = ${SECRETS.DEV_RDS_USER}" >> ../config/terraform-prod.tfvars
echo "pass_rds = ${SECRETS.DEV_RDS_PASS}" >> ../config/terraform-prod.tfvars
echo "db_rds = ${SECRETS.DEV_RDS_TABLE}" >> ../config/terraform-prod.tfvars
echo 'type_rds = "db.t3.micro"' >> ../config/terraform-prod.tfvars
echo 'name_rds = "rds-final-intern"' >> ../config/terraform-prod.tfvars

echo 'name_acm = "blog.tuantranlee.shop"' >> ../config/terraform-prod.tfvars
echo 'key_ssh = "tuankey"' >> ../config/terraform-prod.tfvars

echo 'name_ec2_pub = "Nat_instance_Bastion_host"' >> ../config/terraform-prod.tfvars
echo 'name_ec2_pri = "Ec2-Private-container"' >> ../config/terraform-prod.tfvars
echo 'record_53 = "blog.tuantranlee.shop"' >> ../config/terraform-prod.tfvars
echo 'eip = "eip-nat-bastion"' >> ../config/terraform-prod.tfvars
echo 'igw = "IGW-final-project-year"' >> ../config/terraform-prod.tfvars

# VPC Private subnet setting
echo 'sub_pri_cidr = ["10.0.1.0/24", "10.0.2.0/24"]' >> ../config/terraform-prod.tfvars
echo 'zone_pri = ["ap-southeast-1a", "ap-southeast-1b"]' >> ../config/terraform-prod.tfvars
echo 'name_pri = ["private-subnet-a", "private-subnet-b"]' >> ../config/terraform-prod.tfvars

# VPC Public subnet setting
echo 'sub_pub_cidr = ["10.0.3.0/24", "10.0.4.0/24"]' >> ../config/terraform-prod.tfvars
echo 'zone_pub = ["ap-southeast-1a", "ap-southeast-1b"]' >> ../config/terraform-prod.tfvars
echo 'name_pub = ["public-subnet-a", "public-subnet-b"]' >> ../config/terraform-prod.tfvars

echo 'image_phpmyadmin = "public.ecr.aws/bitnami/phpmyadmin:5.2.1"' >> ../config/terraform-prod.tfvars
echo 'image_wordpress = "public.ecr.aws/bitnami/wordpress:latest"' >> ../config/terraform-prod.tfvars

variable "region" {
    type = string
    description = "region for vpc"
}
// 
variable "type_ec2_ecs" {
    type = string
    description = "Ec2 Type for ecs container"
}

variable "type_ec2_nat" {
    type = string
    description = "Type for ec2 nat bastion"
}
variable "ami_ec2_nat" {
    type = string
    description = "AMI for ec2 nat bastion"
}
variable "ami_ec2_ecs" {
    type = string
    description = "AMI for ec2 nat bastion"
}
# variable "number_public_subnet" {   
#     type = number
# }
# variable "number_private_subnet" {   
#     type = number
# }
variable "profile" {
    type = string
    description = "profile"
  
}
variable "env" {
    type = string
    description = "environment "
}
variable "user_rds" {
    type = string
    description = "username for RDS"
  
}
variable "pass_rds" {
    type = string
    description = "password for RDS"
}
variable "db_rds" {
    type = string
    description = "Database Name for RDS"
  
}
variable "type_rds" {
    type = string
    description = "DB instance class"
  
}
variable "name_acm" {
    type = string
    description = "domain_name for ACM"
  
}

variable "td_wp_db_pass" {
    type = string
    description = "PASSWORD database for task difinition WORDPRESS match with MYSQL"
  
}
variable "td_wp_db_user" {
    type = string
    description = "USER database for task difinition WORDPRESS match with MYSQL"
  
}
variable "td_wp_db_name" {
    type = string
    description = "Name database for task difinition WORDPRESS match with MYSQL"
  
}
variable "td_php_db_pass" {
    type = string
    description = "PASSWORD database for task difinition PHPMYADMIN match with MYSQL"
  
}
variable "td_php_db_user" {
    type = string
    description = "Name database for task difinition PHPMYADMIN match with MYSQL"
  
}


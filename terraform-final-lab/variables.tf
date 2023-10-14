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
variable "key_ssh" {
    type = string
    description = "name file key.pem ssh into ec2 "
  
}
variable "name_ec2_pub" {
    type = any
    description = "name for instance nat-bastion"
  
}
variable "name_ec2_pri" {
    type = any
    description = "name for instance ecs-container"
  
}
variable "name_rds" {
    type = string
    description = "Name RDS "
  
}
variable "record_53" {
    type = string 
    description = "Name record A for ALB"
  
}

variable "eip" {
    type = string
    description = "Name for EIP"
  
}
variable "igw" {
    type = string
    description = "Name IGW"
  
}
# variable "td_wp_db_pass" {
#     type = string
#     description = "PASSWORD database for task difinition WORDPRESS match with MYSQL"
  
# }
# variable "td_wp_db_user" {
#     type = string
#     description = "USER database for task difinition WORDPRESS match with MYSQL"
  
# }
# variable "td_wp_db_name" {
#     type = string
#     description = "Name database for task difinition WORDPRESS match with MYSQL"
  
# }
# variable "td_php_db_pass" {
#     type = string
#     description = "PASSWORD database for task difinition PHPMYADMIN match with MYSQL"
  
# }
# variable "td_php_db_user" {
#     type = string
#     description = "Name database for task difinition PHPMYADMIN match with MYSQL"
  
# }
###################################################

    ## CORE VPC ###
####################################################

// Private subnet

variable "sub_pri_cidr" {
    type = list(string)
    description = "CIDR block private subnet"
    
}
variable "zone_pri" {
    type = list(string)
    description = "availability_zone private subnet"
  
}
variable "name_pri" {
    type = list(string)
    description = "Name for subnet private"
  
}

// public subnet
variable "sub_pub_cidr" {
    type = list(string)
    description = "CIDR block public subnet"
    
}
variable "zone_pub" {
    type = list(string)
    description = "availability_zone public subnet"
  
}
variable "name_pub" {
    type = list(string)
    description = "Name for subnet public"
  
}


#   private = ["10.0.1.0/24", "10.0.2.0/24"]
#   public =  ["10.0.3.0/24", "10.0.4.0/24"]
#   zone =    ["ap-southeast-1a", "ap-southeast-1c"]
#   name_public =    ["public_subnet_a", "public_subnet_c"]
#   name_private =   ["private_subnet_a", "private_subnet_c"]
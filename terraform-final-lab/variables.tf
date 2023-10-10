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


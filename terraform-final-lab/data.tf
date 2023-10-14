// data resourcr prefix-list
data "aws_ec2_managed_prefix_list" "my_list_ip" {
  filter  {
    name =  "prefix-list-id"
    values = ["pl-0a31d951c465dd7e7"]
  }
#   id = "pl-0a31d951c465dd7e7"
#   name = "my-ip-public"
}
//# Trích xuất khóa công khai từ EC2 public instance
data "aws_key_pair" "ssh_my_keypair" {
  filter {
    name = "key-name"
    values = ["tuankey"]
  }
}
// data resource  iam role gán cho ec2-ecs
data "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceRole"
}
// data resource iam_role_task_difinition
data "aws_iam_role" "role_ecs" {
    name = "ExecutionRole"
}
// data resource ACM
data "aws_acm_certificate" "acm" {
    domain = "final-lab.tuantranlee.online"
    statuses = ["ISSUED"]
}
// data resource route53_hosted_zone
data "aws_route53_zone" "hosted_zone" {
   name = "tuantranlee.online"
   private_zone = false
   
}

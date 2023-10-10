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
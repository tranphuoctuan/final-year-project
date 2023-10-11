
// create cluster
resource "aws_ecs_cluster" "cluster" {
    name = "cluster-final"
}


// create task_difinition_wordpress
resource "aws_ecs_task_definition" "task_wp" {
    family = "task_wp"
    requires_compatibilities = ["EC2"]
    network_mode = "bridge"   
    cpu = 512
    memory = 1024 
    task_role_arn = data.aws_iam_role.role_ecs.arn
    execution_role_arn = data.aws_iam_role.role_ecs.arn
    runtime_platform {
      operating_system_family = "LINUX"
      cpu_architecture = "X86_64"
    }

    container_definitions = "${file("td_wp.json")}"
}
/// create task_definition_phpmyadmin
// create task_difinition_wordpress
resource "aws_ecs_task_definition" "task_phpmyadmin" {
    family = "task_php"
    requires_compatibilities = ["EC2"]
    network_mode = "bridge"   
    cpu = 512
    memory = 1024 
    task_role_arn = data.aws_iam_role.role_ecs.arn
    execution_role_arn = data.aws_iam_role.role_ecs.arn
    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture = "X86_64"
    }

    container_definitions = "${file("td_php.json")}"

}

// create ecs_services
// service for wordpress
resource "aws_ecs_service" "ser_wp" {
    name = "service_wp"
    cluster = aws_ecs_cluster.cluster.name
    launch_type = "EC2"
    task_definition = aws_ecs_task_definition.task_wp.arn
    desired_count = 1
}
// service for phpmyadmin
resource "aws_ecs_service" "ser_php" {
    name = "service_phpmyadmin"
    cluster = aws_ecs_cluster.cluster.name
    launch_type = "EC2"
    task_definition = aws_ecs_task_definition.task_phpmyadmin.arn
    desired_count = 1
    
}



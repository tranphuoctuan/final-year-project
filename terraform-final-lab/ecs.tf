
// create cluster
resource "aws_ecs_cluster" "cluster" {
    name = "cluster-final"
}
// create data iam_role_task_difinition
data "aws_iam_role" "role_ecs" {
    name = "ExecutionRole"
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

    container_definitions = <<TASK_DEFINITION
    [
        {
            "name": "wordpress",
            "image": "public.ecr.aws/bitnami/wordpress:latest",
            "cpu": 0,
            "portMappings": [
                {
                    "name": "wordpress-8080-tcp",
                    "containerPort": 8080,
                    "hostPort": 80,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [
                {
                    "name": "WORDPRESS_DATABASE_PASSWORD",
                    "value": "wordpress"
                },
                {
                    "name": "WORDPRESS_DATABASE_USER",
                    "value": "wordpress"
                },
                {
                    "name": "WORDPRESS_DATABASE_HOST",
                    "value": "${aws_db_instance.rds.address}"
                },
                {
                    "name": "WORDPRESS_DATABASE_PORT_NUMBER",
                    "value": "3306"
                },
                {
                    "name": "WORDPRESS_DATABASE_NAME",
                    "value": "wordpress"
                }
            
            ]
        }
    ]
    TASK_DEFINITION
    
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

    container_definitions = <<TASK_DEFINITION
    [
        {
            "name": "phpmyadmin",
            "image": "public.ecr.aws/bitnami/phpmyadmin:5.2.1",
            "cpu": 0,
            "portMappings": [
                {
                    "name": "phpmyadmin-8081-tcp",
                    "containerPort": 8080,
                    "hostPort": 81,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }
            ],
            "essential": true,
            "environment": [
               {
                    "name": "DATABASE_PASSWORD",
                    "value": "wordpress"
                },
                {
                    "name": "DATABASE_USER",
                    "value": "wordpress"
                },
                {
                    "name": "DATABASE_HOST",
                    "value": "${aws_db_instance.rds.address}"
                }
            ]
        }
        
    ]
    TASK_DEFINITION

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



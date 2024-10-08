
// create cluster
resource "aws_ecs_cluster" "cluster" {
  name = "cluster-final"
}
//create cloudwatch logs group for servies task wordpress
resource "aws_cloudwatch_log_group" "log_service_wp" {
  name = "ecs/services-wordpress"

}
resource "aws_cloudwatch_log_group" "log_service_php" {
  name = "ecs/services-phpmyadmin"

}


// create task_difinition_wordpress
resource "aws_ecs_task_definition" "task_wp" {
  family                   = "task_wp"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = data.aws_iam_role.role_ecs.arn
  execution_role_arn       = data.aws_iam_role.role_ecs.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = <<TASK_DEFINITION
        [
        {
            "name": "wordpress",
            "image": "${var.image_wordpress}",
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
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.log_service_wp.name}",
                    "awslogs-region": "ap-southeast-1",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "environment": [
                {
                    "name": "WORDPRESS_DATABASE_PASSWORD",
                    "value": "${aws_db_instance.rds.password}"
                },
                {
                    "name": "WORDPRESS_DATABASE_USER",
                    "value": "${aws_db_instance.rds.username}"
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
                    "value": "${aws_db_instance.rds.db_name}"
                }
            
            ]
        }
    ]
    TASK_DEFINITION
}

/// create task_definition_phpmyadmin
// create task_difinition_wordpress
resource "aws_ecs_task_definition" "task_phpmyadmin" {
  family                   = "task_php"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = 512
  memory                   = 1024
  task_role_arn            = data.aws_iam_role.role_ecs.arn
  execution_role_arn       = data.aws_iam_role.role_ecs.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = <<TASK_DEFINITION
        [
        {
    "name": "phpmyadmin",
    "image": "${var.image_phpmyadmin}",
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
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.log_service_php.name}",
                    "awslogs-region": "ap-southeast-1",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "environment": [
       {
              "name": "DATABASE_PASSWORD",
                "value": "${aws_db_instance.rds.password}"
              },
              {
              "name": "DATABASE_USER",
              "value": "${aws_db_instance.rds.username}"
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
  name            = "service_wp"
  cluster         = aws_ecs_cluster.cluster.name
  launch_type     = "EC2"
  task_definition = aws_ecs_task_definition.task_wp.arn
  desired_count   = 1
}
// service for phpmyadmin
resource "aws_ecs_service" "ser_php" {
  name            = "service_phpmyadmin"
  cluster         = aws_ecs_cluster.cluster.name
  launch_type     = "EC2"
  task_definition = aws_ecs_task_definition.task_phpmyadmin.arn
  desired_count   = 1
}




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

resource "aws_security_group" "sg_ecs_fargate" {
  name        = "sg_ecs_private_subnet"
  description = "allows ssh and ICMP from sg_public"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "SG_Private_subnet"
  }

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.sg_public.id]
  }

  # ingress {
  #   from_port = 22
  #   to_port   = 22
  #   protocol  = "tcp"
  #   # cidr_blocks = [data.aws_ec2_managed_prefix_list.my_list_ip]
  #   security_groups = [aws_security_group.sg_public.id]
  # }

  ingress {
    from_port       = 80
    to_port         = 444
    protocol        = "TCP"
    security_groups = [aws_security_group.sg_alb.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

// create task_difinition_wordpress
resource "aws_ecs_task_definition" "task_wp" {
  family                   = "task_wp"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
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
                    "containerPort": 80,
                    "hostPort":80,
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
resource "aws_ecs_task_definition" "task_phpmyadmin" {
  family                   = "task_php"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
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
            "containerPort": 81,
            "hostPort":81,
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

// create ecs_services for wordpress
resource "aws_ecs_service" "ser_wp" {
  name            = "service_wp"
  cluster         = aws_ecs_cluster.cluster.name
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task_wp.arn
  desired_count   = 1
  network_configuration {
    subnets         = [aws_subnet.private_subnet[0].id]
    security_groups = [aws_security_group.sg_ecs_fargate.id]
    assign_public_ip = false
  }
  enable_execute_command = true
  load_balancer {
    target_group_arn = aws_lb_target_group.tg_wp.arn
    container_name   = "wordpress"
    container_port   = 80
  }
}
// service for phpmyadmin
resource "aws_ecs_service" "ser_php" {
  name            = "service_phpmyadmin"
  cluster         = aws_ecs_cluster.cluster.name
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.task_phpmyadmin.arn
  desired_count   = 1

  network_configuration {
    subnets         = [aws_subnet.private_subnet[0].id]
    security_groups = [aws_security_group.sg_ecs_fargate.id]
    assign_public_ip = false
  }
  enable_execute_command = true
  load_balancer {
    target_group_arn = aws_lb_target_group.tg_php.arn
    container_name   = "phpmyadmin"
    container_port   = 81

  }
  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}



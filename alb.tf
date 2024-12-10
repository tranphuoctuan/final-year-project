// create target-group for wordpress listener port 80
resource "aws_lb_target_group" "tg_wp" {
  target_type = "instance"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.vpc.id
  name        = "tg-final-wp"
}
// create target-group for phpmyadmin listener port 81
resource "aws_lb_target_group" "tg_php" {
  target_type = "instance"
  protocol    = "HTTP"
  port        = 81
  vpc_id      = aws_vpc.vpc.id
  name        = "tg-final-php"
}

// attach ec2 to target-group_wp
resource "aws_lb_target_group_attachment" "att_wp" {
  target_group_arn = aws_lb_target_group.tg_wp.arn
  target_id        = aws_instance.ec2_pri.id

}
// attach ec2 to target-group_php
resource "aws_lb_target_group_attachment" "att_php" {
  target_group_arn = aws_lb_target_group.tg_php.arn
  target_id        = aws_instance.ec2_pri.id
}

// create ALB
resource "aws_lb" "alb" {
  load_balancer_type         = "application"
  name                       = "alb"
  internal                   = false
  security_groups            = [aws_security_group.sg_alb.id]
  subnets                    = [for subnet in aws_subnet.public_subnet : subnet.id]
  enable_deletion_protection = false
}

# ALB Listener on Port 443 for HTTPS
resource "aws_lb_listener" "listen_wp_443" {
  load_balancer_arn = aws_lb.alb.arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.alb_acm.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid request"
      status_code  = "404"
    }
  }
}

# Listener Rule for WordPress
resource "aws_lb_listener_rule" "rule_wp" {
  listener_arn = aws_lb_listener.listen_wp_443.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_wp.arn
  }
}

# # Listener Rule for phpMyAdmin
resource "aws_lb_listener_rule" "rule_php" {
  listener_arn = aws_lb_listener.listen_wp_443.arn
  priority     = 200

  condition {
    path_pattern {
      values = ["/phpmyadmin*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_php.arn
  }
}

# // create listener ALB 443: wordpress
# resource "aws_lb_listener" "listen_wp_443" {
#   load_balancer_arn = aws_lb.alb.arn
#   protocol          = "HTTPS"
#   port              = 443
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg_wp.arn
#   }
#   ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   certificate_arn = data.aws_acm_certificate.alb_acm.arn
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Invalid request"
#       status_code  = "404"
#     }
#   }
# }

// create target-group for wordpress listener port 80
resource "aws_lb_target_group" "tg_wp" {
    target_type = "instance"
    protocol = "HTTP"
    port = 80
    vpc_id = aws_vpc.vpc.id
    name = "tg-final-wp" 
}
// create target-group for phpmyadmin listener port 81
resource "aws_lb_target_group" "tg_php" {
    target_type = "instance"
    protocol = "HTTP"
    port = 81
    vpc_id = aws_vpc.vpc.id
    name = "tg-final-php" 
}

// attach ec2 to target-group_wp
resource "aws_lb_target_group_attachment" "att_wp" {
    target_group_arn =  aws_lb_target_group.tg_wp.arn
    target_id = aws_instance.ec2_pri.id

}
// attach ec2 to target-group_php
resource "aws_lb_target_group_attachment" "att_php" {
    target_group_arn =  aws_lb_target_group.tg_php.arn
    target_id = aws_instance.ec2_pri.id
}



// create ALB
resource "aws_lb" "alb" {
    load_balancer_type = "application"
    name = "alb"
    internal = false
    security_groups = [aws_security_group.sg_alb.id]
    subnets = [for subnet in aws_subnet.public_subnet :subnet.id]
    enable_deletion_protection = false
}
// create listener ALB 80: wordpress
resource "aws_lb_listener" "listen_wp_80" {
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTP"
    port = 80
    default_action {
        type = "redirect"
        redirect {
             port        = "443"
             protocol    = "HTTPS"
             status_code = "HTTP_301"
         }
    }
}
// create listener ALB for 81 : phpmyadmin
resource "aws_lb_listener" "listen_wp_81" {
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTP"
    port = 81
    default_action {
        type = "redirect"
        redirect {
             port        = "444"
             protocol    = "HTTPS"
             status_code = "HTTP_301"
         }
    }
}
// create listener ALB 443: wordpress
resource "aws_lb_listener" "listen_wp_443" {
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTPS"
    port = 443
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_wp.arn
    }
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    certificate_arn = aws_acm_certificate.acm.arn

}
// create listener ALB 444: phpmyadmin
resource "aws_lb_listener" "listen_wp_444" {
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTPS"
    port = 444
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_php.arn
    }
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    certificate_arn = aws_acm_certificate.acm.arn

}

// data resource route53_hosted_zone
data "aws_route53_zone" "hosted_zone" {
   name = "tuantranlee.online"
   private_zone = false
   
}

// associate alb endpoit to route3_record
resource "aws_route53_record" "record_53" {
    name = "final-lab.tuantranlee.online"
    zone_id = data.aws_route53_zone.hosted_zone.id
    type = "A"
    alias {
        name = aws_lb.alb.dns_name
        zone_id = aws_lb.alb.zone_id
        evaluate_target_health = true
      
    }

  
}
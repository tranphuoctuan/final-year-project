resource "aws_acm_certificate" "acm" {
    domain_name = "final-lab.tuantranlee.online"
    validation_method = "DNS"
}

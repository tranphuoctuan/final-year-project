resource "aws_acm_certificate" "acm" {
    domain_name =   var.name_acm
    validation_method = "DNS"
}

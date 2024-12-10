data "aws_cloudfront_origin_request_policy" "all_viewer" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer_except_host_header" {
  name = "Managed-AllViewerExceptHostHeader"
}

data "aws_cloudfront_response_headers_policy" "simple_cors" {
  name = "Managed-SimpleCORS"
}

resource "aws_cloudfront_distribution" "blog_cloudfront" {
  provider = aws.global
  aliases    = ["${var.record_53}"]
  enabled    = true
  # web_acl_id = aws_wafv2_web_acl.waf_web_acl_rule.arn
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = aws_lb.alb.id
    custom_origin_config {
      https_port             = 443
      http_port              = 80
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_lb.alb.id

    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.all_viewer.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.simple_cors.id
    viewer_protocol_policy     = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn      = var.arn_acm
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  } 
}
// associate alb endpoint to route3_record
resource "aws_route53_record" "record_53" {
  name    = var.record_53
  zone_id = data.aws_route53_zone.hosted_zone.id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.blog_cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.blog_cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}

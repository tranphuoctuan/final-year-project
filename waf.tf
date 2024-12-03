# Tạo IP Set chứa danh sách IP bị chặn
resource "aws_wafv2_ip_set" "blocked_ip_set" {
  name        = "blocked-ip-set"
  description = "Block ip public for access my website"
  scope       = "REGIONAL"

  ip_address_version = "IPV4"

  addresses = [
    "14.241.120.232/32", // ST's ip public
    "116.105.225.184/32" // ST's ip public
  ]
}

# Create a WAFv2 Web ACL
resource "aws_wafv2_web_acl" "waf_web_acl_rule" {
  name        = "protection-waf-web-acl"
  description = "Web ACL with rate limit rule"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "exampleAcl"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "RateLimitRule"
    priority = 100

    action {
      block {} # Block requests exceeding the rate limit
    }

    statement {
      rate_based_statement {
        limit            = 2000 # Limit to 2000 requests in a 5-minute period
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "BlockIPRule"
    priority = 200

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked_ip_set.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockIPRule"
      sampled_requests_enabled   = true
    }
  }

}

resource "aws_wafv2_web_acl_association" "attach_waf_to_alb" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_web_acl_rule.arn
}
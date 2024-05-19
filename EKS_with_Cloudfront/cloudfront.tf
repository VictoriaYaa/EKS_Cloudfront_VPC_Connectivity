### CloudFront Distribution



resource "aws_cloudfront_distribution" "main" {
  
  # Backend origin
  origin {
    domain_name = "${data.kubernetes_ingress_v1.ingress_hostname.status.0.load_balancer.0.ingress.0.hostname}"
    origin_id = "ELB-vic"


    custom_origin_config {
      http_port                = 80
      https_port               = 80
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  enabled = true
  
  is_ipv6_enabled = false

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "ELB-vic"

    forwarded_values {
      query_string = true
      headers = ["Host"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 31536000
    compress    = true
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

data "aws_cloudfront_distribution" "cf" {
  id = "${aws_cloudfront_distribution.main.id}"
}

### Outputs
output "cf_id" { value = aws_cloudfront_distribution.main.id }
output cf_domain_name { value = data.aws_cloudfront_distribution.cf.domain_name}

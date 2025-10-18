# Route53 hosted zone
data "aws_route53_zone" "main" {
  name = "samardash.com"
}

# Route53 A record for API Gateway
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "api.samardash.com"
  type    = "A"

  alias {
    name                   = var.api_gateway_domain_name
    zone_id                = var.api_gateway_zone_id
    evaluate_target_health = false
  }
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.main.zone_id
}
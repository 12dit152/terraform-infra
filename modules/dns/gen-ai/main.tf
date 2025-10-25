# Route53 hosted zone
data "aws_route53_zone" "main" {
  name = "samardash.com"
}

# Route53 A record for API Gateway
resource "aws_route53_record" "gen-ai" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "ai.samardash.com"
  type    = "A"

  alias {
    name                   = var.api_gateway_domain_name_gen_ai
    zone_id                = var.api_gateway_zone_id_gen_ai
    evaluate_target_health = false
  }
}
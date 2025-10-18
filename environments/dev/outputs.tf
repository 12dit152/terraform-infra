output "vpc_id" {
  description = "VPC ID"
  value       = module.network.samar_vpc_id
}

output "api_gateway_url" {
  description = "API Gateway URL"
  value       = module.api_gateway.api_gateway_url
}

output "custom_domain_url" {
  description = "Custom domain URL"
  value       = "https://api.samardash.com"
}
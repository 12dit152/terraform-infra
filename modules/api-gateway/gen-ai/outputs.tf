output "api_gateway_domain_name_gen_ai" {
  description = "Domain name of the API Gateway"
  value       = aws_api_gateway_domain_name.custom.regional_domain_name
}

output "api_gateway_zone_id_gen_ai" {
  description = "Zone ID of the API Gateway"
  value       = aws_api_gateway_domain_name.custom.regional_zone_id
}

output "api_gateway_url_gen_ai" {
  description = "URL of the API Gateway"
  value       = aws_api_gateway_stage.dev.invoke_url
}
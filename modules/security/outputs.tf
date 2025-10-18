output "redis_security_group_id" {
  description = "ID of the Redis security group"
  value       = aws_security_group.redis_public.id
}

output "https_security_group_id" {
  description = "ID of the HTTPS security group"
  value       = aws_security_group.https_public.id
}

output "ssh_security_group_id" {
  description = "ID of the SSH security group"
  value       = aws_security_group.ssh_public.id
}

output "http_security_group_id" {
  description = "ID of the HTTP security group"
  value       = aws_security_group.http_public.id
}

output "ssh_http_security_group_id" {
  description = "ID of the SSH+HTTP security group"
  value       = aws_security_group.ssh_http_public.id
}
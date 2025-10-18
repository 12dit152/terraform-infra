output "maven_releases_bucket_name" {
  description = "Name of Maven releases S3 bucket"
  value       = aws_s3_bucket.maven_releases.bucket
}

output "maven_releases_bucket_arn" {
  description = "ARN of Maven releases S3 bucket"
  value       = aws_s3_bucket.maven_releases.arn
}

output "terraform_state_bucket_name" {
  description = "Name of Terraform state S3 bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}
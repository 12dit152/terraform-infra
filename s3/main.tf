data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "maven_releases" {
  bucket = "maven-releases-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"

  tags = {
    Name = "Maven Releases Repository"
    Purpose = "Maven JAR artifacts"
  }
}



output "maven_releases_bucket_name" {
  value = aws_s3_bucket.maven_releases.bucket
}

output "maven_releases_bucket_arn" {
  value = aws_s3_bucket.maven_releases.arn
}
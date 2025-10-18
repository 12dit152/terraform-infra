data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "maven_releases" {
  bucket = "maven-releases-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.id}"

  tags = {
    Name    = "Maven Releases Repository"
    Purpose = "Maven JAR artifacts"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${data.aws_caller_identity.current.account_id}-eu-west-1"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "maven_releases" {
  bucket = aws_s3_bucket.maven_releases.id
  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Suspended"
  }
}
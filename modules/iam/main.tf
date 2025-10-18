data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "vpc-flow-logs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs" {
  role       = aws_iam_role.vpc_flow_logs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role" "github_actions_role" {
  name = "GitHubOIDCDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/spring-*:*"
          }
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name = "GitHub Actions OIDC Role"
  }
}

resource "aws_iam_policy" "github_s3_policy" {
  name = "GitHubS3UploadPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:GetFunction",
          "lambda:PublishVersion",
          "lambda:UpdateAlias"
        ]
        Resource = [
          "arn:aws:s3:::maven-releases-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.id}",
          "arn:aws:s3:::maven-releases-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.id}/*",
          "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:spring-lambda-*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_s3_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_s3_policy.arn
}
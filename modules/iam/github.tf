# GitHub OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  
  client_id_list = [
    "sts.amazonaws.com"
  ]
  
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
  
  tags = {
    Name = "GitHub Actions OIDC Provider"
  }
}

# GitHub Actions IAM Role
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubOIDCDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
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

# GitHub Actions Deployment Policy
resource "aws_iam_policy" "github_deployment_policy" {
  name = "GitHubDeploymentPolicy"

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
          "lambda:GetFunctionConfiguration",
          "lambda:PublishVersion",
          "lambda:UpdateAlias",
          "lambda:GetAlias",
          "lambda:InvokeFunction",
          "lambda:DeleteFunction",
          "lambda:ListVersionsByFunction"
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

resource "aws_iam_role_policy_attachment" "github_deployment_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_deployment_policy.arn
}
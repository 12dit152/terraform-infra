data "aws_region" "current" {}

resource "aws_s3_bucket" "grafana_lambda_code" {
  bucket = var.s3_bucket
}

resource "aws_s3_object_copy" "lambda_promtail_zipfile" {
bucket = var.s3_bucket
key    = var.s3_key
source = "grafanalabs-cf-templates/lambda-promtail/lambda-promtail.zip"

depends_on = [ aws_s3_bucket.grafana_lambda_code ]

}

resource "aws_cloudwatch_log_group" "lambda_promtail_log_group" {
name              = "/aws/lambda/GrafanaCloudLambdaPromtail-${var.function_name_suffix}"
retention_in_days = 1
}

resource "aws_lambda_function" "lambda_promtail" {
function_name = "GrafanaCloudLambdaPromtail-${var.function_name_suffix}"
role          = var.existing_role_arn

timeout     = 60
memory_size = 128

handler   = "main"
runtime   = "provided.al2023"
s3_bucket = var.s3_bucket
s3_key    = var.s3_key

environment {
    variables = {
    WRITE_ADDRESS = var.grafana_log_url
    USERNAME      = var.grafana_log_username
    PASSWORD      = var.grafana_log_key
    KEEP_STREAM   = var.keep_stream
    BATCH_SIZE    = var.batch_size
    EXTRA_LABELS  = var.extra_labels
    }
}

depends_on = [
    aws_s3_object_copy.lambda_promtail_zipfile,
    aws_cloudwatch_log_group.lambda_promtail_log_group,
]
}

resource "aws_lambda_function_event_invoke_config" "lambda_promtail_invoke_config" {
function_name          = aws_lambda_function.lambda_promtail.function_name
maximum_retry_attempts = 2
}

resource "aws_lambda_permission" "lambda_promtail_allow_cloudwatch" {
statement_id  = "lambda-promtail-allow-cloudwatch"
action        = "lambda:InvokeFunction"
function_name = aws_lambda_function.lambda_promtail.function_name
principal     = "logs.${data.aws_region.current.id}.amazonaws.com"
}

# This block allows for easily subscribing to multiple log groups via the `log_group_names` var.
# However, if you need to provide an actual filter_pattern for a specific log group you should
# copy this block and modify it accordingly.
resource "aws_cloudwatch_log_subscription_filter" "lambda_promtail_logfilter" {
for_each        = toset(var.log_group_names)
name            = "lambda_promtail_logfilter_${each.value}"
log_group_name  = each.value
destination_arn = aws_lambda_function.lambda_promtail.arn
# required but can be empty string
filter_pattern = ""
}

output "role_arn" {
value       = aws_lambda_function.lambda_promtail.arn
description = "The ARN of the Lambda function that runs lambda-promtail."
}
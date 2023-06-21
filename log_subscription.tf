
# Although this is the right script to stream CloudWatch Logs to Opensearch, Terraform does not have supporting API to do this directly
# resource "aws_cloudwatch_log_subscription_filter" "guardduty_to_es_filter" {
#   name            = "guardduty_to_es_filter"
#   role_arn        = aws_iam_role.lambda_to_es_role.arn
#   log_group_name  = "/aws/events/guardduty/logs"
#   filter_pattern  = "logtype test"
#   destination_arn = aws_opensearch_domain.log_aggregation.arn
# }

# resource "aws_cloudwatch_log_subscription_filter" "cloudtrail_to_es_filter" {
#   name            = "cloudtrail_to_es_filter"
#   role_arn        = aws_iam_role.lambda_to_es_role.arn
#   log_group_name  = "/aws/events/cloudtrail/logs"
#   filter_pattern  = "logtype test"
#   destination_arn = aws_opensearch_domain.log_aggregation.arn
# }

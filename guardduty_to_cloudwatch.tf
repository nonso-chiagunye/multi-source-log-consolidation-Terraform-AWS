
# Enable GuardDuty
resource "aws_guardduty_detector" "enable_cde_guardduty" {
  enable = var.enable_guardduty

  datasources {
    s3_logs {
      enable = var.enable_s3_logs 
    }
    kubernetes {
      audit_logs {
        enable = var.enable_kubernetes_audit
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.enable_malware_protection
        }
      }
    }
  }
}

# Create CloudWatch Log Group for GuardDuty 
resource "aws_cloudwatch_log_group" "guardduty_log_group" {
  name = "${var.guardduty_log_group_name}"
  retention_in_days = var.guardduty_retention_period

  tags = {
    Environment = "${var.ENVIRONMENT}"
  }
}

# Import policy/permissions that allow Guardduty write logs to CloudWatch
data "aws_iam_policy_document" "guardduty_log_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "${aws_cloudwatch_log_group.guardduty_log_group.arn}:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.guardduty_log_group.arn}:*:*"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }

    condition {
      test     = "ArnEquals"
      values   = [aws_cloudwatch_event_rule.guardduty_event_rule.arn]
      variable = "aws:SourceArn"
    }
  }
}

# Create a Policy with the imported policy document
resource "aws_cloudwatch_log_resource_policy" "guardduty_log_resource_policy" {
  policy_document = data.aws_iam_policy_document.guardduty_log_policy.json
  policy_name     = "guardduty-log-publishing-policy"
}

# Create CloudWatch event rule for GuardDuty 
resource "aws_cloudwatch_event_rule" "guardduty_event_rule" {
  name        = "guardduty_event_rule"
  description = "GuardDuty Findings"

  event_pattern = jsonencode({
    detail-type = [
      "GuardDuty Finding"
    ],
    source = [
        "aws.guardduty"
    ]
  })
}

# Make the CloudWatch Log Group the target of matched events from the event rule created above
resource "aws_cloudwatch_event_target" "guardduty_event_target" {
  rule = aws_cloudwatch_event_rule.guardduty_event_rule.name
  arn  = aws_cloudwatch_log_group.guardduty_log_group.arn
}



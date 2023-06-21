
# Create Log Group for CloudTrail 
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name = "${var.cloudtrail_log_group_name}"
  retention_in_days = var.cloudtrail_retention_period

  tags = {
    Environment = "${var.ENVIRONMENT}" 
  }
}

# Create IAM Role which CloudTrail will use to publish logs to CloudWatch 
resource "aws_iam_role" "cloudtrail-to-cloudwatch-role" {
  name = "${var.cloudtrail_iam_role}" 

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM Role Policy/Permissions to be attached CloudTrail to CloudWatch Role
resource "aws_iam_role_policy" "cloudtrail-to-cloudwatch-policy" {
  name = "${var.cloudtrail_iam_policy}"
  role = aws_iam_role.cloudtrail-to-cloudwatch-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream2014110",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents20141101",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
            ]
        }
    ]
}
EOF
}

# Enable Cloudtrail
resource "aws_cloudtrail" "global_trail" {
  name                          = "${var.trail_name}"
  s3_bucket_name                = aws_s3_bucket.cloutrail-eslog-bucket.id
  s3_key_prefix                 = "${var.s3_key_prefix}"
  include_global_service_events = var.include_global_service_event    
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*" 
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail-to-cloudwatch-role.arn

    event_selector {
    read_write_type           = "${var.read_write_type}"
    include_management_events = var.include_management_events

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }
}

# Create S# Bucket that will hold the trails
resource "aws_s3_bucket" "cloutrail-eslog-bucket" {
  bucket        = "${var.bucket_name}"
  force_destroy = var.force_destroy
}

# Import IAM Policy that enables CloudTrail read and write to the S3 Bucket
data "aws_iam_policy_document" "cloudtrail_log_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloutrail-eslog-bucket.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloutrail-eslog-bucket.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# Attach the CloudTrail Policy to the S3 Bucket 
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloutrail-eslog-bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_log_policy.json
}

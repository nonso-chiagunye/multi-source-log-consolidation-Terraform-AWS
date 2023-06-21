# Import policy document for Lambda
data "aws_iam_policy_document" "lambda_to_es_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Create a role which Lambda will use to read logs fromCloudWatch and write to Opensearch
resource "aws_iam_role" "lambda_to_es_role" {
  name               = "${var.lambda_to_es_role_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_to_es_policy.json
}

# Attach the required individual policies to the IAM Role. You can modify the policies to customer-managed custom policies
resource "aws_iam_role_policy_attachment" "lambda_to_es_attach1" {
  role       = aws_iam_role.lambda_to_es_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonOpenSearchServiceFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_to_es_attach2" {
  role       = aws_iam_role.lambda_to_es_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_to_es_attach3" {
  role       = aws_iam_role.lambda_to_es_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_to_es_attach4" {
  role       = aws_iam_role.lambda_to_es_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

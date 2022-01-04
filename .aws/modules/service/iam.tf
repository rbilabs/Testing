#############################################################################
# Lambda IAM Role - template
#############################################################################

# Retrieve data about the orders table
data "aws_dynamodb_table" "orders" {
  name = "aws-rbi-${var.stage}-${var.brand}"
}

# Creates a policy statement to allow lambda functions to assume a role
data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Creates a role for the template service
resource "aws_iam_role" "template" {
  name = "${local.region_short}-${var.stage}-${var.brand}-template"

  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json
  tags               = local.common_tags
}

resource "aws_ssm_parameter" "template_role_arn" {
  name  = "/rbi/${var.stage}/${var.brand}/template-service/lambda-role-arn"
  type  = "String"
  value = aws_iam_role.template.arn
}

# Creates a policy statement for allowed IAM actions
data "aws_iam_policy_document" "template" {
  statement {
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/sls-rbi-${var.stage}-${var.brand}-template-*:*",
    ]
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
  }

  # SecretsManager: Read secrets
  statement {
    resources = ["arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:rbi/${var.stage}/*"]
    actions   = ["secretsmanager:GetSecretValue"]
  }

  # DynamoDB
  statement {
    resources = [data.aws_dynamodb_table.orders.arn]
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
  }

  # DynamoDB indexes
  statement {
    resources = ["${data.aws_dynamodb_table.orders.arn}/index/*"]
    actions = [
      "dynamodb:Query"
    ]
  }

  # SQS access
  statement {
    resources = [aws_sqs_queue.sync_subscription.arn]
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:ChangeMessageVisibilityBatch",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
    ]
  }
}

# Creates a policy for the document
resource "aws_iam_policy" "template" {
  name   = "${local.region_short}-${var.stage}-${var.brand}-template-lambda-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.template.json
}

# Attaches the policy to the IAM role
resource "aws_iam_role_policy_attachment" "template" {
  role       = aws_iam_role.template.name
  policy_arn = aws_iam_policy.template.arn
}

# Attaches the shared xray policy
data "aws_iam_policy" "xray" {
  arn = "arn:aws:iam::${local.account_id}:policy/shared/${local.region_short}-account-xray"
}

resource "aws_iam_role_policy_attachment" "xray" {
  role       = aws_iam_role.template.name
  policy_arn = data.aws_iam_policy.xray.arn
}

# Attaches the shared launch darkly policy
data "aws_iam_policy" "launchdarkly" {
  arn = "arn:aws:iam::${local.account_id}:policy/shared/${local.region_short}-account-launchdarkly"
}

resource "aws_iam_role_policy_attachment" "launchdarkly" {
  role       = aws_iam_role.template.name
  policy_arn = data.aws_iam_policy.launchdarkly.arn
}

# Attaches the shared secrets policy
data "aws_iam_policy" "secrets_dynamodb" {
  arn = "arn:aws:iam::${local.account_id}:policy/shared/${local.region_short}-account-secrets-dynamodb"
}

resource "aws_iam_role_policy_attachment" "secrets_dynamodb" {
  role       = aws_iam_role.template.name
  policy_arn = data.aws_iam_policy.secrets_dynamodb.arn
}

# Attaches the shared kms policy
data "aws_iam_policy" "kms_decrypt" {
  arn = "arn:aws:iam::${local.account_id}:policy/shared/${local.region_short}-account-kms-decrypt"
}

resource "aws_iam_role_policy_attachment" "kms_decrypt" {
  role       = aws_iam_role.template.name
  policy_arn = data.aws_iam_policy.kms_decrypt.arn
}


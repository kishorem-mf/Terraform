data "aws_iam_policy_document" "glue_execution_assume_role_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "glue_service_role" {
  name             = "aws_glue_job_runner"
  assume_role_policy = data.aws_iam_policy_document.glue_execution_assume_role_policy.json
  tags             = {
    Application = var.project
  }
}


data "aws_iam_policy_document" "data_lake_policy" {
  #  name        = "EventBridgeLambdaPolicy"
  #  description = "IAM policy for allowing EventBridge to invoke any Lambda function"
  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket}/*"]
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket}/", "arn:aws:s3:::awsglue-datasets/"]
    actions   = ["s3:ListBucket"]
  }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::awsglue-datasets/*"]
    actions   = ["s3:GetObject"]
  }
}

data "aws_iam_policy_document" "data_lake_policy_covid" {
  #  name        = "EventBridgeLambdaPolicy"
  #  description = "IAM policy for allowing EventBridge to invoke any Lambda function"
  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_covid}/*"]
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject","s3:ListBucket"]
  }

  # statement {
  #   effect    = "Allow"
  #   resources = ["arn:aws:s3:::${var.s3_bucket}/", "arn:aws:s3:::awsglue-datasets/"]
  #   actions   = ["s3:ListBucket"]
  # }

  # statement {
  #   effect    = "Allow"
  #   resources = ["arn:aws:s3:::awsglue-datasets/*"]
  #   actions   = ["s3:GetObject"]
  # }
}

resource "aws_iam_policy" "data_lake_access_policy" {
  name        = "s3DataLakePolicy-${var.s3_bucket}"
  description = "Allows for running glue job in the glue console and access my s3_bucket"
  policy      = data.aws_iam_policy_document.data_lake_policy.json
  tags        = {
    Application = var.project
  }
}

resource "aws_iam_policy" "data_lake_access_policy_covid" {
  name        = "s3DataLakePolicy-${var.s3_bucket_covid}"
  description = "Allows for running glue job in the glue console and access my s3_bucket"
  policy      = data.aws_iam_policy_document.data_lake_policy_covid.json
  tags        = {
    Application = var.project
  }
}


# Attach both policies to the role
resource "aws_iam_role_policy_attachment" "data_lake_permissions" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.data_lake_access_policy.arn
}

# Attach both policies to the role
resource "aws_iam_role_policy_attachment" "data_lake_permissions_covid" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.data_lake_access_policy_covid.arn
}


# Define CloudWatchFullAccess policy
data "aws_iam_policy" "cloudwatch_full_access" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_full_access_attachment" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = data.aws_iam_policy.cloudwatch_full_access.arn
}

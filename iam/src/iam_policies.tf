
data "aws_iam_policy_document" "terraform-cloud" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arm:aws:s3:::*"]
    effect    = "Allow"
  }
}

// Read Access

data "aws_iam_policy_document" "s3_read" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Describe*",
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "read" {
  source_policy_documents = [
    data.aws_iam_policy_document.s3_read.json,
  ]
}

resource "aws_iam_policy" "read" {
  name        = "read"
  description = "IAM policy granting read access"
  policy      = data.aws_iam_policy_document.read.json
  tags = {
    managed = true
  }
}

// Write access

data "aws_iam_policy_document" "s3_write" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Put*",
      "s3:Delete*",
      "s3:Create*",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "write" {
  source_policy_documents = [
    data.aws_iam_policy_document.s3_write.json,
  ]
}

resource "aws_iam_policy" "write" {
  name        = "write"
  description = "IAM policy granting broad write access"
  policy      = data.aws_iam_policy_document.write.json
  tags = {
    managed = true
  }
}

// Admin acccess

data "aws_iam_policy_document" "s3_admin" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ec2_admin" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "admin" {
  source_policy_documents = [
    data.aws_iam_policy_document.s3_admin.json,
    data.aws_iam_policy_document.ec2_admin.json,
  ]
}

resource "aws_iam_policy" "admin" {
  name        = "admin"
  description = "IAM policy for granting broad admin access"
  policy      = data.aws_iam_policy_document.admin.json
  tags = {
    managed = true
  }
}

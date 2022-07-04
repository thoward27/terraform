resource "aws_iam_user" "terraform_cloud_prod" {
  name = "terraform-cloud-prod"
  path = "/terraform-cloud/"

  tags = {
    managed = true
  }
}

resource "aws_iam_access_key" "terraform_cloud_prod" {
  user    = aws_iam_user.terraform_cloud_prod.name
  pgp_key = var.base64_pgp_public_key
}

resource "aws_iam_user_policy_attachment" "terraform_cloud_prod_read" {
  user       = aws_iam_user.terraform_cloud_prod.name
  policy_arn = aws_iam_policy.read.arn
}

resource "aws_iam_user_policy_attachment" "terraform_cloud_prod_write" {
  user       = aws_iam_user.terraform_cloud_prod.name
  policy_arn = aws_iam_policy.write.arn
}

resource "aws_iam_user_policy_attachment" "terraform_cloud_prod_admin" {
  user       = aws_iam_user.terraform_cloud_prod.name
  policy_arn = aws_iam_policy.admin.arn
}

resource "aws_iam_user" "dev_cli_access" {
  name = "dev-cli-access"
  path = "/dev/"

  tags = {
    managed = true
  }
}

resource "aws_am_access_key" "dev_cli_access" {
  user    = aws_iam_user.dev_cli_access.name
  pgp_key = var.base64_pgp_public_key
}

resource "aws_iam_user_policy_attachment" "dev_cli_access_read" {
  user       = aws_iam_user.dev_cli_access.name
  policy_arn = aws_iam_policy.read.arn
}

resource "aws_iam_user_policy_attachment" "dev_cli_access_write" {
  user       = aws_iam_user.dev_cli_access.name
  policy_arn = aws_iam_policy.write.arn
}

resource "aws_iam_user_policy_attachment" "dev_cli_access_admin" {
  user       = aws_iam_user.dev_cli_access.name
  policy_arn = aws_iam_policy.admin.arn
}

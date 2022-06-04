
output "aws_iam_access_key_id_terraform_cloud_prod" {
  value = aws_iam_access_key.terraform_cloud_prod.id
}

output "aws_iam_access_key_secret_terraform_cloud_prod" {
  value = aws_iam_access_key.terraform_cloud_prod.encrypted_secret
}

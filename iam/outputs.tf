
output "terraform_cloud_access_key_id" {
  value = module.default.aws_iam_access_key_id_terraform_cloud_prod
}

output "terraform_cloud_access_key_secret" {
  value     = module.default.aws_iam_access_key_secret_terraform_cloud_prod
  sensitive = true
}

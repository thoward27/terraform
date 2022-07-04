
output "terraform_cloud_access_key_id" {
  value = module.default.aws_iam_access_key_id_terraform_cloud_prod
}

output "terraform_cloud_access_key_secret" {
  value     = module.default.aws_iam_access_key_secret_terraform_cloud_prod
  sensitive = true
}

output "dev_cli_access_key_id" {
  value = module.default.aws_iam_access_key_id_dev_cli_access
}

output "dev_cli_access_key_secret" {
  value     = module.default.aws_iam_access_key_secret_dev_cli_access
  sensitive = true
}


get-terraform-cloud-id:
	terraform output -raw terraform_cloud_access_key_id

get-terraform-cloud-secret:
	terraform output -raw terraform_cloud_access_key_secret | base64 --decode | gpg --decrypt

get-dev-cli-id:
	terraform output -raw dev_cli_access_key_id

get-dev-cli-secret:
	terraform output -raw dev_cli_access_key_secret | base64 --decode | gpg --decrypt

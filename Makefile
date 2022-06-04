
get-terraform-cloud-id:
	cd iam && terraform output -raw terraform_cloud_access_key_id

get-terraform-cloud-secret:
	terraform output -raw terraform_cloud_access_key_secret | base64 --decode | gpg --decrypt

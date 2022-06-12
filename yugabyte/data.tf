data "terraform_remote_state" "vpc" {
    backend = "remote"

    config = {
        organization = "tom-howard-codes-prod"
        workspaces = {
            name = "terraform-vpc"
        }
    }
}
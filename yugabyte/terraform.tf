terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "tom-howard-codes-prod"

    workspaces {
      name = "terraform-yugabyte"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

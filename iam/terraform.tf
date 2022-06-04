terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "tom-howard-codes-prod"

    workspaces {
      name = "iam"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

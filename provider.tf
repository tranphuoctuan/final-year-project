//create resource
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {}
  required_version = ">= 1.2.0"
}

provider "aws" {
  alias = "regional"
  region = var.region
}

provider "aws" {
  alias   = "global"
  region  = "us-east-1"
}
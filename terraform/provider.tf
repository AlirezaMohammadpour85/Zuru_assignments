terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
# provider "aws" {
#   region     = "us-east-1"
#   access_key = <ACCESS_KEY>
#   secret_key = <SECRET_KEY>
# }
provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = [var.shared_credentials_files]
  profile                  = var.profile_name
}

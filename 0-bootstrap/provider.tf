provider "aws" {
  region                   = var.region
  shared_credentials_files = ["$HOME/.aws/credentials"]
  profile                  = "jmy_test_sa"
}

terraform {
  backend "s3" {
    bucket                  = "terraform-state-bucket-jmy"
    key                     = "bootstrap/terraform.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile                 = "jmy_test_sa"
  }
}

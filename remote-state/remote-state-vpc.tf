data "terraform_remote_state" "vpc" {
  backend= "s3"
  config= {
    bucket                  = "terraform-state-bucket-jmy"
    key                     = "vpc/terraform.tfstate"
    region                  = "us-east-1"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile                 = "jmy_test_sa"
  }
}

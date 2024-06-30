terraform {
  backend "s3" {
    bucket  = "nexasphere-tf"
    key     = "prod_terraform_2.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
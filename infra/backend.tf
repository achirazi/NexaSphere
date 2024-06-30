terraform {
  backend "s3" {
    bucket  = "nexasphere-tf"
    key     = "prod_terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
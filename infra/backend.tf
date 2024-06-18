terraform {
  backend "s3" {
    bucket  = var.backend_s3
    key     = "prod_terraform.tfstate"
    region  = var.region
    encrypt = true
  }
}
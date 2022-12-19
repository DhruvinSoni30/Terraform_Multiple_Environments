provider "aws" {
  region = var.region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "tf-state-dksoni"
    region = "us-west-2"
    key    = "prod/terraform.tfstate"
    profile = "default"
  }
}
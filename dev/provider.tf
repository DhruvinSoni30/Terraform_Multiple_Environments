provider "aws" {
  region = var.region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "tf-state-dksoni"
    region = "us-west-2"
    key    = "dev/terraform.tfstate"
    profile = "default"
  }
}
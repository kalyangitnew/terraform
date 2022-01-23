provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-practice"
    key    = "example/sample/terraform.tfstate"
    region = "us-east-1"
  }
}
module "ec2" {
  source = "./ec2"
}
module "sg" {
  source = "./sg"
}

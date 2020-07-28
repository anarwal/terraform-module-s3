provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "s3" {
  source            = "../module/"
  namespace         = "eg"
  name              = "app"
  stage             = "test"
  attributes        = ["xyz"]
  s3_bucket_name    = var.s3_bucket_name
  pgp_key           = var.pgp_key
}


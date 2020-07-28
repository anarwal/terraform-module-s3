data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  root_user = "arn:aws:iam::data.aws_caller_identity.current.account_id:root"
}

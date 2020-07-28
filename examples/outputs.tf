output "s3_iam_user" {
  value = module.s3.s3_iam_user_name
}

output "s3_user_secret_key" {
  value = module.s3.s3_user_secret_key
}

output "s3_user_access_key" {
  value = module.s3.s3_user_access_key
}

output "s3_bucket" {
  value = module.s3.s3_bucket
}

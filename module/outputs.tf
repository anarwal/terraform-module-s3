output "s3_iam_user_arn" {
  value = aws_iam_user.s3_user.*.arn
}

output "s3_iam_user_name" {
  value = aws_iam_user.s3_user.*.name
}

output "s3_user_secret_key" {
  value = {"secret_key_1" = aws_iam_access_key.s3_user_access_key_1.*.encrypted_secret, "secret_key_2" = aws_iam_access_key.s3_user_access_key_2.*.encrypted_secret }
}

output "s3_user_access_key" {
  value = {"access_key_1" = aws_iam_access_key.s3_user_access_key_1.*.id , "access_key_2" = aws_iam_access_key.s3_user_access_key_2.*.id }
}

output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket.id
}

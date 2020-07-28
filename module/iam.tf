resource "aws_iam_user" "s3_user" {
  name          = format("%s_s3_iam", module.s3_label.name)
  path          = "/"
  force_destroy = var.iam_force_destroy
  tags          = { "Name" = format("%s_s3_iam", module.s3_label.name), "Environment" = module.s3_label.stage}
}

resource "aws_iam_user_policy_attachment" "s3_allow_policy" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_user_policy_attachment" "deny_put_acl" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.deny_put_acl.arn
}

resource "aws_iam_access_key" "s3_user_access_key_1" {
count   = var.rotation_status == "1" || var.rotation_status == "rotate" ? 1 : 0
user    = aws_iam_user.s3_user.name
pgp_key = var.pgp_key
}

resource "aws_iam_access_key" "s3_user_access_key_2" {
count   = var.rotation_status == "2" || var.rotation_status == "rotate" ? 1 : 0
user    = aws_iam_user.s3_user.name
pgp_key = var.pgp_key
}


resource "aws_iam_policy" "s3_policy" {
  name        = format("%s_s3_policy", module.s3_label.name)
  path        = "/"
  description = format("%s_s3_user_policy", module.s3_label.name)
  policy =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "deny_put_acl" {
  name = format("%s_deny_put_acl_policy", module.s3_label.name)
  path = "/"
  description = "deny_put_acl"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AddPerm",
      "Effect": "Deny",
      "Action": [
        "s3:PutBucketAcl",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
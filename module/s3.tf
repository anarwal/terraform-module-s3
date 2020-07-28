resource "aws_s3_bucket" "s3_bucket" {
  bucket        = format("%s-%s-bucket", module.s3_label.name, var.s3_bucket_name)
  force_destroy = var.s3_force_destroy
  tags          = { "Name" = format("%s-%s", module.s3_label.name, var.s3_bucket_name), "Environment" = module.s3_label.stage}

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled
    prefix  = var.lifecycle_infrequent_storage_object_prefix

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled
    prefix  = var.lifecycle_glacier_object_prefix

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled
    prefix  = var.lifecycle_expiration_object_prefix

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id

  policy = <<POLICY
{
  "Id": "Policy1568776371530",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1568776370362",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}/*",
        "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}"
      ],
      "Principal": {
        "AWS": [
          "${aws_iam_user.s3_user.arn}"
        ]
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_metric" "s3_bucket_metric" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  name   = var.s3_bucket_name
}
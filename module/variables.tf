variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
  default     = ""
}

variable "attributes" {
  type        = list
  description = "Additional attributes (e.g. 1)"
  default     = []
}

variable "delimiter" {
  type        = string
  description = "Delimiter to be used between namespace, environment, stage, name and attributes"
  default     = "-"
}

variable "name" {
  type        = string
  description = "A prefix to add to project resources"
  default     = ""
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name"
  default     = ""
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket."
  default     = false
}

variable "lifecycle_infrequent_storage_transition_enabled" {
  type        = bool
  description = "Specifies status for object transtion to  infrequent access storage."
  default     = true
}

variable "lifecycle_infrequent_storage_object_prefix" {
  type        = string
  description = "Object key prefix identifying one or more objects to which the rule for infrequent access storage applies."
  default     = "infrequent_access"
}

variable "lifecycle_days_to_infrequent_storage_transition" {
  type        = number
  description = "Specifies the number of days after object creation when transition to infrequent access storage takes effect."
  default     = 90
}

variable "lifecycle_glacier_transition_enabled" {
  type        = bool
  description = "Specifies status for object transtion to  glacier storage."
  default     = true
}

variable "lifecycle_glacier_object_prefix" {
  type        = string
  description = "Object key prefix identifying one or more objects to which the rule for glacier storage applies"
  default     = "glacier"
}

variable "lifecycle_days_to_glacier_transition" {
  type        = number
  description = "Specifies the number of days after object creation when transition to glacier storage takes effect."
  default     = 180
}

variable "lifecycle_expiration_enabled" {
  type        = bool
  description = "Specifies status for object expiration."
  default     = true
}

variable "lifecycle_expiration_object_prefix" {
  type        = string
  description = "Object key prefix identifying one or more objects which is set for expiration"
  default     = "expired"
}

variable "lifecycle_days_to_expiration" {
  type        = number
  description = "Specifies the number of days after object creation the onbject is expired"
  default     = 365
}

variable "s3_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "iam_force_destroy" {
  type        = bool
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  default     = false
}

variable "rotation_status" {
  type        = string
  description = "IAM access key rotation status"
  default     = "1"
}

variable "pgp_key" {
  type        = string
  description = "Provide pgp key to decrypt iam user secret key"
  default     = ""
}
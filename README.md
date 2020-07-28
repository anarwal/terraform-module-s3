# terraform-module-s3

Usage:
```
module "s3" {
  source            = "./module/"
  namespace         = "eg"
  name              = "app"
  stage             = "test"
  attributes        = ["xyz"]
  s3_bucket_name    = var.s3_bucket_name
  pgp_key           = var.pgp_key
}

output "s3_iam_user" {
  value = module.s3.s3_iam_user
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
```

## INPUT VALUES

| Input                                            | Description                                                                                                                                                 | Type    | Default              | Required |
| -------------------------------------------------| ------------------------------------------------------------------------------------------------------------------------------------------------------------| --------|----------------------|----------|
| namespace                                        | Namespace, which could be your organization name or abbreviation"                                                                                           |`string` | ""                   | yes      |
| stage                                            | Stage, e.g. 'prod', 'staging', 'dev'                                                                                                                        |`string` | ""                   | yes      |
| name                                             | Solution name, e.g. 'app' or 'jenkins'                                                                                                                      |`string` | ""                   | yes      |
| attributes                                       | Additional attributes                                                                                                                                       |`list`   | `<list>`             | no       |           
| delimiter                                        | Delimiter to be used between namespace, environment, stage, name and attributes                                                                             |`string` | "-"                  | no       |
| s3_bucket_name                                   | The name of the bucket. If omitted, Terraform will assign a random, unique name                                                                             | `bool`  | `false`              | no       |
| versioning_enabled                               | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket.      | `bool`  | `true`               | no       |
| lifecycle_infrequent_storage_transition_enabled  | Specifies status for object transtion to  infrequent access storage.                                                                                        | `string`| `infrequent_access`  | no       |
| lifecycle_days_to_infrequent_storage_transition  | Specifies the number of days after object creation when transition to infrequent access storage takes effect                                                | `number`| `90`                 | no       |
| lifecycle_glacier_transition_enabled             | Specifies status for object transtion to  glacier storage.                                                                                                  | `bool`  | `true`               | no       |
| lifecycle_glacier_object_prefix                  | Object key prefix identifying one or more objects to which the rule for glacier storage applies                                                             | `sring` | `glacier`            | no       |
| lifecycle_days_to_glacier_transition             | Specifies the number of days after object creation when transition to glacier storage takes effect                                                          | `number`| `180`                | no       |
| lifecycle_expiration_enabled                     | Specifies status for object expiration                                                                                                                      | `bool`  | `true`               | no       |
| lifecycle_expiration_object_prefix               | Object key prefix identifying one or more objects which is set for expiration                                                                               | `string`| `expired`            | no       |
| lifecycle_days_to_expiration                     | Specifies the number of days after object creation the onbject is expired                                                                                   | `number`| `365`                | no       |
| s3_force_destroy                                 | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable | `bool`  | `false`              | no       |
| iam_force_destroy                                | When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices                                       | `bool`  | `false`              | no       |
| rotation_status                                  | IAM access key rotation status                                                                                                                              | `string`| `1`                  | no       |
| pgp_key                                          | Provide pgp key to decrypt iam user secret key                                                                                                              | `string`| ""                   | yes      |

## INPUT VALUE DETAILS

`rotation_status`
This variable is used to rotate keys. By default it is set to "1", when you want to rotate your key you set this variable to "rotate" and it will attach a second key to your user and spit that one out as well. When you have rotated your keys in your application set this variable to "2" and it will remove the first key and leave the second. When you want to rotate again just do the same process in reverse.

`pgp_key`
A base 64 encoded public PGP key that is used to encrypt your secret key when output. See below for instructions.

### For MAC
-----
#### Using a Pre-existing PGP Key

If you already have a PGP key, follow the steps here to export the base64 of the key: (see STEP 2 - EXPORT TEAM PGP KEY)

Step 1: `gpg --list-secret-keys --keyid-format LONG`

output: `rsa4096/78778877 2020-07-28 [SC] [expires: 2025-05-20]`

Step 2: `gpg --export 868686868 | base64 | pbcopy`

alternatively, add it to a file here

`gpg --export 868686868 | base64 > key.pgp`

Step 3: Paste the key into where you need it to add (Terraform, etc...)

#### Creating new PGP key

Step 1: Install encryption support:

`brew install gnupg2`

Step 2: `gpg --full-generate-key`

```
   *Select the following answers*
   **Please select what kind of key you want:** (1) RSA and RSA (default)
   **What keysize do you want? (2048):** 4096
   **Please specify how long the key should be valid:** 0
   **Key does not expire at all:** y
   **Real Name:** *Any Unique name to identify the key*
   **Email address:** *Your Email*
   **Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit:** O
   *Enter a passphrase when prompted*
```

Step 3: `gpg --export "(paste the name of the "Real Name" you entered when creating the key here)" | base64 > key.pgp`

Alternatively, you can use the key id, and autocopy to your clipboard rather than a file:

`gpg --export 78798979 | base64 | pbcopy`

Step 4: Paste this base64 encrypted key to where ever you need it.

#### Decrypt the encrypted secret

Step 1: Install encryption support:

`brew install gnupg2`

Put the encrypted secret key string (obtained from the Terraform output next to "secret_key = ", should be long) into a file (e.g secret.txt)

Step 2: Once you have the output you can base64 decode and decrypt it with the private key you created earlier:

`pbpaste | base64 --decode | gpg --decrypt`

Step 3: Enter the encryption password

Step 4: All done

-----

## OUTPUT VALUE NAMES

| Name                    | Description                                   | 
| ------------------------| --------------------------------------------- | 
| s3_iam_user_arn         | IAM user arn associated with this access key  | 
| s3_iam_user_name        | IAM user name associated with this access key | 
| s3_iam_user_access_key  | Access key of S3 IAM user                     | 
| s3_iam_user_secret_key  | Encrypted secret key of S3 IAM user           | 
| s3_bucket               | Name of S3 bucket.                            | 

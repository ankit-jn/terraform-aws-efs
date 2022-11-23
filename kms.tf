## Provision KMS Key for encryption Disk
module "encryption" {
    source = "git::https://github.com/arjstack/terraform-aws-kms.git?ref=v1.0.0"

    count = local.create_kms_key ? 1 : 0

    account_id = data.aws_caller_identity.this.account_id

    description = format("KMS Key for EFS [%s] - Disk encryption", var.name)

    key_spec    = "SYMMETRIC_DEFAULT"
    key_usage   = "ENCRYPT_DECRYPT"

    aliases =  [format("%s-key", var.name)]

    key_administrators = [data.aws_caller_identity.this.arn]
    key_grants_users = [data.aws_caller_identity.this.arn]
    key_users = [data.aws_caller_identity.this.arn]

    policy = data.template_file.efs_access_policy[0].rendered

    tags = merge({ "EFS" = var.name },var.default_tags)
}

## KMS key Policy for giving access to EFS service
data template_file "efs_access_policy" {
    count = local.create_kms_key ? 1 : 0
    
    template = file("${path.module}/kms-policy.json")

    vars = {
      aws_account = data.aws_caller_identity.this.account_id
      aws_region  = data.aws_region.current.id
    }
}
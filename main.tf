resource aws_efs_file_system "this" {
    creation_token = var.name

    availability_zone_name = var.availability_zone_name

    performance_mode = var.performance_mode
    throughput_mode = var.throughput_mode
    provisioned_throughput_in_mibps = (var.throughput_mode == "provisioned") ? var.provisioned_throughput_in_mibps : null

    encrypted = var.encrypt_disk
    kms_key_id = var.encrypt_disk ? local.kms_key : null

    dynamic "lifecycle_policy" {
        for_each = var.transition_to_ia > 0 ? [1] : []

        content {
            transition_to_ia = format("AFTER_%d_DAYS", var.transition_to_ia)
            transition_to_primary_storage_class = var.transition_from_ia ? "AFTER_1_ACCESS" : null
        }
    }

    tags = merge({"Name" = var.name}, var.default_tags)   
}

resource aws_efs_backup_policy "this" {
    file_system_id = aws_efs_file_system.this.id

    backup_policy {
        status = var.enable_backup ? "ENABLED" : "DISABLED"
    }
}

## EFS Mount Targets
resource aws_efs_mount_target "this" {

    for_Each = { for target in var.mount_targets: target.subnet => target }

    file_system_id = aws_efs_file_system.this.id

    subnet_id = each.key
    ip_address = try(each.value.ip_address, null)
    security_groups  = concat(local.security_groups, try(each.value.security_groups, []))

}

## Security Group for EFS
module "efs_security_group" {
    source = "git::https://github.com/arjstack/terraform-aws-security-groups.git?ref=v1.0.0"

    count = var.create_sg ? 1 : 0

    vpc_id = var.vpc_id
    name = local.sg_name

    ingress_rules = concat(local.sg_ingress_rules, local.sg_ingress_rules_source_sg)
    egress_rules  = local.sg_egress_rules

    tags = merge({"Name" = local.sg_name}, 
                { "EFS" = var.name }, var.default_tags)
}

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

    tags = merge({ "EFS" = var.name },var.default_tags)
}
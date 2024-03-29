resource aws_efs_file_system "this" {
    creation_token = var.name

    availability_zone_name = var.availability_zone_name

    ## In case of One zone EFS (i.e. availablity_zone_name is given), 
    ## `performance_mode` is by default set to `generalPurpose`
    performance_mode = (var.availability_zone_name == null 
                            || var.availability_zone_name == "") ? "generalPurpose" : var.performance_mode
    throughput_mode = var.throughput_mode
    provisioned_throughput_in_mibps = (var.throughput_mode == "provisioned") ? var.provisioned_throughput_in_mibps : null

    encrypted = var.encrypt_disk
    kms_key_id = var.encrypt_disk ? local.kms_key : null

    dynamic "lifecycle_policy" {
        for_each = var.transition_to_ia > 0 ? [1] : []

        content {
            transition_to_ia = format("AFTER_%d_DAYS", var.transition_to_ia)
        }
    }
    
    dynamic "lifecycle_policy" {
        for_each = ((var.transition_to_ia > 0) 
                            && (var.transition_from_ia > 0)) ? [1] : []

        content {
           transition_to_primary_storage_class = format("AFTER_%d_ACCESS", var.transition_from_ia)
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

# EFS Mount Targets
resource aws_efs_mount_target "this" {

    for_each = { for target in var.mount_targets: target.subnet => target }

    file_system_id = aws_efs_file_system.this.id

    subnet_id = each.key
    ip_address = lookup(each.value, "ip_address", null)
    security_groups  = concat(local.security_groups, try(each.value.security_groups, []))

}

## Security Group for EFS
module "efs_security_group" {
    source = "git::https://github.com/ankit-jn/terraform-aws-security-groups.git"

    count = var.create_sg ? 1 : 0

    vpc_id = var.vpc_id
    name = local.sg_name

    ingress_rules = concat(local.sg_ingress_rules, local.sg_ingress_rules_source_sg)
    egress_rules  = local.sg_egress_rules

    tags = merge({"Name" = local.sg_name}, 
                { "EFS" = var.name }, var.default_tags)
}
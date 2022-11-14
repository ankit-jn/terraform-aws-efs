resource aws_efs_file_system "this" {
    
}

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

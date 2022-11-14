locals {
    sg_name = coalesce(var.sg_name, format("efs-%s-sg", var.name))
    sg_ingress_rules_source_sg = [ for sg_id in var.allowed_sg: 
                                            {
                                                rule_name = sg_id
                                                description = format("Allowed for %s", sg_id)
                                                from_port = 2049
                                                to_port = 2049
                                                protocol = "tcp"
                                                source_security_group_id = sg_id
                                            } ]

    sg_ingress_rules = flatten([ for rule_key, rule in var.sg_rules :  rule if rule_key == "ingress" ])
    sg_egress_rules = flatten([ for rule_key, rule in var.sg_rules :  rule if rule_key == "egress" ])

    additional_sg = coalesce(var.additional_sg, [])
    security_groups = var.create_sg ? concat([module.efs_security_group[0].security_group_id], 
                                                                local.additional_sg) : local.additional_sg

    create_kms_key = var.encrypt_disk && var.create_kms_key
    kms_key = local.create_kms_key ? module.encryption[0].key_arn : var.kms_key
}
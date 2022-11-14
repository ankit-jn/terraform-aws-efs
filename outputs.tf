output "efs_id" {
    description = "The ID that identifies the file system"
    value       = aws_efs_file_system.this.id
}

output "efs_arn" {
    description = "Amazon Resource Name of the file system."
    value       = aws_efs_file_system.this.arn
}

output "efs_dns" {
    description = "The DNS name for the filesystem."
    value       = aws_efs_file_system.this.dns_name
}

output "efs_mounts" {
    description = "The DNS name for the filesystem mount targets."
    value       = { for subnet, target in aws_efs_mount_target.this: 
                                                    subnet => {
                                                                dns_name = target.mount_target_dns_name
                                                                nic = target.network_interface_id
                                                            }}
}

output "sg_id" {
    description = "The Security Group ID associated to EFS"
    value = var.create_sg ? module.efs_security_group[0].security_group_id : ""
}
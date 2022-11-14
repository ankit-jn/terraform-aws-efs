resource aws_efs_file_system_policy "this" {

    count = (var.attach_efs_policy 
                || var.attach_policy_deny_insecure_transport) ? 1 : 0
    
    file_system_id = aws_efs_file_system.this.id

    bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check

    policy = data.aws_iam_policy_document.compact[0].json
}

## Compact all the policies based on conditions
data aws_iam_policy_document "compact" {

    count = (var.attach_efs_policy 
                || var.attach_policy_deny_insecure_transport) ? 1 : 0

    source_policy_documents = compact([
        var.attach_efs_policy ? data.template_file.policy_template[0].rendered : "",
        var.attach_policy_deny_insecure_transport ? data.aws_iam_policy_document.deny_insecure_transport[0].json : ""
        
    ])
}

## Provided EFS Policy
data template_file "policy_template" {

    count = var.attach_efs_policy ? 1 : 0
    
    template = file("${path.root}/${var.policy_file}")
}

## EFS Policy to implement in-transit data encryption across EFS operations
data aws_iam_policy_document "deny_insecure_transport" {

    count = var.attach_policy_deny_insecure_transport ? 1 : 0

    statement {
        sid    = "DenyInsecureTransport"
        effect = "Deny"

        actions = [
            "elasticfilesystem:*"
        ]

        resources = [
            aws_efs_file_system.this.arn
        ]

        principals {
            type        = "*"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "aws:SecureTransport"
            values    = ["false"]
        }
    }
}
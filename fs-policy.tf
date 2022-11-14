resource aws_efs_file_system_policy "this" {

    count = (var.attach_efs_policy 
                || var.attach_policy_prevent_root_access
                || var.attach_policy_enforce_readonly_access
                || var.attach_policy_prevent_anonymous_access
                || var.attach_policy_enforce_in_transit_encryption) ? 1 : 0
    
    file_system_id = aws_efs_file_system.this.id

    bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check

    policy = data.aws_iam_policy_document.compact[0].json
}

## Compact all the policies based on conditions
data aws_iam_policy_document "compact" {

    count = (var.attach_efs_policy 
                || var.attach_policy_prevent_root_access
                || var.attach_policy_enforce_readonly_access
                || var.attach_policy_prevent_anonymous_access
                || var.attach_policy_enforce_in_transit_encryption) ? 1 : 0

    source_policy_documents = compact([
        var.attach_efs_policy ? data.template_file.policy_template[0].rendered : "",
        var.attach_policy_prevent_root_access ? data.aws_iam_policy_document.prevent_root_access[0].json : "",
        var.attach_policy_enforce_readonly_access ? data.aws_iam_policy_document.enforce_readonly_access[0].json : "",
        var.attach_policy_prevent_anonymous_access ? data.aws_iam_policy_document.prevent_anonymous_access[0].json : "",
        var.attach_policy_enforce_in_transit_encryption ? data.aws_iam_policy_document.enforce_in_transit_encryption[0].json : ""
        
    ])
}

## Provided EFS Policy
data template_file "policy_template" {

    count = var.attach_efs_policy ? 1 : 0
    
    template = file("${path.root}/${var.policy_file}")
}

## EFS Policy to implement - Prevent root access by default*
data aws_iam_policy_document "prevent_root_access" {

    count = var.attach_policy_prevent_root_access ? 1 : 0

    statement {
        sid    = "PreventRootAccess"
        effect = "Allow"

        actions = [
            "elasticfilesystem:ClientWrite",
            "elasticfilesystem:ClientMount"
        ]

        resources = [
            aws_efs_file_system.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "elasticfilesystem:AccessedViaMountTarget"
            values    = ["true"]
        }
    }
}

## EFS Policy to implement - Enforce read-only access by default*
data aws_iam_policy_document "enforce_readonly_access" {

    count = var.attach_policy_enforce_readonly_access ? 1 : 0

    statement {
        sid    = "EnforceReadonlyAccess"
        effect = "Allow"

        actions = [
            "elasticfilesystem:ClientRootAccess",
            "elasticfilesystem:ClientMount"
        ]

        resources = [
            aws_efs_file_system.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "elasticfilesystem:AccessedViaMountTarget"
            values    = ["true"]
        }
    }
}

## EFS Policy to implement - Prevent anonymous access
data aws_iam_policy_document "prevent_anonymous_access" {

    count = var.attach_policy_prevent_anonymous_access ? 1 : 0

    statement {
        sid    = "PreventAnonymousAccess"
        effect = "Allow"

        actions = [
            "elasticfilesystem:ClientRootAccess",
            "elasticfilesystem:ClientWrite"
        ]

        resources = [
            aws_efs_file_system.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "elasticfilesystem:AccessedViaMountTarget"
            values    = ["true"]
        }
    }
}

## EFS Policy to implement - Enforce in-transit encryption for all clients
data aws_iam_policy_document "enforce_in_transit_encryption" {

    count = var.attach_policy_enforce_in_transit_encryption ? 1 : 0

    statement {
        sid    = "AllowAccessedViaMountTarget"
        effect = "Allow"

        actions = [
            "elasticfilesystem:ClientRootAccess",
            "elasticfilesystem:ClientWrite",
            "elasticfilesystem:ClientMount"
        ]

        resources = [
            aws_efs_file_system.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "elasticfilesystem:AccessedViaMountTarget"
            values    = ["true"]
        }
    }

    statement {
        sid    = "EnforceInTransitEncryption"
        effect = "Deny"

        actions = [ "*" ]

        resources = [
            aws_efs_file_system.this.arn
        ]

        principals {
            type        = "AWS"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "aws:SecureTransport"
            values    = ["false"]
        }
    }
}
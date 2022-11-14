## ARJ-Stack: AWS Elastic File System - Terraform module

A Terraform module for provisioning a simple, serverless, set-and-forget Amazon Elastic File System.

### Resources
This module features the following components to be provisioned with different combinations:

- Elastic File System [[aws_efs_file_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system)]
- Security Group [[aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)]
    - Security Group Attached with EFS
    - Security Group Rules [[aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)]

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

### Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-efs) for effectively utilizing this module.

### Inputs

#### DB Cluster specific properties
---
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|

### Outputs

| Name | Type | Description |
|:------|:------|:------|

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-efs/graphs/contributors).


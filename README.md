## ARJ-Stack: AWS Elastic File System - Terraform module

A Terraform module for provisioning a simple, serverless, set-and-forget Amazon Elastic File System.

### Resources
This module features the following components to be provisioned with different combinations:

- Elastic File System [[aws_efs_file_system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system)]
- EFS Backup Policy [[aws_efs_backup_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy)]
- EFS Mount Targets [[aws_efs_mount_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target)]
- EFS Policy [[aws_efs_file_system_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy)]
- KMS Key [[aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)]
- KMS Key Aliases [[aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)]
- KMS Key Policy [[Key Policy](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html)]
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

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="name"></a> [name](#input\_name) | File System Name | `string` |  | yes |
| <a name="availability_zone_name"></a> [availability_zone_name](#input\_availability\_zone\_name) | The AWS Availability Zone in which to create the file system if One Zone EFS. | `string` | `null` | no |
| <a name="performance_mode"></a> [performance_mode](#input\_performance\_mode) | The file system performance mode. | `string` | `generalPurpose` | no |
| <a name="throughput_mode"></a> [throughput_mode](#input\_throughput\_mode) | Throughput mode for the file system. | `string` | `bursting` | no |
| <a name="provisioned_throughput_in_mibps"></a> [provisioned_throughput_in_mibps](#input\_provisioned\_throughput\_in\_mibps) | The throughput, measured in MiB/s, that you want to provision for the file system. | `number` | `null` | no |
| <a name="transition_to_ia"></a> [transition_to_ia](#input\_transition\_to\_ia) | Time in Number of Days, the files should be transitioned from Standard to Standard-Infrequent Access. | `number` | `0` | no |
| <a name="transition_from_ia"></a> [transition_from_ia](#input\_transition\_from\_ia) | Flag to decide if the files should be transitioned back from Standard-Infrequent Access to Standard. | `bool` | `false` | no |
| <a name="enable_backup"></a> [enable_backup](#input\_enable\_backup) | Flag to decide if BAckup should be enabled. | `bool` | `true` | no |
| <a name="mount_targets"></a> [mount_targets](#input\_mount\_targets) | List of configuration EFS mount targets | `list` | `[]` | no |
| <a name="default_tags"></a> [default_tags](#input\_default\_tags) | A map of tags to assign to all the resource. | `map(string)` | `{}` | no |

#### Encryption Properties

- `create_kms_key` set as `true` takes preference over `kms_key`
- `kms_key` could be either of this format:
    - 1234abcd-12ab-34cd-56ef-1234567890ab
    - arn:aws:kms:<region>:<account no>:key/1234abcd-12ab-34cd-56ef-1234567890ab
    - alias/my-key
    - arn:aws:kms:<region>:<account no>:alias/my-key

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="encrypt_disk"></a> [encrypt_disk](#input\_encrypt\_disk) | Flag to decide if Disk will be encrypted | `bool` | `true` | no |
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | Existing KMS key to encrypt the disk. | `string` | `null` | no |
| <a name="create_kms_key"></a> [create_kms_key](#input\_create\_kms\_key) | Flag to decide if new KMS key (symmetric, encrypt/decrypt) is required for Disk encryption | `bool` | `true` | no |

#### EFS Policy Properties

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="attach_efs_policy"></a> [attach_efs_policy](#input\_attach\_efs\_policy) | Flag to decide if policy should be atatched for EFS file system. | `bool` | `false` | no |
| <a name="policy_file"></a> [policy_file](#input\_policy\_file) | Policy File name with path relative to root directory. | `string` | `"policies/policy.json"` | no |
| <a name="bypass_policy_lockout_safety_check"></a> [bypass_policy_lockout_safety_check](#input\_bypass\_policy\_lockout\_safety\_check) | Flag to decide whether to bypass the `aws_efs_file_system_policy` lockout safety check. | `bool` | `false` | no |
| <a name="attach_policy_prevent_root_access"></a> [attach_policy_prevent_root_access](#input\_attach\_policy\_prevent_root_access) | Flag to decide for implementing policy to prevent root access. | `bool` | `false` | no |
| <a name="attach_policy_enforce_readonly_access"></a> [attach_policy_enforce_readonly_access](#input\_attach\_policy\_enforce_readonly_access) | Flag to decide for implementing policy to enforce read only access. | `bool` | `false` | no |
| <a name="attach_policy_prevent_anonymous_access"></a> [attach_policy_prevent_anonymous_access](#input\_attach\_policy\_prevent_anonymous_access) | Flag to decide for implementing policy to prvent anonymous access. | `bool` | `false` | no |
| <a name="attach_policy_enforce_in_transit_encryption"></a> [attach_policy_enforce_in_transit_encryption](#input\_attach\_policy\_enforce_in_transit_encryption) | Flag to decide for implementing policy to enforce In Transit Encryption. | `bool` | `false` | no |

#### EFS Security Properties

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="create_sg"></a> [create_sg](#input\_create\_sg) | Flag to decide to create Security Group for EFS | `bool` | `false` | no |  |
| <a name="vpc_id"></a> [vpc_id](#input\_vpc\_id) | The ID of VPC that is used to provision the Security Group. | `string` | `""` | no |  |
| <a name="sg_name"></a> [sg_name](#input\_sg\_name) | The name of the Security group | `string` | `""` | no |  |
| <a name="sg_rules"></a> [sg_rules](#sg\_rules) | Configuration map for Security Group Rules | `map` | `{}` | no | <pre>{<br>   ingress = [<br>      {<br>        rule_name = "Self Ingress Rule"<br>        description = "Self Ingress Rule"<br>        from_port =0<br>        to_port = 0<br>        protocol = "-1"<br>        self = true<br>      },<br>      {<br>        rule_name = "Ingress from IPv4 CIDR"<br>        description = "IPv4 Rule"<br>        from_port = 2049<br>        to_port = 2049<br>        protocol = "tcp"<br>        cidr_blocks = [<br>          "xx.xx.xx.xx/xx",<br>          "yy.yy.yy.yy/yy"<br>        ]<br>      }<br>   ]<br>   egress =[<br>      {<br>        rule_name = "Self Egress Rule"<br>        description = "Self Egress Rule"<br>        from_port =0<br>        to_port = 0<br>        protocol = "-1"<br>        self = true<br>      }<br>   ]<br>} |
| <a name="allowed_sg"></a> [allowed_sg](#input\_allowed\_sg) | List of Source Security Group IDs defined in Ingress of the created SG | `list(string` | `[]` | no | |
| <a name="additional_sg"></a> [additional_sg](#input\_additional\_sg) | List of Existing Security Group IDs associated with EFS. | `list(string` | `[]` | no | |

### Nested Configuration Maps: 

#### sg_rules
[ Ingress / Egress ]

- Map of Security Group Rules with 2 Keys `ingress` and `egress`.
- The value for each key will be a list of Security group rules where each entry of the list will again be a map of SG Rule Configuration

Refer [SG Rules Configuration](https://github.com/arjstack/terraform-aws-security-groups/blob/v1.0.0/README.md#security-group-rule--ingress--egress-) for the structure

### Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="efs_id"></a> [efs_id](#output\_efs\_id) | `string` | The ID that identifies the file system |
| <a name="efs_arn"></a> [efs_arn](#output\_efs\_arn) | `string` | Amazon Resource Name of the file system |
| <a name="efs_dns"></a> [efs_dns](#output\_efs\_dns) | `string` | The DNS name for the filesystem |
| <a name="efs_mounts"></a> [efs_mounts](#output\_efs\_mounts) | `map` | The DNS name for the filesystem mount targets.<br><b>Map Key:</b> Subnet ID<br><b>Map Value:</b> Nested map of the following attributes:<br>&nbsp;&nbsp;&nbsp;`dns_name` - The DNS name for the given subnet/AZ<br>&nbsp;&nbsp;&nbsp;`nic` - The ID of the network interface that Amazon EFS created when it created the mount target. |
| <a name="sg_id"></a> [sg_id](#output\_sg\_id) | `string` | The Security Group ID associated to EFS |

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-efs/graphs/contributors).



variable "name" {
    description = "File System Name"
    type        = string
}

variable "mount_targets" {
    description = <<EOF
List of configuration EFS mount targets where each entry of the list is a map of the following property:

subnet_id       : (Required) The ID of the subnet to add the mount target in.
ip_address      : (Optional) The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target.
security_groups : (Optional) List of Security Groups along with EFS cluster Level Security Group (if provisioned) to be attached with Mount target.

EOF
}

variable "create_sg" {
    description = "Flag to decide to create Security Group for EFS"
    type        = bool
    default     = false
}

variable "vpc_id" {
  description   = "The ID of VPC that is used to provision the Security Group"
  type          = string 
  default       = ""
}

variable "sg_name" {
    description = "The name of the Security group"
    type        = string
    default     = ""
}

variable "sg_rules" {
    description = <<EOF
(Optional) Map of Security Group Rules with 2 Keys ingress and egress.
The value for each key will be a list of Security group rules where 
each entry of the list will again be a map of SG Rule Configuration	
SG Rules Configuration: Refer (https://github.com/arjstack/terraform-aws-security-groups/blob/v1.0.0/README.md#security-group-rule--ingress--egress-)
EOF
    default = {}
}

variable "allowed_sg" {
    description = "List of Source Security Group IDs defined in Ingress of the created SG"
    type        = list(string)
    default     = []
}

variable "additional_sg" {
    description = "(Optional) List of Existing Security Group IDs associated with EFS."
    type        = list(string)
    default     = []
}

variable "default_tags" {
    description = "A map of tags to assign to all the resources."
    type        = map(string)
    default     = {}
}
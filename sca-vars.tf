## SCA CI rig variables

# Admin ip address range
variable "sca_admin_ip"
{
  type = "string"
  default = "139.59.150.107/32"
}

# Other ip address range
variable "sca_world_ip"
{
  type = "string"
  default = "0.0.0.0/0"
}

# Rig key. Used for provisioning, configuration and access.
variable "sca_key_pub" {
  type    = "string"
  default = "/home/user/.ssh/sca-rig.pub"
}

variable "sca_key_ppk" {
  type    = "string"
  default = "/home/user/.ssh/sca-rig.ppk"
}

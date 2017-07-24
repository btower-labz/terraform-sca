variable "sca_admin_ip"
{
  type = "string"
  default = "139.59.150.107/32"
}

variable "sca_world_ip"
{
  type = "string"
  default = "0.0.0.0/0"
}

variable "sca_key_pub" {
  type    = "string"
  default = "/home/user/.ssh/sca-rig.pub"
}

variable "sca_key_ppk" {
  type    = "string"
  default = "/home/user/.ssh/sca-rig.ppk"
}


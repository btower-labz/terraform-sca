### SCA CI cloud providers

###
## Configure AWS
variable "rig_aws_region" {
  type = "string"
  default = "us-west-2"
}

variable "rig_aws_file" {
  type = "string"
  default = "/home/user/.aws/credentials"
}

variable "rig_aws_profile" {
  type = "string"
  default = "staging"
}

provider "aws" {
  alias = "sca"
  region = "${var.rig_aws_region}"
  shared_credentials_file = "${var.rig_aws_file}"
  profile = "${var.rig_aws_profile}"
}

###
## Configure DigitalOcean
variable "digital_ocean_zone" {
  type = "string"
  default = "nyc3"
}

provider "digitalocean" {
  alias = "sca"
  token = "${trimspace(file("/home/user/.doc/doc-write"))}"
}

###
## Configure GoogleCloud
variable "rig_gcp_file" {
  type = "string"
  default = "/home/user/.gcp/gcp-new"
}

variable "rig_gcp_region" {
  type = "string"
  default = "europe-west2"
}

variable "rig_gcp_zone" {
  type = "string"
  default = "europe-west2-c"
}

variable "rig_gcp_project" {
  type = "string"
  default = "btowerlabz-sca"
}

variable "rig_gcp_user" {
  type = "string"
  default = "labz"
}

provider "google" {
  alias       = "sca"
  credentials = "${trimspace(file(var.rig_gcp_file))}"
  project     = "${var.rig_gcp_project}"
  region      = "${var.rig_gcp_region}"
}

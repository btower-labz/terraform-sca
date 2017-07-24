# Configure AWS
provider "aws" {
  
  alias = "sca"

  # Region still required
  region = "us-west-2"

  # this one has to be set up with credentials and profile
  shared_credentials_file = "/home/user/.aws/credentials"
  profile = "staging"

}

# Configure DigitalOcean
provider "digitalocean" {
  alias = "sca"
  token = "${trimspace(file("/home/user/.doc/doc-write"))}"
}

variable "digital_ocean_zone" {
  type = "string"
  default = "nyc3"  
}

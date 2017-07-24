# Define build environment
provider "aws" {
  
  alias = "sca"

  # Region still required
  region = "us-west-2"

  # this one has to be set up with credentials and profile
  shared_credentials_file = "/home/user/.aws/credentials"
  profile = "staging"

}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  alias = "sca"
  token = "${file("/home/user/.doc/credentials")}"
}

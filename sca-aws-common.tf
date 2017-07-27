##
# Define build image access key
resource "aws_key_pair" "sca" {
  # Use our provider for the build
  provider = "aws.sca"
  key_name   = "sca-key"
  public_key = "${file("${var.sca_key_pub}")}"
}


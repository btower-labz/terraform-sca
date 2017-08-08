# SCA CI slave aws instance

resource "aws_security_group" "sca_cislave_sec" {
  name        = "sca_cislave_sec"
  description = "SCA CISlave Security Group"
  provider = "aws.sca"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.sca_admin_ip}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "${var.sca_admin_ip}",
      "${var.sca_world_ip}"
    ]
  }

  tags {
    env = "staging"
    project = "sca"
  }
}

# Define base image parameters.
data "aws_ami" "cislave" {

  # Use our provider for the build
  provider = "aws.sca"

  # One can filter by regex
  # name_regex = "^amzn-ami.+\\d+.+gp2$"

  # In case there is multiple images, use recent on.
  most_recent = true

  # Filter ami images by name
  filter {
    name   = "name"
    values = [ 
      "amzn-ami-hvm-*-x86_64-gp2" 
    ]
  }

  # Filter by VT
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # One can filter by owner id
  # owners = ["099720109477"]
}

# Describe resource
resource "aws_instance" "cislave" {

  # Use defined build environment
  provider = "aws.sca"

  # User defined build image
  ami           = "${data.aws_ami.cislave.id}"
  instance_type = "t2.micro"
  
  # number of slaves
  count = "${var.sca_aws_cislave_count}"

  # Use builder ssh key
  key_name = "sca-key"

  security_groups = [
   "${aws_security_group.sca_cislave_sec.name}"
  ]

  tags {
    Name = "SCA CI Slave ${count.index}"
    env = "staging"
    class = "cislave"
    project = "sca"
  }

  # Deploy provision script
  provisioner "file" {
    source      = "scripts/pro-aws.sh"
    destination = "~/pro-aws.sh"

    connection {
      type = "ssh"
      user = "ec2-user"
      # password = ""
      private_key = "${file(var.sca_key_ppk)}"
      agent = false
    }
  }

  # Execute provision
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      # password = ""
      private_key = "${file(var.sca_key_ppk)}"
      agent = false
    }
    inline = [
     "sudo yum check-update",
     "echo ${self.public_ip}",
     "chmod u+x,g+x,o+x ~/pro-aws.sh",
     "sudo /home/ec2-user/pro-aws.sh"
    ]
  }
}

# TODO: merge with doc and gcp
output "cislave_ip" {
  value = "${aws_instance.cislave.*.public_ip}"
}

output "cislave_id" {
  value = "${aws_instance.cislave.*.id}"
}

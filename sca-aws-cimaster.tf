# SCA CI master aws instance

resource "aws_security_group" "sca_cimaster_sec" {
  name        = "sca_cimaster_sec"
  description = "SCA CIMaster Security Group"
  provider = "aws.sca"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.sca_admin_ip}"]
  }

  # TODO: Place all cislave hosts here. Explicit fashion.
  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = [
      "${var.sca_admin_ip}",
      "${var.sca_world_ip}"
    ]
  }

  # TODO: Place all cislave hosts here. Explicit fashion.
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [
      "${var.sca_admin_ip}",
      "${var.sca_world_ip}"
    ]
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
data "aws_ami" "cimaster" {

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
resource "aws_instance" "cimaster" {

  # Use defined build environment
  provider = "aws.sca"

  # User defined build image
  ami           = "${data.aws_ami.cimaster.id}"
  instance_type = "t2.micro"

  # cimaster aws cloud switch
  count = "${var.sca_cimaster_location == "aws" ? 1 : 0}"

  # Use builder ssh key
  key_name = "sca-key"

  security_groups = [
   "${aws_security_group.sca_cimaster_sec.name}"
  ]

  tags {
    Name = "SCA CI Master"
    env = "staging"
    class = "cimaster"
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
      private_key = "${file("${var.sca_key_ppk}")}"
      agent = false
    }
  }

  # Execute provision
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ec2-user"
      # password = ""
      private_key = "${file("${var.sca_key_ppk}")}"
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

output "cimaster_ip" {
  value = "${aws_instance.cimaster.public_ip}"
}

output "cimaster_id" {
  value = "${aws_instance.cimaster.id}"
}

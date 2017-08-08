# SCA RIG CIMaster GCP Instance
# TODO: firewall

resource "google_compute_instance" "cimaster" {
  provider = "google.sca"
  name         = "sca-cimaster-gcp"
  machine_type = "g1-micro"
  zone         = "${var.rig_gcp_zone}"

  # cimaster gcp cloud switch
  count = "${var.sca_cimaster_location == "gcp" ? 1 : 0}"

  # TODO: try to use labels
  tags = [
    "gcpenvstaging",
    "gcpprojectsca",
    "gcpclasscimaster"
  ]

  disk {
    image = "debian-cloud/debian-9"
  }

  # Disk sample
  #disk {
  #  type    = "local-ssd"
  #  scratch = true
  #}

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  metadata {
    block-project-ssh-keys="false"
    sshKeys = "${var.rig_gcp_user}:${trimspace(file("${var.sca_key_pub}"))}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  # Deploy provision script
  provisioner "file" {
    source      = "scripts/pro-gcp.sh"
    destination = "~/pro-gcp.sh"

    connection {
      type = "ssh"
      user = "labz"
      # password = ""
      private_key = "${file("${var.sca_key_ppk}")}"
      agent = false
    }
  }


  # Execute commands, use copied files.
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "labz"
      private_key = "${file("${var.sca_key_ppk}")}"
      agent = false
    }
    inline = [
     # dbus is must.
     "sudo apt-get update",
     "sudo apt-get install -y dbus",
     "ls -la",
     "sudo ls -la",
     "echo ${self.network_interface.0.access_config.0.assigned_nat_ip}",
     "chmod u+x,g+x,o+x ~/pro-gcp.sh",
     "sudo ~/pro-gcp.sh"
    ]
  }


 # service_account {
 #   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
 # }
}

# TODO: find correct way to get the public ip
output "gcp_cimaster_ip" {
  value = "${google_compute_instance.cimaster.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "gcp_cimaster_id" {
  value = "${google_compute_instance.cimaster.id}"
}

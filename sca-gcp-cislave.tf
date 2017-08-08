# SCA RIG CISlave GCP Instance
# TODO: firewall

resource "google_compute_instance" "cislave" {
  provider = "google.sca"
  name         = "sca-cislave-gcp-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.rig_gcp_zone}"

  count = "${var.sca_gcp_cislave_count}"

  # TODO: try to use labels
  tags = [
    "gcpenvstaging",
    "gcpprojectsca",
    "gcpclasscislave"
  ]

  disk {
    image = "debian-cloud/debian-9"
  }

  # Disk sample
  #disk {
  #  type    = "local-ssd"
  #  scratch = true
  #}

  # TODO: firewall
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

output "gcp_cislave_ip" {
  value = "${google_compute_instance.cislave.*.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "gcp_cislave_id" {
  value = "${google_compute_instance.cislave.*.id}"
}

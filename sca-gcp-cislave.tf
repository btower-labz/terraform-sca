# SCA CI slave doc instance

resource "google_compute_instance" "cislave" {
  provider = "google.sca"
  name         = "sca-cislave-${count.index}"
  machine_type = "f1-micro"
  zone         = "${var.rig_gcp_zone}"

  count = "${var.sca_gcp_cislave_count}"

  # TODO: try to use labels
  tags = [
    "envstaging",
    "projectsca",
    "classcisalve"
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

 # service_account {
 #   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
 # }
}

output "gcp_cislave_ip" {
  value = "${google_compute_instance.cimaster.*.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "gcp_cislave_id" {
  value = "${google_compute_instance.cislave.*.id}"
}

# SCA RIG CIMaster GCP Instance
# TODO: firewall

resource "google_compute_instance" "cimaster" {
  provider = "google.sca"
  name         = "sca-cimaster"
  machine_type = "f1-micro"
  zone         = "${var.rig_gcp_zone}"

  # cimaster gcp cloud switch
  count = "${var.sca_cimaster_location == "gcp" ? 1 : 0}"

  # TODO: try to use labels
  tags = [
    "envstaging",
    "projectsca",
    "classcimaster"
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

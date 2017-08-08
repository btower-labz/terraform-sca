resource "google_compute_instance" "sca-cislave-gcp" {
  
  provider = "google.sca"

  name         = "sca-cislave-${count.index}"
  machine_type = "f1-micro"
  zone         = "${var.rig_gcp_zone}"

  count=3

  # TODO: try to use labels
  /*
  labels {
    env = "staging"
    project = "sca"
    class = "cislave"
  }
  */

  tags = [
    "envstaging",
    "projectsca",
    "classcisalve"
  ]

  disk {
    image = "debian-cloud/debian-9"
  }

  // Local SSD disk
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

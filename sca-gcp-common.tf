# SCA RIG common GCP objects

# Project wide ssh keys
# Do not touch. Use per machine ssh keys.
/*
resource "google_compute_project_metadata" "default" {
  provider = "google.sca"
  metadata {
    sshKeys = "${var.rig_gcp_user}:${trimspace(file("${var.sca_key_pub}"))}"
  }
}
*/

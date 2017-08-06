# SCA CI common gcp objects

# Project wide ssh keys
/*
resource "google_compute_project_metadata" "default" {
  provider = "google.sca"
  metadata {
    sshKeys = "${var.rig_gcp_user}:${trimspace(file("${var.sca_key_pub}"))}"
  }
}
*/


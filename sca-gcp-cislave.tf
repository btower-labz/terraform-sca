/*
resource "google_compute_instance" "default" {
  
  provider = "google.sca"

  name         = "sca002"
  machine_type = "f1-micro"
  zone         = "${var.rig_gcp_region}"

  tags = [ 
    "gcp_class_cislave",
    "gcp_project_sca",
    "gcp_env_staging"
  ]

  disk {
    image = "debian-cloud/debian-9"
  }

  // Local SSD disk
  #disk {
  #  type    = "local-ssd"
  #  scratch = true
  #}

  #network_interface {
  #  network = "default"

 
#   access_config {
 #     // Ephemeral IP
  #  }
  #}

  metadata {
    block-project-ssh-keys="false"
  }


  metadata_startup_script = "echo hi > /test.txt"

 # service_account {
 #   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
 # }
}
*/


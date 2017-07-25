# Create slave 001
resource "digitalocean_droplet" "cislave" {
  provider = "digitalocean.sca"
  image  = "debian-9-x64"
  name   = "sca001"
  region = "${var.digital_ocean_zone}"
  size   = "512mb"
  backups = "false"
  private_networking = "false"
  resize_disk = "false"
  ssh_keys = [ "${digitalocean_ssh_key.sca.fingerprint}" ]
  tags = [
    "${digitalocean_tag.do_project_sca.id}",
    "${digitalocean_tag.do_env_staging.id}",
    "${digitalocean_tag.do_class_cislave.id}",
  ]
}
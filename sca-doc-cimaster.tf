# SCA CI slave doc instance

resource "digitalocean_droplet" "cimaster" {
  provider = "digitalocean.sca"
  image  = "debian-9-x64"
  name   = "sca-cimaster"
  region = "${var.digital_ocean_zone}"
  size   = "512mb"
  backups = "false"
  private_networking = "false"
  resize_disk = "false"

  # cimaster doc cloud switch
  count = "${var.sca_cimaster_location == "doc" ? 1 : 0}"

  ssh_keys = [ "${digitalocean_ssh_key.sca.fingerprint}" ]
  tags = [
    "${digitalocean_tag.do_class_cimaster.id}",
    "${digitalocean_tag.do_project_sca.id}",
    "${digitalocean_tag.do_env_staging.id}"
  ]
}

output "doc_cimaster_ip" {
  value = "${digitalocean_droplet.cimaster.ipv4_address}"
}

output "doc_cimaster_id" {
  value = "${digitalocean_droplet.cimaster.id}"
}

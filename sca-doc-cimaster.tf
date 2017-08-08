# SCA RIG CIMaster DOC Instance
# TODO: firewall

resource "digitalocean_droplet" "cimaster" {
  provider = "digitalocean.sca"
  image  = "debian-9-x64"
  name   = "sca-cimaster-doc"
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

  # Deploy provision script
  provisioner "file" {
    source      = "scripts/pro-doc.sh"
    destination = "~/pro-doc.sh"

    connection {
      type = "ssh"
      user = "user"
      # password = ""
      private_key = "${file("${var.sca_key_ppk}")}"
      agent = false
    }
  }


  # Execute commands, use copied files.
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "user"
      private_key = "${file("${var.sca_key_ppk}")}"
      agent = false
    }
    inline = [
     # dbus is must.
     "ls -la",
     "sudo ls -la",
     "echo ${self.ipv4_address}",
     "chmod u+x,g+x,o+x ~/pro-doc.sh",
     "sudo ~/pro-doc.sh"
    ]
  }

}

output "doc_cimaster_ip" {
  value = "${digitalocean_droplet.cimaster.ipv4_address}"
}

output "doc_cimaster_id" {
  value = "${digitalocean_droplet.cimaster.id}"
}

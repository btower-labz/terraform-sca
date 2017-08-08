# SCA RIG common DOC objects

resource "digitalocean_ssh_key" "sca" {
  provider = "digitalocean.sca"
  name       = "sca-key"
  public_key = "${file("${var.sca_key_pub}")}"
}

# TODO: uncertain tag sort order. it mutate each apply. confirmes tf bug. https://github.com/terraform-providers/terraform-provider-digitalocean/issues/7
resource "digitalocean_tag" "do_project_sca" {
  provider = "digitalocean.sca"
  name = "do_project_sca"
}

resource "digitalocean_tag" "do_env_staging" {
  provider = "digitalocean.sca"
  name = "do_env_staging"
}

resource "digitalocean_tag" "do_class_cislave" {
  provider = "digitalocean.sca"
  name = "do_class_cislave"
}

resource "digitalocean_tag" "do_class_cimaster" {
  provider = "digitalocean.sca"
  name = "do_class_cimaster"
}

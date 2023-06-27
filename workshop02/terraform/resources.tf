
data "digitalocean_ssh_key" "aipc" {
  name = var.do_ssh_key
}

resource "digitalocean_droplet" "codeserver" {
  image  = var.do_image
  name   = "codeserver"
  region = var.do_region
  size   = var.do_size

  ssh_keys = [data.digitalocean_ssh_key.aipc]
}

resource "local_file" "root_at_codeserver" {
  filename = "root@${digitalocean_droplet.codeserver.ipv4_address}"
  content = ""
  file_permission = "0444"
}

resource "local_file" "inventory" {
  filename = "inventory.yaml"
  content = templatefile("inventory.yaml.tftpl", {
    codeserver_ip = digitalocean_droplet.codeserver.ipv4_address
    ssh_private_key = var.ssh_private_key
    codeserver_domain = "codes=server-${digitalocean_droplet.codeserver.ipv4_address}.nip.io"
    codeserver_password = var.codeserver_password
  })
  file_permission = "0444"
}

output "codeserver_ip" {
  value = digitalocean_droplet.codeserver.ipv4_address
}


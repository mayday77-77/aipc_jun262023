
data "digitalocean_ssh_key" "aipc" {
  name = var.do_ssh_key
}

data "digitalocean_droplet_snapshot" "codeserver-snapshot" {
  name_regex  = "^codeserver"
  region      = var.do_region
  most_recent = true
}

/*
output "snapshot" {
  value = data.digitalocean_droplet_snapshot.codeserver-snapshot.id
}
*/

resource "digitalocean_droplet" "codeserver" {
  image = data.digitalocean_droplet_snapshot.codeserver-snapshot.id
  name   = "codeserver"
  region = var.do_region
  size   = var.do_size

  ssh_keys = [data.digitalocean_ssh_key.aipc.id]

  connection {
    type = "ssh"
    user = "root"
    private_key = file(var.ssh_private_key)
    host = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/__CODESERVER_DOMAIN__/${self.ipv4_address}/g' /etc/nginx/sites-available/code-server.conf",
      "sed -i 's/__CODESERVER_PASSWORD__/${var.cs_password}/g' /lib/systemd/system/code-server.service",
      "systemctl daemon-reload",
      "systemctl restart code-server",
      "systemctl restart nginx"
    ]
  }
}

output "codeserver_ip" {
  value = digitalocean_droplet.codeserver.ipv4_address
}

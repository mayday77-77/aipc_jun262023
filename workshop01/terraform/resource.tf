#images
resource "docker_image" "bgg-database" {
  name = "chukmunnlee/bgg-database:${var.database_version}"
}

resource "docker_image" "bgg-backend" {
  name = "chukmunnlee/bgg-backend:${var.backend_version}"
}

resource "docker_network" "bgg-net" {
  name = "${var.app_namespace}-bgg-net"
}

resource "docker_volume" "data-vol" {
  name = "${var.app_namespace}--data-vol"
}

resource "docker_container" "bgg-database" {
  image = docker_image.bgg-backend.id
  name  = "${var.app_namespace}-bgg-database"

  networks_advanced {
    name = docker_network.bgg-net.id
  }

  volumes {
    volume_name = docker_volume.data-vol.name
    container_path = "/var/lib/mqsql"
  }

  ports {
    internal = 3306
    external = 3306
  }
}

resource "docker_container" "bgg-backend" {
  count = var.backend_instance_count
  image = docker_image.bgg-backend.id
  name  = "${var.app_namespace}-bgg-backend-${count.index}"

  networks_advanced {
    name = docker_network.bgg-net.id
  }

  env = [
    "BGG_DB_USER=root",
    "BGG_DB_PASSWORD=changeit",
    "BGG_DB_HOST=${docker_container.bgg-database.name}"
  ]

  ports {
    internal = 3000
  }
}

resource "local_file" "nginx-conf" {
  filename = "nginx.conf"
  content = templatefile("sample.nginx.conf.tftpl", {
    docker_host = var.docker_host,
    ports = docker_container.bgg-backend[*].ports[0].external
  })
}

data "digitalocean_ssh_key" "aipc" {
  name = var.do_ssh_key
}

resource "digitalocean_droplet" "nginx" {
  image  = var.do_image
  name   = "nginx"
  region = var.do_region
  size   = var.do_size
}


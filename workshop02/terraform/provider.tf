terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.28.1"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }
  }
}

provider "digitalocean" {
  # Configuration options
  token = var.do_token
}

provider "docker" {
  host = "tcp://${var.docker_host}:2376"
  cert_path = var.docker_cert_path
}



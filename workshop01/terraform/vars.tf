variable "do_token" {
  sensitive = true

}
variable "docker_cert_path" {}
variable "docker_host" {}
variable "app_namespace" {
  default = "my"
}
variable "database_version" {
  default = "v3.1"
}
variable "backend_version" {
  default = "v3"
}

variable "backend_instance_count" {
  default = 3
}

variable "do_region" {
  default = "sgp1"
}

variable "do_image" {
  default = "ubuntu-20-04-x64"
}

variable "do_size" {
  default = "s-lvcpu-512mb-10gb"
}

variable "do_ssh_key" {
  default = "aipc"
}

#variable "ssh_private_key" {

#}
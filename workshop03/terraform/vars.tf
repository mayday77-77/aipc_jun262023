variable "do_token" {
  sensitive = true
}

variable "do_region" {
  default = "sgp1"
}

variable "do_image" {
  default = "ubuntu-20-04-x64"
}

variable "do_size" {
  default = "s-1vcpu-512mb-10gb"
}

variable "do_ssh_key" {
  default = "aipc"
}

variable "ssh_private_key" {
  default = "/home/fred/.ssh/id_rsa"
}

variable "cs_domain" {
  type = string
  default = "codeserver1"
}

variable "cs_password" {
  type = string
  sensitive = true
}

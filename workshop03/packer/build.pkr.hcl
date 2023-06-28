source digitalocean codeserver {
  api_token = var.do_token
  image = var.do_image
  size =  var.do_size
  region = var.do_region
  ssh_username = "root"
  snapshot_name = "codeserver"
}

build {
  sources = [
    "source.digitalocean.codeserver"
  ]

  provisioner ansible {
    playbook_file = "playbook.yaml"
    ansible_ssh_extra_args = [
      "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
  }

}

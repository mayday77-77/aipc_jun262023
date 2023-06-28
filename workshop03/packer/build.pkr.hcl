source digitalocean codeserver {
  api_token = var.do_token
  image = var.do_image
  size =  var.do_size
  ssh_username = "root"
  snapshot_name = "codeserver"
}

build {
  sources = {
    "source.digitalocean.codeserver"
  }

  provisioner ansible {
    playbooks_file = "playbooks.yaml"
    ansible_ssh_extra_args = [
      "-oHostKeyAlgorithms=+ssh-rsa -oPublicAcceptedKeyTypes=+ssh-rsa" ]
  }

}
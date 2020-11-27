
###############################################################################
## Specify required providers for terraform.
###############################################################################

terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">= 0.13"
}

###############################################################################
## Setup the Provider using the token in ~/.digitalocean
###############################################################################

data "local_file" "do_token" {
    filename = pathexpand("~/.digitalocean")
}

provider "digitalocean" {
  token = trimspace(data.local_file.do_token.content)
}

###############################################################################
## Create an SSH Key by generating it and then uploading it.
###############################################################################

resource "null_resource" "make_key" {
  provisioner "local-exec" {
    command = "./scripts/create_ssh_key.sh"
  }
}

data "local_file" "key" {
  filename = ".gen/id_rsa.pub"
  depends_on = [null_resource.make_key]
}

resource "digitalocean_ssh_key" "default" {
  name = "Terraform Key"
  public_key = data.local_file.key.content
}

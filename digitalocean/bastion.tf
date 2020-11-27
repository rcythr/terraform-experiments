
###############################################################################
## Create the bastion host.
###############################################################################

resource "digitalocean_droplet" "bastion" {
  count              = 1
  image              = "ubuntu-20-10-x64"
  name               = "experiment-bastion-${count.index}"
  region             = var.region
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [digitalocean_ssh_key.default.id]
  vpc_uuid           = digitalocean_vpc.experiment.id
}

###############################################################################
## Bastion's Firewall
###############################################################################

resource "digitalocean_firewall" "bastion" {
  name        = "bastion-only-22"
  droplet_ids = digitalocean_droplet.bastion.*.id

  inbound_rule {
    protocol   = "tcp"
    port_range = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

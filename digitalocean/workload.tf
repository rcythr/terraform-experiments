
###############################################################################
## Create the workload hosts.
###############################################################################

resource "digitalocean_droplet" "workload" {
  count              = 2
  image              = "ubuntu-20-10-x64"
  name               = "experiment-workload-${count.index}"
  region             = var.region
  size               = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys           = [digitalocean_ssh_key.default.id]
  vpc_uuid           = digitalocean_vpc.experiment.id
}

###############################################################################
## Workload's Firewall
###############################################################################

resource "digitalocean_firewall" "workload" {
  name        = "workload-only-22"
  droplet_ids = digitalocean_droplet.workload.*.id

  inbound_rule {
    protocol   = "tcp"
    port_range = "22"
    source_addresses = ["10.0.0.0/16"]
  }

  outbound_rule {
    protocol = "tcp"
    port_range = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}


###############################################################################
## Create the VPC
###############################################################################

resource "digitalocean_vpc" "experiment" {
  name     = "experiment"
  region   = var.region
  ip_range = "10.0.0.0/16"
}

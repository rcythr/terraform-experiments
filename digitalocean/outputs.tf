
output "bastion_host" {
  value = digitalocean_instance.bastion
}

output "workload_hosts" {
  value = digitalocean_instance.workload
}


output "bastion_host" {
  value = aws_instance.bastion
}

output "workload_hosts" {
  value = aws_instance.workload
}

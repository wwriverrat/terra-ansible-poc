
output "ci_server_public_ips" {
  description = "The IP address and name of the CI instances"
  value = [
    format("%s %s", aws_instance.ci_server.public_ip, aws_instance.ci_server.tags.Name)
  ]
}

output "database_public_ips" {
  description = "The IP address and name of the DB instances"
  value = [
    for k, v in aws_instance.db_server : format("%s %s", v.public_ip, v.tags.Name)
  ]
}

output "database_dns_names" {
  description = "The name and IP address of the DB instances"
  value = [
    for k, v in aws_instance.db_server : v.public_dns
  ]
}

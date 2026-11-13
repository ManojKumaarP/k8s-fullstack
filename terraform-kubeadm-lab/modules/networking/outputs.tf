output "vpc_id" {
  description = "Created VPC ID"
  value       = aws_vpc.main.id
}
output "subnet_ids" {
  description = "Created Subnet IDs"
  value = {
    for az, subnet in aws_subnet.main : az => subnet.id
  }
}

output "internet_gateway_id" {
  description = "Created Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "route_table_id" {
  description = "Created Route Table ID"
  value       = aws_route_table.public.id
}

output "security_group_id" {
  description = "Created Security Group ID"
  value       = aws_security_group.kubeadm.id
}
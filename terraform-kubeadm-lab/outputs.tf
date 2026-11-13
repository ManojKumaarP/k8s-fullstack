output "availability_zones" {
  description = "Available availability zones"
  value       = data.aws_availability_zones.available.names
}

/*output "vpc_cidr" {
  description = "The CIDR block of the new terraform managed VPC"
  value       = aws_vpc.kubeadm_vpc.cidr_block
}*/

output "vpc_id" {
  description = "VPC ID returned by networking module"
  value       = module.networking.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs returned by networking module"
  value       = module.networking.subnet_ids
}

output "internet_gateway_id" {
  description = "Internet Gateway ID returned by networking module"
  value       = module.networking.internet_gateway_id
}

output "route_table_id" {
  description = "Route Table ID returned by networking module"
  value       = module.networking.route_table_id
}

output "security_group_id" {
  description = "Security Group ID returned by networking module"
  value       = module.networking.security_group_id
}

output "ssh_key_name" {
  description = "The name of the key pair used for SSH access"
  value       = module.compute.ssh_key_name
}

output "ec2_instance_ids" {
  value = module.compute.instance_ids
}

output "ec2_private_ips" {
  value = module.compute.private_ips
}

output "ec2_public_ips" {
  value = module.compute.public_ips
}

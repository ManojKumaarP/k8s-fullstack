output "ssh_key_name" {
  value       = aws_key_pair.kubeadm.key_name
  description = "The name of the key pair used for SSH access"
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value = {
    for name, instance in aws_instance.kubeadm :
    name => instance.id
  }
}

output "private_ips" {
  description = "Private IP addresses of Kubernetes nodes"
  value = {
    for name, instance in aws_instance.kubeadm :
    name => instance.private_ip
  }
}

output "public_ips" {
  description = "Public IP addresses of Kubernetes nodes"
  value = {
    for name, instance in aws_instance.kubeadm :
    name => instance.public_ip
  }
}
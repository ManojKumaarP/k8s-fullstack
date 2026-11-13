variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
}

variable "subnet_ids" {
  description = "Map of availability zones to subnet IDs"
  type        = map(string)
}

variable "security_group_id" {
  description = "Security group ID for Kubernetes nodes"
  type        = string
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Local SSH public key path"
  type        = string
}

variable "common_tags" {
  description = "Common tags for AWS resources"
  type        = map(string)
}

variable "nodes" {
  description = "Kubernetes node definitions"
  type = map(object({
    role = string
    az   = string
  }))
}
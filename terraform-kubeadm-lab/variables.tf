variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
  //default     = "ap-south-1"

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  //default     = "10.50.0.0/16"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  //default     = "terraform-kubeadm-lab"
}

variable "environment" {
  description = "The environment for the resources"
  type        = string
  //default     = "Dev"
}

variable "admin_cidr" {
  description = "Public IPV4 allowed to ssh k8s nodes"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.admin_cidr)) && can(regex("/32$", var.admin_cidr))
    error_message = "The admin_cidr variable must be a valid CIDR block with a /32 subnet mask."
  }
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  //default     = "terraform-kubeadm-lab-key"
}

variable "public_key_path" {
  description = "The path to the public key file for the key pair"
  type        = string
  //default     = "~/.ssh/terraform-kubeadm-lab-key.pub"
}

variable "node_instance_type" {
  description = "The instance type for the nodes"
  type        = string
  //default     = "t3.medium"
}

variable "root_volume_size" {
  description = "The size of the root volume in GB"
  type        = number
  //default     = 30
}

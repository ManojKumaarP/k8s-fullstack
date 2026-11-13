terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-kubeadm-state-877326605500"
    key          = "kubeadm/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}


locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = var.project_name
  }


  # Project name in uppercase
  uppercase_name = upper(var.project_name)

  # Calculate subnet CIDRs from VPC CIDR
  subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 0),
    cidrsubnet(var.vpc_cidr, 8, 1),
    cidrsubnet(var.vpc_cidr, 8, 2)
  ]

  # Select instance type based on environment
  selected_instance_type = var.environment == "dev" ? "t2.micro" : "t2.medium"

  nodes = {
    control-plane = {
      role = "control-plane"
      az   = "ap-south-1a"
    }

    worker-1 = {
      role = "worker"
      az   = "ap-south-1b"
    }

    worker-2 = {
      role = "worker"
      az   = "ap-south-1c"
    }
  }
}

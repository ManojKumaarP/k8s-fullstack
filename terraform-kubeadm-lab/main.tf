data "aws_availability_zones" "available" {
  state = "available"
}

/*resource "aws_vpc" "kubeadm_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-vpc"
    }
  )
}*/

/*module "networking" {
  source = "./modules/networking"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
}*/

module "networking" {
  source             = "./modules/networking"
  vpc_cidr           = var.vpc_cidr
  project_name       = var.project_name
  availability_zones = data.aws_availability_zones.available.names
  subnet_cidrs       = local.subnet_cidrs
  admin_cidr         = var.admin_cidr
}

module "compute" {
  source = "./modules/compute"

  ami_id           = data.aws_ami.ubuntu.id
  instance_type    = var.node_instance_type
  root_volume_size = var.root_volume_size

  subnet_ids        = module.networking.subnet_ids
  security_group_id = module.networking.security_group_id

  key_name        = var.key_name
  public_key_path = var.public_key_path
  common_tags     = local.common_tags
  nodes           = local.nodes
}

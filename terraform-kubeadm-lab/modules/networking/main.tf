resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name      = "${var.project_name}-vpc"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "main" {
  for_each = {
    for index, az in var.availability_zones :
    az => var.subnet_cidrs[index]
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.project_name}-${each.key}-subnet"
    ManagedBy = "Terraform"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-igw"
    ManagedBy = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-route-table"
    ManagedBy = "Terraform"
  }
}

resource "aws_route" "main" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.main

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "kubeadm" {
  name        = "${var.project_name}-kubeadm-sg"
  description = "Security group for kubeadm nodes"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-kubeadm-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.kubeadm.id

  description = "Allow SSH inbound traffic"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = var.admin_cidr
}

resource "aws_vpc_security_group_ingress_rule" "node_internal" {
  security_group_id            = aws_security_group.kubeadm.id
  description                  = "Allow internal traffic between nodes"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.kubeadm.id

  /*AWS Security Groups, ip_protocol = "-1" allows all IP traffic, including:
TCP UDP ICMP Other IP protocols*/
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.kubeadm.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
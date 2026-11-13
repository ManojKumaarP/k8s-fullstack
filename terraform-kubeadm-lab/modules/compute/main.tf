resource "aws_key_pair" "kubeadm" {
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))

  tags = merge(
    var.common_tags,
    {
      Name = var.key_name
    }
  )
}

resource "aws_instance" "kubeadm" {
  for_each = var.nodes

  ami           = var.ami_id
  instance_type = var.instance_type

  availability_zone = each.value.az
  subnet_id         = var.subnet_ids[each.value.az]

  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.kubeadm.key_name

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = merge(
      var.common_tags,
      {
        Name = "${each.key}-root-volume"
      }
    )
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Role = each.value.role
    }
  )
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-kubeadm-state-877326605500"
  tags = {
    Name      = "terraform-kubeadm-state"
    ManagedBy = "Terraform"
    Purpose   = "Terraform Remote State"
  }

}

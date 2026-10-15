terraform {
  required_version = ">= 1.0.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "devops_lab" {
  filename = "${path.module}/terraform-lab.txt"

  content = <<-EOT
    Terraform + Jenkins Integration Lab
    ------------------------------------
    Managed by Terraform.
    Environment: DevOps Learning Lab
    Purpose: Validate Terraform execution in Jenkins.
  EOT
}
variable "repo_root" { type = string }
variable "path_from_root" { type = string }

resource "terraform_data" "unit" {
  input = "a-v2"
}

output "repo_root" { value = var.repo_root }
output "path_from_root" { value = var.path_from_root }

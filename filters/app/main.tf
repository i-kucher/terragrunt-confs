variable "vpc_name" { type = string }
variable "path_from_repo_root" { type = string }

terraform {
  required_providers {
    google = { source = "hashicorp/google" }
  }
}

# Needs the provider configuration Scalr writes into the unit: proves the worktree hook.
data "google_storage_bucket" "state" {
  name = "tg-state-backend"
}

resource "null_resource" "app" {}

output "name" { value = "app" }
output "state_bucket" { value = data.google_storage_bucket.state.self_link }
output "path_from_repo_root" { value = var.path_from_repo_root }

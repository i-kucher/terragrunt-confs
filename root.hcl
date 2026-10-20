# Plan-only fixture: an HTTP state address that answers 404 reads as empty state,
# so the units need no credentials. Scalr rejects the local backend for run-all.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
terraform {
  backend "http" {
    address = "https://mainiacp.ik-git-permissions.testenv.scalr.dev/__ik-gitperm-state/${basename(get_terragrunt_dir())}"
  }
}
EOT
}

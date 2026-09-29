# State management is disabled for the workspace (run-all requires it), so each
# unit needs its own backend. A local backend keeps the fixture self-contained.
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
terraform {
  backend "local" {}
}
EOT
}

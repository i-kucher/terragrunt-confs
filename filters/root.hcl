# run-all requires the workspace-managed backend to be disabled, so each unit
# declares its own. Scalr's own remote backend keeps the fixture free of any
# cloud account: one state workspace per unit, named after its directory.
# Point SCALR_HOSTNAME / SCALR_ENVIRONMENT_ID at the target installation with
# workspace shell variables.
locals {
  unit = basename(get_terragrunt_dir())
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
terraform {
  backend "remote" {
    hostname     = "${get_env("SCALR_HOSTNAME")}"
    organization = "${get_env("SCALR_ENVIRONMENT_ID")}"

    workspaces {
      name = "tgfilters-state-${local.unit}"
    }
  }
}
EOT
}

# run-all requires the workspace-managed backend to be disabled, so each unit
# declares its own. One GCS prefix per unit keeps their states apart.
locals {
  unit = basename(get_terragrunt_dir())
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
terraform {
  backend "gcs" {
    bucket = "${get_env("TG_STATE_BUCKET", "tg-state-backend")}"
    prefix = "tgfilters/${local.unit}"
  }
}
EOT
}

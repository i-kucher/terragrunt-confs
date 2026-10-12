terraform {
  backend "remote" {
    hostname     = "mainiacp.ik-tg-filters.testenv.scalr.dev"
    organization = "env-v0peqqittktdl3vsq"

    workspaces {
      name = "r2st-b3-app"
    }
  }
}

resource "terraform_data" "this" {
  input = "app"
}

output "name" {
  value = terraform_data.this.output
}

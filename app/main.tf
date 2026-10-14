terraform {
  backend "remote" {
    hostname     = "mainiacp.ik-tg-filters.testenv.scalr.dev"
    organization = "env-v0peqqittktdl3vsq"

    workspaces {
      name = "r3st-app"
    }
  }
}

resource "terraform_data" "this" {
  input = "app"
}

output "name" {
  value = terraform_data.this.output
}

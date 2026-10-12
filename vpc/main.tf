terraform {
  backend "remote" {
    hostname     = "mainiacp.ik-tg-filters.testenv.scalr.dev"
    organization = "env-v0peqqittktdl3vsq"

    workspaces {
      name = "r2st-a1-vpc"
    }
  }
}

resource "terraform_data" "this" {
  input = "vpc"
}

output "name" {
  value = terraform_data.this.output
}

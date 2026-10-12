terraform {
  backend "inmem" {}
}

resource "terraform_data" "this" {
  input = "vpc"
}

output "name" {
  value = terraform_data.this.output
}

terraform {
  backend "inmem" {}
}

resource "terraform_data" "this" {
  input = "db"
}

output "name" {
  value = terraform_data.this.output
}

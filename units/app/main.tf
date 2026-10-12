terraform {
  backend "inmem" {}
}

resource "terraform_data" "this" {
  input = "app"
}

output "name" {
  value = terraform_data.this.output
}

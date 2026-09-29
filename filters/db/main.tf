variable "vpc_name" { type = string }

resource "null_resource" "db" {}

output "name" { value = "db" }

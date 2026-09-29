variable "vpc_name" { type = string }

resource "null_resource" "app" {}

output "name" { value = "app" }

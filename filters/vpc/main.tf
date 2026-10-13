resource "null_resource" "vpc" {}

output "name" { value = "vpc" }

output "touched" { value = "vpc changed with HEAD~1 filter" }

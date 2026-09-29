include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "vpc" {
  config_path  = "../vpc"
  mock_outputs = { name = "mock-vpc" }
}

inputs = {
  vpc_name = dependency.vpc.outputs.name
}

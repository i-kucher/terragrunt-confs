include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  repo_root      = get_repo_root()
  path_from_root = get_path_from_repo_root()
}

# stale-stack

`terragrunt stack generate` does not delete stale units: it writes the units
declared in `terragrunt.stack.hcl` and leaves everything else in
`.terragrunt-stack` as is.

This fixture has a committed `.terragrunt-stack` with 3 units (vpc, db, app)
while the stack file declares 2. The app unit was removed from the stack file,
its generated dir stayed.

Tested with terragrunt 1.0.0 / OpenTofu 1.9.0. Applies to terragrunt >= 0.79.

## Reproduce

1. Generate. The log mentions only db and vpc, app stays on disk:

```console
$ terragrunt stack generate --non-interactive

INFO   Generating unit db from ./terragrunt.stack.hcl
INFO   Generating unit vpc from ./terragrunt.stack.hcl

$ ls .terragrunt-stack/

app  db  vpc
```

2. Plan. The removed unit is in the queue:

```console
$ terragrunt run --all plan --out-dir=$(pwd)/plans --non-interactive 2>&1 | grep 'Unit'

- Unit .terragrunt-stack/app
- Unit .terragrunt-stack/db
- Unit .terragrunt-stack/vpc
- Unit units/db
- Unit units/vpc
```

3. Apply. The app unit applied:

```console
$ terragrunt run --all apply --out-dir=$(pwd)/plans --non-interactive 2>&1 \ | grep -E '^- Unit|app|Succeeded|Failed'

INFO   Unit queue will be processed for apply in this order:
- Unit .terragrunt-stack/app
- Unit .terragrunt-stack/db
- Unit .terragrunt-stack/vpc
- Unit units/db
- Unit units/vpc
INFO   [.terragrunt-stack/app] tofu: Initializing the backend...
INFO   [.terragrunt-stack/app] tofu: Initializing provider plugins...
INFO   [.terragrunt-stack/app] tofu: OpenTofu has been successfully initialized!
INFO   [.terragrunt-stack/app] tofu:
INFO   [.terragrunt-stack/app] tofu: You may now begin working with OpenTofu. Try running "tofu plan" to see
INFO   [.terragrunt-stack/app] tofu: any changes that are required for your infrastructure. All OpenTofu commands
INFO   [.terragrunt-stack/app] tofu: should now work.
INFO   [.terragrunt-stack/app] tofu: If you ever set or change modules or backend configuration for OpenTofu,
INFO   [.terragrunt-stack/app] tofu: rerun this command to reinitialize your working directory. If you forget, other
INFO   [.terragrunt-stack/app] tofu: commands will detect it and remind you to do so if necessary.
STDOUT [.terragrunt-stack/app] tofu:
STDOUT [.terragrunt-stack/app] tofu: Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
STDOUT [.terragrunt-stack/app] tofu:
STDOUT [.terragrunt-stack/app] tofu: Outputs:
STDOUT [.terragrunt-stack/app] tofu: name = "app"
   Succeeded    5
```

## Fix
```console
$ rm -rf .terragrunt-stack                                                                                                                                                                                  ✔ │ system 

$ terragrunt stack generate                                                                                                                                                                              ✔ │ system 

INFO   Generating unit db from ./terragrunt.stack.hcl
INFO   Generating unit vpc from ./terragrunt.stack.hcl

$ ls .terragrunt-stack                                                                                                                                                                                   ✔ │ system 

db  vpc
```
## Cleanup

```bash
find . -name ".terragrunt-cache" -type d -prune -exec rm -rf {} +
find . -name "*.tfstate*" -delete
rm -rf plans
git checkout .terragrunt-stack
```

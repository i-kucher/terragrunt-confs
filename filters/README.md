# filters

Fixture for `.terragrunt-filters` (SCALRCORE-40295). Three units, `db` and `app`
both depend on `vpc`, so a filter that keeps one unit is visible in discovery
and in the run queue.

Each unit creates a `null_resource`, so an apply leaves real state and a later
destroy has something to target.

Requires terragrunt >= 1.0.0. Older versions ignore the filters file with no
warning and run every unit.

## Discovery

```console
$ terragrunt find --dag --json --non-interactive | jq -r '.[] | "\(.type) \(.path)"'
unit vpc
unit app
unit db

$ echo './app' > .terragrunt-filters

$ terragrunt find --dag --json --non-interactive | jq -r '.[] | "\(.type) \(.path)"'
unit app
```

## Filters union with the targeting flags

A filters file does not narrow an already targeted run, it widens it. Both
expressions land in the same filter list and positive filters are OR'ed:

```console
$ echo './app' > .terragrunt-filters

$ terragrunt run --all --queue-include-dir=vpc --non-interactive -- init
# runs app AND vpc

$ terragrunt run --all --no-filters-file --queue-include-dir=vpc --non-interactive -- init
# runs vpc only
```

## Cleanup

```bash
find . -name ".terragrunt-cache" -type d -prune -exec rm -rf {} +
find . -name "*.tfstate*" -delete
rm -f .terragrunt-filters
```

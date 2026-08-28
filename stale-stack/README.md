# stale-stack

`terragrunt stack generate` is **additive-only**: it writes declared units and
never deletes stale ones. This fixture has a committed `.terragrunt-stack` with
3 units (`vpc`, `db`, `app`) while the stack file declares only 2 — `app` was
removed from `terragrunt.stack.hcl` but its generated dir survived.

Tested: terragrunt 1.0.0 / OpenTofu 1.9.0 (applies to any tg >= 0.79).

## The problem

```bash
terragrunt stack generate --non-interactive
ls .terragrunt-stack/     # app db vpc — stale 'app' survives regeneration

terragrunt run --all plan --out-dir=$(pwd)/plans --non-interactive
# queue includes .terragrunt-stack/app — a unit no declaration mentions
```

In split plan/apply pipelines (apply re-checks-out the repo, planfiles cover
only the declared units) the stale unit hard-errors at apply:

```
Failed to load .../plans/.terragrunt-stack/app/tfplan.tfplan: no such file
Run Summary  Succeeded N-1  Failed 1     <- partial application
```

## The fix

`rm -rf .terragrunt-stack` before any `run --all` — on both the plan and the
apply side. Generation recreates the declared units; planfile paths still match.

## Cleanup

```bash
find . -name ".terragrunt-cache" -type d -prune -exec rm -rf {} + ; rm -rf plans
git checkout .terragrunt-stack   # if an experiment removed the fixture tree
```

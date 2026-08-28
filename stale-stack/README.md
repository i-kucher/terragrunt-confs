# stale-stack

`terragrunt stack generate` is **additive-only**: it writes declared units and
never deletes stale ones. This fixture has a committed `.terragrunt-stack` with
3 units (`vpc`, `db`, `app`) while the stack file declares only 2 — `app` was
removed from `terragrunt.stack.hcl` but its generated dir survived.

Tested: terragrunt 1.0.0 / OpenTofu 1.9.0 (applies to any tg >= 0.79).

## Reproduce

```bash
# 1. generation keeps the stale unit
terragrunt stack generate --non-interactive
ls .terragrunt-stack/
# -> app db vpc         ('app' survives; the log mentions only db, vpc)

# 2. the phantom unit gets planned
terragrunt run --all plan --out-dir=$(pwd)/plans --non-interactive 2>&1 | grep '^- Unit'
# -> - Unit .terragrunt-stack/app   <- present in the queue, no declaration mentions it

# 3. split plan/apply pipeline: clean plan on runner 1...
rm -rf .terragrunt-stack plans
terragrunt run --all plan --out-dir=$(pwd)/plans --non-interactive 2>&1 | grep '^- Unit'
# -> only db, vpc (+ units/*); planfiles exist for exactly these

# 4. ...apply on runner 2 re-checks-out the repo: the committed stale tree is back
git checkout .terragrunt-stack
terragrunt run --all apply --out-dir=$(pwd)/plans --non-interactive
# -> app re-enters the queue, has no planfile:
#      Failed to load .../plans/.terragrunt-stack/app/tfplan.tfplan: no such file
#      Run Summary  Succeeded 4  Failed 1     <- partial application
```

## The fix

`rm -rf .terragrunt-stack` before any `run --all` — on both the plan and the
apply side. Generation recreates the declared units; planfile paths still match.

## Cleanup

```bash
find . -name ".terragrunt-cache" -type d -prune -exec rm -rf {} +
find . -name "*.tfstate*" -delete
rm -rf plans
git checkout .terragrunt-stack
```

# ATYA-024 implementation checkpoint

Date: 2026-07-22

Status: In Progress; manual architecture checkpoint

## Sanitized evidence result

The authorized evidence chain is complete and internally consistent with the refreshed live topology: 29 source workflows use the legacy credential path, all address one publisher role with one dispatch event, four failures have independent downstream migration tasks, and permanent credential replacement remains required. The sole hard dependency is accepted and no other modernization task was active when ATYA-024 entered In Progress.

No private path, repository work list, raw diagnostic, run payload, secret metadata, or exploit detail is reproduced here.

## Prepared artifacts

- Exact sanitized App registration and installation contract
- Source OIDC and bounded dispatch contract
- Threat model and proof that branch, pull-request, fork, and unlisted workflows cannot access the private key under the recommended placement
- Non-active canonical source-workflow migration template
- Permission, topology, credential-placement, ledger, fixture, and sanitization validators
- Safe no-op proof stages
- Sanitized aggregate migration ledger
- Migration, rotation, revocation, rollback, and compromise-recovery procedures

## Scope boundary

No App was registered or installed. No key was generated or downloaded. No variable or secret was created or changed. No App token was minted. No source workflow was changed. No PAT, tag, package, release, or dispatch was mutated. The four downstream migrations remain unstarted.

## Remaining decision

The repository-dispatch endpoint requires Contents write, so installing one App across every source repository would exceed least privilege. The recommended contract installs the App only on the publisher target and keeps its key in an external sign-only managed key vault used by an OIDC-authenticated broker.

The evidence does not prove that the required broker and vault exist. The organization owner must approve this placement and name its accountable service owner, or provide an equivalent non-runner-readable signing service for review. Issue #17 remains open and In Progress until that decision and the later manual checkpoints are completed.

## Validation

- PowerShell 7.6 contract, permission, repository-scope, topology, ledger, fixture, and sanitization validation: passed.
- Negative authorization and contract-mutation cases: passed.
- JSON and CSV parsing: passed.
- YAML parsing and linting: passed.
- Private implementation-plan validator: passed without changing the private plan.
- Git whitespace and patch checks: passed.

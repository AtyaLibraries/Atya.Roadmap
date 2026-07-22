# ATYA-024 implementation checkpoint

Date: 2026-07-22

Status: In Progress; architecture approved, deployment pending

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
- Reviewable Azure Function broker, managed-identity adapters, synthetic security suite, and deployment-only Bicep plan in the designated platform repository

## Scope boundary

No App was registered or installed. No key was generated or downloaded. No variable or secret was created or changed. No App token was minted. No source workflow was changed. No PAT, tag, package, release, or dispatch was mutated. The four downstream migrations remain unstarted.

## Approved decision and remaining deployment inputs

The repository-dispatch endpoint requires Contents write, so installing one App across every source repository would exceed least privilege. The approved contract installs the App only on the publisher target and uses an Azure Function broker with an Azure Key Vault non-exportable sign/verify-only key, Azure managed identity, `AtyaLibraries/platform` as service owner, and `aasulyan` as accountable human owner.

Azure subscription, tenant, region, resource group, resource names, deployment identity, and billing approval remain unconfirmed. Issue #17 remains open and In Progress while the platform implementation and deployment plan are reviewed. No deployment or live credential operation is authorized.

## Validation

- PowerShell 7.6 contract, permission, repository-scope, topology, ledger, fixture, and sanitization validation: passed.
- Negative authorization and contract-mutation cases: passed.
- JSON and CSV parsing: passed.
- YAML parsing and linting: passed.
- Private implementation-plan validator: passed without changing the private plan.
- Git whitespace and patch checks: passed.
- .NET 10 release build and 19 synthetic broker security tests: passed with zero warnings and zero failures.
- Bicep static build and lint: passed without diagnostics; no Azure what-if or deployment was run.
- NuGet transitive vulnerability check: no known vulnerable packages reported by the configured sources.

# ATYA-105 — Verify remediation of all eight audited repository failures

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-105 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 7 — Issue, PR, branch, and repository cleanup |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-002; ATYA-031; ATYA-038; ATYA-093; ATYA-126; ATYA-127; ATYA-128; ATYA-129; ATYA-130 |
| Advisory prerequisites | None |
| Implementation state | Partially satisfied |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Required cleanup target and implementation-program synthesis |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

The fleet cannot be release-ready while default, PR, scheduled, or release workflows have unexplained failures.

## Root cause

Fleet work accumulated across independent repositories without one stable ATYA identity and evidence-controlled retirement process. The fleet cannot be release-ready while default, PR, scheduled, or release workflows have unexplained failures.

## Desired outcome

Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries, Atya.Templates.NuGetPackage, Cli, Atya.Build.Sdk, AtyaLibraries.github.io, BackgroundServices, Idempotency, Messaging.Outbox, Pagination, publisher. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.

## Out-of-scope work

Any destructive action before its audit dependency is approved; deletion of unique work; force-push/tag rewriting; unrelated package design changes.

## Hard dependencies

- ATYA-002
- ATYA-031
- ATYA-038
- ATYA-093
- ATYA-126
- ATYA-127
- ATYA-128
- ATYA-129
- ATYA-130

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.
3. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
4. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Preserve commit history, issue/PR attribution, published tags/packages, consumer compatibility, and recoverability. Migrate before close/delete; use forward fixes for immutable releases.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Use dry-run inventories and fixture data first. Re-run the exact audit after action and compare counts/SHAs/URLs; require zero unexplained deltas and independent spot checks for destructive batches.

## Documentation work

Update the Atya.Roadmap ledger with URLs, SHAs, decisions, approver, timestamps, exceptions, recovery notes, and links from every retired artifact.

## Measurable acceptance criteria

- Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.
- Every scoped repository or artifact has exactly one recorded disposition and owner.
- Evidence is reproducible; destructive actions, if any, depend on approved audit output and have recovery notes.

## Definition of done

- All acceptance criteria pass and the audit/action ledger is complete.
- No useful work, attribution, or immutable release evidence was lost.
- Follow-up issues use stable ATYA IDs and project metadata; remaining exceptions have owners and dates.

## Validation commands

```powershell
gh auth status
gh api orgs/AtyaLibraries --method GET
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.
```

## Rollback strategy

Revert only the scoped configuration/content change from its recorded commit and restore the prior ledger snapshot; retain audit history.

## Standalone implementation prompt

You are implementing ATYA-105 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Verify remediation of all eight audited repository failures. Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries, Atya.Templates.NuGetPackage, Cli, Atya.Build.Sdk, AtyaLibraries.github.io, BackgroundServices, Idempotency, Messaging.Outbox, Pagination, publisher. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

The fleet cannot be release-ready while default, PR, scheduled, or release workflows have unexplained failures.

Root cause: Fleet work accumulated across independent repositories without one stable ATYA identity and evidence-controlled retirement process. The fleet cannot be release-ready while default, PR, scheduled, or release workflows have unexplained failures.

Required outcome

Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.

In scope

Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.

Out of scope

Any destructive action before its audit dependency is approved; deletion of unique work; force-push/tag rewriting; unrelated package design changes.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002, ATYA-031, ATYA-038, ATYA-093, ATYA-126, ATYA-127, ATYA-128, ATYA-129, ATYA-130.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Fix failures in owning repositories in dependency order, add regression fixtures for systemic causes, rerun the exact failed checks, and link green runs to the audit ledger.
3. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
4. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Preserve commit history, issue/PR attribution, published tags/packages, consumer compatibility, and recoverability. Migrate before close/delete; use forward fixes for immutable releases.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Use dry-run inventories and fixture data first. Re-run the exact audit after action and compare counts/SHAs/URLs; require zero unexplained deltas and independent spot checks for destructive batches.

Documentation

Update the Atya.Roadmap ledger with URLs, SHAs, decisions, approver, timestamps, exceptions, recovery notes, and links from every retired artifact.

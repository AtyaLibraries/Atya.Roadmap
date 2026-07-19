# ATYA-103 — Delete only verified merged or superseded branches

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-103 |
| Owning repository | Atya.Roadmap |
| Priority | P2 |
| Phase | 7 — Issue, PR, branch, and repository cleanup |
| Type | Cleanup |
| Initial status | Blocked |
| Hard dependencies | ATYA-091; ATYA-095; ATYA-102 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Required cleanup target and implementation-program synthesis |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

Stale branches add noise, but unconditional deletion risks data loss and violates the required safety model.

## Root cause

Fleet work accumulated across independent repositories without one stable ATYA identity and evidence-controlled retirement process. Stale branches add noise, but unconditional deletion risks data loss and violates the required safety model.

## Desired outcome

Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded; retain protected exceptions and a recoverability record for each deletion batch.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, .github, Atya.Build.Sdk, Atya.Templates.NuGetPackage, Atya.Templates.UiAutomation, AtyaLibraries.github.io, BackgroundServices, Cli, CodeQuality, github-workflows, Idempotency, Logging, platform, Primitives, ProblemDetails, publisher, Testing, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded; retain protected exceptions and a recoverability record for each deletion batch.

## Out-of-scope work

Any destructive action before its audit dependency is approved; deletion of unique work; force-push/tag rewriting; unrelated package design changes.

## Hard dependencies

- ATYA-091
- ATYA-095
- ATYA-102

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded
3. retain protected exceptions and a recoverability record for each deletion batch.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Preserve commit history, issue/PR attribution, published tags/packages, consumer compatibility, and recoverability. Migrate before close/delete; use forward fixes for immutable releases.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Use dry-run inventories and fixture data first. Re-run the exact audit after action and compare counts/SHAs/URLs; require zero unexplained deltas and independent spot checks for destructive batches.

## Documentation work

Update the Atya.Roadmap ledger with URLs, SHAs, decisions, approver, timestamps, exceptions, recovery notes, and links from every retired artifact.

## Measurable acceptance criteria

- Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded; retain protected exceptions and a recoverability record for each deletion batch.
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
# Task-specific proof: Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded; retain protected exceptions and a recoverability record for each deletion batch.
```

## Rollback strategy

Stop the batch on the first unexplained delta. Restore recoverable branches from recorded SHAs and reopen issues/PRs with correction links; never rewrite published tags or packages.

## Standalone implementation prompt

You are implementing ATYA-103 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Delete only verified merged or superseded branches. Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded; retain protected exceptions and a recoverability record for each deletion batch.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, .github, Atya.Build.Sdk, Atya.Templates.NuGetPackage, Atya.Templates.UiAutomation, AtyaLibraries.github.io, BackgroundServices, Cli, CodeQuality, github-workflows, Idempotency, Logging, platform, Primitives, ProblemDetails, publisher, Testing, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Stale branches add noise, but unconditional deletion risks data loss and violates the required safety model.

Root cause: Fleet work accumulated across independent repositories without one stable ATYA identity and evidence-controlled retirement process. Stale branches add noise, but unconditional deletion risks data loss and violates the required safety model.

Required outcome

Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded; retain protected exceptions and a recoverability record for each deletion batch.

In scope

Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded; retain protected exceptions and a recoverability record for each deletion batch.

Out of scope

Any destructive action before its audit dependency is approved; deletion of unique work; force-push/tag rewriting; unrelated package design changes.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-091, ATYA-095, ATYA-102.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Delete a branch only when commit/tree reachability, PR/issue migration, tag relevance, and owner approval are recorded
3. retain protected exceptions and a recoverability record for each deletion batch.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Preserve commit history, issue/PR attribution, published tags/packages, consumer compatibility, and recoverability. Migrate before close/delete; use forward fixes for immutable releases.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Use dry-run inventories and fixture data first. Re-run the exact audit after action and compare counts/SHAs/URLs; require zero unexplained deltas and independent spot checks for destructive batches.

Documentation

Update the Atya.Roadmap ledger with URLs, SHAs, decisions, approver, timestamps, exceptions, recovery notes, and links from every retired artifact.

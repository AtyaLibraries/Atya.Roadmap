# ATYA-029 — Restore release-notes/tag/NuGet/API-baseline traceability

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-029 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-003; ATYA-018 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0013) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

Several published 1.0.0 packages lack GitHub Releases; ProblemDetails/Validation NuGet versions exceed their latest Releases; READMEs describe obsolete master-merge publishing; Foundation.Abstractions carries a stale API baseline; Build.Sdk v1.5.3 tag unresolved.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Several published 1.0.0 packages lack GitHub Releases; ProblemDetails/Validation NuGet versions exceed their latest Releases; READMEs describe obsolete master-merge publishing; Foundation.Abstractions carries a stale API baseline; Build.Sdk v1.5.3 tag unresolved.

## Desired outcome

Define the system of record; require matching tag/NuGet/Release triplets; generate release notes + artifact links; automate post-release baseline-update PRs verified against the shipped package; correct stale release docs; resolve v1.5.3 before the next SDK tag.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Fleet release metadata; publisher automation. Define the system of record; require matching tag/NuGet/Release triplets; generate release notes + artifact links; automate post-release baseline-update PRs verified against the shipped package; correct stale release docs; resolve v1.5.3 before the next SDK tag.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-003
- ATYA-018

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Define the system of record
3. require matching tag/NuGet/Release triplets
4. generate release notes + artifact links
5. automate post-release baseline-update PRs verified against the shipped package
6. correct stale release docs
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

None.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: ECO-039 check..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Fleet audit: every published version has tag+Release+notes; baselines match shipped packages.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: ECO-039 check.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-029 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Restore release-notes/tag/NuGet/API-baseline traceability. Define the system of record; require matching tag/NuGet/Release triplets; generate release notes + artifact links; automate post-release baseline-update PRs verified against the shipped package; correct stale release docs; resolve v1.5.3 before the next SDK tag.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Several published 1.0.0 packages lack GitHub Releases; ProblemDetails/Validation NuGet versions exceed their latest Releases; READMEs describe obsolete master-merge publishing; Foundation.Abstractions carries a stale API baseline; Build.Sdk v1.5.3 tag unresolved.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Several published 1.0.0 packages lack GitHub Releases; ProblemDetails/Validation NuGet versions exceed their latest Releases; READMEs describe obsolete master-merge publishing; Foundation.Abstractions carries a stale API baseline; Build.Sdk v1.5.3 tag unresolved.

Required outcome

Define the system of record; require matching tag/NuGet/Release triplets; generate release notes + artifact links; automate post-release baseline-update PRs verified against the shipped package; correct stale release docs; resolve v1.5.3 before the next SDK tag.

In scope

Fleet release metadata; publisher automation. Define the system of record; require matching tag/NuGet/Release triplets; generate release notes + artifact links; automate post-release baseline-update PRs verified against the shipped package; correct stale release docs; resolve v1.5.3 before the next SDK tag.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-003, ATYA-018.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Define the system of record
3. require matching tag/NuGet/Release triplets
4. generate release notes + artifact links
5. automate post-release baseline-update PRs verified against the shipped package
6. correct stale release docs
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

None.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: ECO-039 check..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

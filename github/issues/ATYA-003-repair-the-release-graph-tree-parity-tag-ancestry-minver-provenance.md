# ATYA-003 — Repair the release graph: tree parity, tag ancestry, MinVer provenance

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-003 |
| Owning repository | Atya.Roadmap |
| Priority | P0 |
| Phase | 0 — Authoritative inventory and evidence |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-002 |
| Advisory prerequisites | None |
| Implementation state | Partially satisfied |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0001 + S-0003) |
| Confidence | High |
| Risk | Critical |
| Effort | M |

## Problem description

Release lineage has detached from development: released trees carry constitution-forbidden pins (Fable's predicate) and/or stable tags are unreachable from development so MinVer derives versions from stale history (GPT's predicate, incl. Serialization v1.0.1-tag/1.0.0-NuGet and Build.Sdk v1.5.2+v1.5.3 anomalies).

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Release lineage has detached from development: released trees carry constitution-forbidden pins (Fable's predicate) and/or stable tags are unreachable from development so MinVer derives versions from stale history (GPT's predicate, incl. Serialization v1.0.1-tag/1.0.0-NuGet and Build.Sdk v1.5.2+v1.5.3 anomalies).

## Desired outcome

(1) ADR-09: choose merge-back vs trunk-based release strategy explicitly. (2) dev→master promotion PRs where trees diverged (Fable's mechanics; respect the release-source guard). (3) Merge release lineage back so newest stable tags become ancestors of development; reconcile the two tag anomalies without rewriting published tags. (4) Add both predicates as continuous checks (CLI, ECO-039) so recurrence is impossible silently.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries, Cli, platform, Atya.Build.Sdk, Serialization. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Foundation + Governance repos first (union of both models' lists), then fleet-wide. (1) ADR-09: choose merge-back vs trunk-based release strategy explicitly. (2) dev→master promotion PRs where trees diverged (Fable's mechanics; respect the release-source guard). (3) Merge release lineage back so newest stable tags become ancestors of development; reconcile the two tag anomalies without rewriting published tags. (4) Add both predicates as continuous checks (CLI, ECO-039) so recurrence is impossible silently.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-002

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-004

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. ADR-09: choose merge-back vs trunk-based release strategy explicitly
3. dev→master promotion PRs where trees diverged (Fable's mechanics
4. respect the release-source guard)
5. Merge release lineage back so newest stable tags become ancestors of development
6. reconcile the two tag anomalies without rewriting published tags
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

No package changes; verify MinVer computes expected next versions per repo afterward.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Re-run both models' measurements; both lists must come back empty..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Fleet script reports tree parity AND tag ancestry green for every package repo.
- Serialization and Build.Sdk tag states reconciled and documented.
- The two checks run continuously, not only at release.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Re-run both models' measurements; both lists must come back empty.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-003 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Repair the release graph: tree parity, tag ancestry, MinVer provenance. (1) ADR-09: choose merge-back vs trunk-based release strategy explicitly. (2) dev→master promotion PRs where trees diverged (Fable's mechanics; respect the release-source guard). (3) Merge release lineage back so newest stable tags become ancestors of development; reconcile the two tag anomalies without rewriting published tags. (4) Add both predicates as continuous checks (CLI, ECO-039) so recurrence is impossible silently.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries, Cli, platform, Atya.Build.Sdk, Serialization. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Release lineage has detached from development: released trees carry constitution-forbidden pins (Fable's predicate) and/or stable tags are unreachable from development so MinVer derives versions from stale history (GPT's predicate, incl. Serialization v1.0.1-tag/1.0.0-NuGet and Build.Sdk v1.5.2+v1.5.3 anomalies).

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Release lineage has detached from development: released trees carry constitution-forbidden pins (Fable's predicate) and/or stable tags are unreachable from development so MinVer derives versions from stale history (GPT's predicate, incl. Serialization v1.0.1-tag/1.0.0-NuGet and Build.Sdk v1.5.2+v1.5.3 anomalies).

Required outcome

(1) ADR-09: choose merge-back vs trunk-based release strategy explicitly. (2) dev→master promotion PRs where trees diverged (Fable's mechanics; respect the release-source guard). (3) Merge release lineage back so newest stable tags become ancestors of development; reconcile the two tag anomalies without rewriting published tags. (4) Add both predicates as continuous checks (CLI, ECO-039) so recurrence is impossible silently.

In scope

Foundation + Governance repos first (union of both models' lists), then fleet-wide. (1) ADR-09: choose merge-back vs trunk-based release strategy explicitly. (2) dev→master promotion PRs where trees diverged (Fable's mechanics; respect the release-source guard). (3) Merge release lineage back so newest stable tags become ancestors of development; reconcile the two tag anomalies without rewriting published tags. (4) Add both predicates as continuous checks (CLI, ECO-039) so recurrence is impossible silently.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. ADR-09: choose merge-back vs trunk-based release strategy explicitly
3. dev→master promotion PRs where trees diverged (Fable's mechanics
4. respect the release-source guard)
5. Merge release lineage back so newest stable tags become ancestors of development
6. reconcile the two tag anomalies without rewriting published tags
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

No package changes; verify MinVer computes expected next versions per repo afterward.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Re-run both models' measurements; both lists must come back empty..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

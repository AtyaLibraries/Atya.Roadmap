# ATYA-032 — Define and verify dependency-range and packed-nuspec policy

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-032 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-002; ATYA-030; ATYA-005 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0016) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Published dependencies use unbounded [x,) ranges; central transitive pinning reportedly promotes sample/host dependencies into published nuspecs (OpenTelemetry, Client).

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Published dependencies use unbounded [x,) ranges; central transitive pinning reportedly promotes sample/host dependencies into published nuspecs (OpenTelemetry, Client).

## Desired outcome

Range rules by dependency class (document the upper-bound tradeoff, don't cap mechanically); pack-time assertions comparing evaluated direct runtime deps against nuspec groups; separate sample-only pins from packable graphs; compatibility fixtures for allowed ranges.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, Atya.Templates.NuGetPackage. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

All packages; Build.Sdk pack targets. Range rules by dependency class (document the upper-bound tradeoff, don't cap mechanically); pack-time assertions comparing evaluated direct runtime deps against nuspec groups; separate sample-only pins from packable graphs; compatibility fixtures for allowed ranges.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-002
- ATYA-030
- ATYA-005

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Range rules by dependency class (document the upper-bound tradeoff, don't cap mechanically)
3. pack-time assertions comparing evaluated direct runtime deps against nuspec groups
4. separate sample-only pins from packable graphs
5. compatibility fixtures for allowed ranges.
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Range tightening is a minor-version metadata change; release-note.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Nuspec-diff fixtures on the five packages GPT names..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Every package CI asserts its exact intended nuspec dependency set; seeded sample-dep leak fails.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Nuspec-diff fixtures on the five packages GPT names.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-032 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Define and verify dependency-range and packed-nuspec policy. Range rules by dependency class (document the upper-bound tradeoff, don't cap mechanically); pack-time assertions comparing evaluated direct runtime deps against nuspec groups; separate sample-only pins from packable graphs; compatibility fixtures for allowed ranges.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, Atya.Templates.NuGetPackage. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Published dependencies use unbounded [x,) ranges; central transitive pinning reportedly promotes sample/host dependencies into published nuspecs (OpenTelemetry, Client).

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Published dependencies use unbounded [x,) ranges; central transitive pinning reportedly promotes sample/host dependencies into published nuspecs (OpenTelemetry, Client).

Required outcome

Range rules by dependency class (document the upper-bound tradeoff, don't cap mechanically); pack-time assertions comparing evaluated direct runtime deps against nuspec groups; separate sample-only pins from packable graphs; compatibility fixtures for allowed ranges.

In scope

All packages; Build.Sdk pack targets. Range rules by dependency class (document the upper-bound tradeoff, don't cap mechanically); pack-time assertions comparing evaluated direct runtime deps against nuspec groups; separate sample-only pins from packable graphs; compatibility fixtures for allowed ranges.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002, ATYA-030, ATYA-005.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Range rules by dependency class (document the upper-bound tradeoff, don't cap mechanically)
3. pack-time assertions comparing evaluated direct runtime deps against nuspec groups
4. separate sample-only pins from packable graphs
5. compatibility fixtures for allowed ranges.
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Range tightening is a minor-version metadata change; release-note.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Nuspec-diff fixtures on the five packages GPT names..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

# ATYA-039 — Replace platform drift JavaScript with CLI fleet audits

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-039 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-038; ATYA-019; ATYA-001; ATYA-124 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (S-0020 + F-0035 (drift-checks half)) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Platform drift is a large inline JS implementation checking shallow structure, duplicating policy, mishandling infra repos; the standing checks this plan needs (tree parity, tag ancestry, SHA pins, matrix drift, pin currency, README sections, release traceability) don't exist as machinery.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Platform drift is a large inline JS implementation checking shallow structure, duplicating policy, mishandling infra repos; the standing checks this plan needs (tree parity, tag ancestry, SHA pins, matrix drift, pin currency, README sections, release traceability) don't exist as machinery.

## Desired outcome

SHA-pin a released CLI in the scheduled workflow; atya doctor --fleet with manifest-driven archetypes emitting machine-readable results into the existing read-only issue flow; checks: master==development trees, newest-tag ancestry, workflow SHA == fleet pin, csproj refs == manifest edges, global.json == fleet-current, README mandatory sections, tag/Release/NuGet traceability; fixture-tested exceptions; no fleet mutation.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, Cli, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

platform drift workflow; CLI. SHA-pin a released CLI in the scheduled workflow; atya doctor --fleet with manifest-driven archetypes emitting machine-readable results into the existing read-only issue flow; checks: master==development trees, newest-tag ancestry, workflow SHA == fleet pin, csproj refs == manifest edges, global.json == fleet-current, README mandatory sections, tag/Release/NuGet traceability; fixture-tested exceptions; no fleet mutation.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-038
- ATYA-019
- ATYA-001
- ATYA-124

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. SHA-pin a released CLI in the scheduled workflow
3. atya doctor --fleet with manifest-driven archetypes emitting machine-readable results into the existing read-only issue flow
4. checks: master==development trees, newest-tag ancestry, workflow SHA == fleet pin, csproj refs == manifest edges, global.json == fleet-current, README mandatory sections, tag/Release/NuGet traceability
5. fixture-tested exceptions
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Old drift workflow retired after one overlapping cycle.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-drift canary..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- All findings of both source reviews would have been caught by the check set (walk the list and prove coverage); scheduled run green on the repaired fleet, red on seeded drift.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Seeded-drift canary.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-039 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Replace platform drift JavaScript with CLI fleet audits. SHA-pin a released CLI in the scheduled workflow; atya doctor --fleet with manifest-driven archetypes emitting machine-readable results into the existing read-only issue flow; checks: master==development trees, newest-tag ancestry, workflow SHA == fleet pin, csproj refs == manifest edges, global.json == fleet-current, README mandatory sections, tag/Release/NuGet traceability; fixture-tested exceptions; no fleet mutation.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, Cli, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Platform drift is a large inline JS implementation checking shallow structure, duplicating policy, mishandling infra repos; the standing checks this plan needs (tree parity, tag ancestry, SHA pins, matrix drift, pin currency, README sections, release traceability) don't exist as machinery.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Platform drift is a large inline JS implementation checking shallow structure, duplicating policy, mishandling infra repos; the standing checks this plan needs (tree parity, tag ancestry, SHA pins, matrix drift, pin currency, README sections, release traceability) don't exist as machinery.

Required outcome

SHA-pin a released CLI in the scheduled workflow; atya doctor --fleet with manifest-driven archetypes emitting machine-readable results into the existing read-only issue flow; checks: master==development trees, newest-tag ancestry, workflow SHA == fleet pin, csproj refs == manifest edges, global.json == fleet-current, README mandatory sections, tag/Release/NuGet traceability; fixture-tested exceptions; no fleet mutation.

In scope

platform drift workflow; CLI. SHA-pin a released CLI in the scheduled workflow; atya doctor --fleet with manifest-driven archetypes emitting machine-readable results into the existing read-only issue flow; checks: master==development trees, newest-tag ancestry, workflow SHA == fleet pin, csproj refs == manifest edges, global.json == fleet-current, README mandatory sections, tag/Release/NuGet traceability; fixture-tested exceptions; no fleet mutation.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-038, ATYA-019, ATYA-001, ATYA-124.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. SHA-pin a released CLI in the scheduled workflow
3. atya doctor --fleet with manifest-driven archetypes emitting machine-readable results into the existing read-only issue flow
4. checks: master==development trees, newest-tag ancestry, workflow SHA == fleet pin, csproj refs == manifest edges, global.json == fleet-current, README mandatory sections, tag/Release/NuGet traceability
5. fixture-tested exceptions
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Old drift workflow retired after one overlapping cycle.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-drift canary..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

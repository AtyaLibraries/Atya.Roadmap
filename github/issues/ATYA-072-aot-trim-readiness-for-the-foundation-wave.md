# ATYA-072 — AOT/trim readiness for the Foundation wave

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-072 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-008; ATYA-007; ATYA-048; ATYA-005 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0045) |
| Confidence | High |
| Risk | Low |
| Effort | S |

## Problem description

No IsAotCompatible/trim analyzers anywhere; Mediator's reflection-free design is AOT-motivated but unverified.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. No IsAotCompatible/trim analyzers anywhere; Mediator's reflection-free design is AOT-motivated but unverified.

## Desired outcome

<IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk; fix findings; verify Mediator + a minimal API sample under PublishAot.

## In-scope work

Results, Guards, Time, Serialization, Primitives, Mediator; Build.Sdk opt-in property. <IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk; fix findings; verify Mediator + a minimal API sample under PublishAot.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-008
- ATYA-007
- ATYA-048
- ATYA-005

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. <IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk
3. verify Mediator + a minimal API sample under PublishAot.
4. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Analyzer findings may force small internal changes; additive externally.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: PublishAot CI job..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Opted-in packages build trim-warning-free; the AOT sample runs.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: PublishAot CI job.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-072 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

AOT/trim readiness for the Foundation wave. <IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk; fix findings; verify Mediator + a minimal API sample under PublishAot.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Results, Guards, Time, Serialization, Primitives, Mediator; Build.Sdk opt-in property. <IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk; fix findings; verify Mediator + a minimal API sample under PublishAot.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

No IsAotCompatible/trim analyzers anywhere; Mediator's reflection-free design is AOT-motivated but unverified.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. No IsAotCompatible/trim analyzers anywhere; Mediator's reflection-free design is AOT-motivated but unverified.

Required outcome

<IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk; fix findings; verify Mediator + a minimal API sample under PublishAot.

In scope

Results, Guards, Time, Serialization, Primitives, Mediator; Build.Sdk opt-in property. <IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk; fix findings; verify Mediator + a minimal API sample under PublishAot.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-008, ATYA-007, ATYA-048, ATYA-005.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. <IsAotCompatible>true</IsAotCompatible> per opted-in archetype in Build.Sdk
3. verify Mediator + a minimal API sample under PublishAot.
4. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Analyzer findings may force small internal changes; additive externally.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: PublishAot CI job..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: PublishAot CI job.
```

Acceptance criteria

- Opted-in packages build trim-warning-free; the AOT sample runs.

Working rules

Use a focused branch linked to ATYA-072; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-034 — Repair dependency-matrix ↔ csproj drift and machine-check it

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-034 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-001; ATYA-008 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0007 + S-0032 (edge-removal clause)) |
| Confidence | High |
| Risk | High |
| Effort | S |

## Problem description

Primitives references Abstractions but the matrix says [Guards]; Messaging.Abstractions declares Foundation.Abstractions in matrix+csproj with zero usages; Middleware's direct Exceptions edge appears redundant; the constitution calls matrix mismatch a release blocker yet nothing machine-checks it.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Primitives references Abstractions but the matrix says [Guards]; Messaging.Abstractions declares Foundation.Abstractions in matrix+csproj with zero usages; Middleware's direct Exceptions edge appears redundant; the constitution calls matrix mismatch a release blocker yet nothing machine-checks it.

## Desired outcome

Drop the unused PackageReference (patch; removing a dependency is consumer-safe); amend matrix rows; verify the Middleware edge before removal (packed-graph check); CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).

## In-scope work

Messaging.Abstractions (patch: drop the dep), Primitives (resolves via ECO-008), Web.Middleware (verify then drop), matrix/manifest. Drop the unused PackageReference (patch; removing a dependency is consumer-safe); amend matrix rows; verify the Middleware edge before removal (packed-graph check); CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-001
- ATYA-008

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Drop the unused PackageReference (patch
3. removing a dependency is consumer-safe)
4. verify the Middleware edge before removal (packed-graph check)
5. CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Dependency removals are safe; note in release notes.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-drift fixture..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Matrix == manifest == csproj for every repo; the CLI check fails on seeded drift.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Seeded-drift fixture.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-034 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Repair dependency-matrix ↔ csproj drift and machine-check it. Drop the unused PackageReference (patch; removing a dependency is consumer-safe); amend matrix rows; verify the Middleware edge before removal (packed-graph check); CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Messaging.Abstractions (patch: drop the dep), Primitives (resolves via ECO-008), Web.Middleware (verify then drop), matrix/manifest. Drop the unused PackageReference (patch; removing a dependency is consumer-safe); amend matrix rows; verify the Middleware edge before removal (packed-graph check); CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Primitives references Abstractions but the matrix says [Guards]; Messaging.Abstractions declares Foundation.Abstractions in matrix+csproj with zero usages; Middleware's direct Exceptions edge appears redundant; the constitution calls matrix mismatch a release blocker yet nothing machine-checks it.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Primitives references Abstractions but the matrix says [Guards]; Messaging.Abstractions declares Foundation.Abstractions in matrix+csproj with zero usages; Middleware's direct Exceptions edge appears redundant; the constitution calls matrix mismatch a release blocker yet nothing machine-checks it.

Required outcome

Drop the unused PackageReference (patch; removing a dependency is consumer-safe); amend matrix rows; verify the Middleware edge before removal (packed-graph check); CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).

In scope

Messaging.Abstractions (patch: drop the dep), Primitives (resolves via ECO-008), Web.Middleware (verify then drop), matrix/manifest. Drop the unused PackageReference (patch; removing a dependency is consumer-safe); amend matrix rows; verify the Middleware edge before removal (packed-graph check); CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-001, ATYA-008.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Drop the unused PackageReference (patch
3. removing a dependency is consumer-safe)
4. verify the Middleware edge before removal (packed-graph check)
5. CLI check diffing each csproj's Atya.* refs against the manifest (ECO-039).
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Dependency removals are safe; note in release notes.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-drift fixture..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Seeded-drift fixture.
```

Acceptance criteria

- Matrix == manifest == csproj for every repo; the CLI check fails on seeded drift.

Working rules

Use a focused branch linked to ATYA-034; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

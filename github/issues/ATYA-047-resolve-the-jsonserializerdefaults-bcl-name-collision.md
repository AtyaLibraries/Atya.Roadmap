# ATYA-047 — Resolve the JsonSerializerDefaults BCL name collision

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-047 |
| Owning repository | Serialization |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Ready |
| Hard dependencies | None |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0017) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

Atya.Foundation.Serialization.JsonSerializerDefaults collides with System.Text.Json.JsonSerializerDefaults; every file importing both namespaces — the package's target audience — needs aliasing.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Atya.Foundation.Serialization.JsonSerializerDefaults collides with System.Text.Json.JsonSerializerDefaults; every file importing both namespaces — the package's target audience — needs aliasing.

## Desired outcome

Introduce AtyaJsonDefaults; keep the old type as [Obsolete] forwarding shim for one minor; remove in the 2.0 train; audit the fleet for other BCL-shadowing names.

## In-scope work

Foundation.Serialization. Introduce AtyaJsonDefaults; keep the old type as [Obsolete] forwarding shim for one minor; remove in the 2.0 train; audit the fleet for other BCL-shadowing names.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

None.

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-043
- ATYA-044
- ATYA-045

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Introduce AtyaJsonDefaults
3. keep the old type as [Obsolete] forwarding shim for one minor
4. remove in the 2.0 train
5. audit the fleet for other BCL-shadowing names.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Serialization's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Shim preserves source compat; removal rides 2.0.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Compile fixture importing both namespaces..

## Documentation work

Update Serialization README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- New name shipped; both-namespace import compiles warning-clean (post-migration); no other BCL collisions found or all are ticketed.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Compile fixture importing both namespaces.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-047 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Resolve the JsonSerializerDefaults BCL name collision. Introduce AtyaJsonDefaults; keep the old type as [Obsolete] forwarding shim for one minor; remove in the 2.0 train; audit the fleet for other BCL-shadowing names.

Exact repository/package scope

Owning repository: Serialization. In scope: Foundation.Serialization. Introduce AtyaJsonDefaults; keep the old type as [Obsolete] forwarding shim for one minor; remove in the 2.0 train; audit the fleet for other BCL-shadowing names.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Atya.Foundation.Serialization.JsonSerializerDefaults collides with System.Text.Json.JsonSerializerDefaults; every file importing both namespaces — the package's target audience — needs aliasing.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Atya.Foundation.Serialization.JsonSerializerDefaults collides with System.Text.Json.JsonSerializerDefaults; every file importing both namespaces — the package's target audience — needs aliasing.

Required outcome

Introduce AtyaJsonDefaults; keep the old type as [Obsolete] forwarding shim for one minor; remove in the 2.0 train; audit the fleet for other BCL-shadowing names.

In scope

Foundation.Serialization. Introduce AtyaJsonDefaults; keep the old type as [Obsolete] forwarding shim for one minor; remove in the 2.0 train; audit the fleet for other BCL-shadowing names.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

No hard roadmap dependency blocks discovery or implementation.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Introduce AtyaJsonDefaults
3. keep the old type as [Obsolete] forwarding shim for one minor
4. remove in the 2.0 train
5. audit the fleet for other BCL-shadowing names.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Serialization's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Shim preserves source compat; removal rides 2.0.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Compile fixture importing both namespaces..

Documentation

Update Serialization README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Compile fixture importing both namespaces.
```

Acceptance criteria

- New name shipped; both-namespace import compiles warning-clean (post-migration); no other BCL collisions found or all are ticketed.

Working rules

Use a focused branch linked to ATYA-047; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

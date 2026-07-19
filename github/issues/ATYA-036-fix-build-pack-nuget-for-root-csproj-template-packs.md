# ATYA-036 — Fix build-pack-nuget for root-csproj template packs

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-036 |
| Owning repository | github-workflows |
| Primary contract owner | github-workflows |
| Downstream repositories | publisher; Atya.Templates.UiAutomation; Atya.Templates.NuGetPackage; Atya.Build.Sdk |
| Child migration requirement | required-existing |
| Child migration tasks | ATYA-026; ATYA-031; ATYA-076; ATYA-077 |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-027 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0003) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

The shared action restores/builds the solution then packs --no-build; template repos keep the package csproj out of the solution → NETSDK1004; UiAutomation ships a workaround; atya-nuget hits it next publish.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. The shared action restores/builds the solution then packs --no-build; template repos keep the package csproj out of the solution → NETSDK1004; UiAutomation ships a workaround; atya-nuget hits it next publish.

## Desired outcome

Make build-pack-nuget restore and build the package project itself when it is not in the solution, preserve locked restore, and cover both solution-member and root-csproj template-pack layouts with action-owned fixtures.

## In-scope work

github-workflows build-pack-nuget action and its fixtures only.

## Out-of-scope work

Publisher/fleet pin rollout, Build.Sdk publication, packed-template verification, and UiAutomation workaround removal; ATYA-026, ATYA-031, ATYA-076, and ATYA-077 own those migrations.

## Ownership and downstream migrations

- Primary contract owner: github-workflows
- Final owning repository: github-workflows
- Downstream repositories: publisher; Atya.Templates.UiAutomation; Atya.Templates.NuGetPackage; Atya.Build.Sdk
- Child migration requirement: required-existing
- Child migration tasks: ATYA-026; ATYA-031; ATYA-076; ATYA-077
- Rationale: github-workflows owns the action. Pin rollout, Build.Sdk publication, packed-template proof, and workaround removal remain with their existing owning tasks.

## Hard dependencies

- ATYA-027

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-027

## Implementation sequence

1. Reproduce both package-project layouts in action fixtures.
2. Detect solution membership without guessing from filenames.
3. Restore and build the package project when necessary while preserving locked restore.
4. Prove both layouts in action tests and publish an immutable action reference.
5. Hand rollout and workaround removal to the owning child tasks.

## Architecture guidance

Keep the change inside github-workflows's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

None.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Scratch-tag publish..

## Documentation work

Update github-workflows README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Action fixtures pack both solution-member and root-csproj projects without SOURCE_SOLUTION.
- Locked restore remains enforced and the released action reference is immutable.
- Downstream rollout is linked to ATYA-026, ATYA-031, ATYA-076, and ATYA-077 rather than performed here.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -NoProfile -File ./scripts/Validate.ps1
gh workflow view --all
# Task-specific proof: Scratch-tag publish.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-036 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Fix build-pack-nuget for root-csproj template packs. Make build-pack-nuget restore and build the package project itself when it is not in the solution, preserve locked restore, and cover both solution-member and root-csproj template-pack layouts with action-owned fixtures.

Exact repository/package scope

Owning repository: github-workflows. In scope: github-workflows build-pack-nuget action and its fixtures only.

Ownership and migration split

- Primary contract owner: github-workflows
- Final owning repository: github-workflows
- Downstream repositories: publisher; Atya.Templates.UiAutomation; Atya.Templates.NuGetPackage; Atya.Build.Sdk
- Child migration requirement: required-existing
- Child migration tasks: ATYA-026; ATYA-031; ATYA-076; ATYA-077
- Rationale: github-workflows owns the action. Pin rollout, Build.Sdk publication, packed-template proof, and workaround removal remain with their existing owning tasks.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

The shared action restores/builds the solution then packs --no-build; template repos keep the package csproj out of the solution → NETSDK1004; UiAutomation ships a workaround; atya-nuget hits it next publish.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. The shared action restores/builds the solution then packs --no-build; template repos keep the package csproj out of the solution → NETSDK1004; UiAutomation ships a workaround; atya-nuget hits it next publish.

Required outcome

Make build-pack-nuget restore and build the package project itself when it is not in the solution, preserve locked restore, and cover both solution-member and root-csproj template-pack layouts with action-owned fixtures.

In scope

github-workflows build-pack-nuget action and its fixtures only.

Out of scope

Publisher/fleet pin rollout, Build.Sdk publication, packed-template verification, and UiAutomation workaround removal; ATYA-026, ATYA-031, ATYA-076, and ATYA-077 own those migrations.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-027.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Reproduce both package-project layouts in action fixtures.
2. Detect solution membership without guessing from filenames.
3. Restore and build the package project when necessary while preserving locked restore.
4. Prove both layouts in action tests and publish an immutable action reference.
5. Hand rollout and workaround removal to the owning child tasks.

Architecture constraints

Keep the change inside github-workflows's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

None.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Scratch-tag publish..

Documentation

Update github-workflows README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -NoProfile -File ./scripts/Validate.ps1
gh workflow view --all
# Task-specific proof: Scratch-tag publish.
```

Acceptance criteria

- Action fixtures pack both solution-member and root-csproj projects without SOURCE_SOLUTION.
- Locked restore remains enforced and the released action reference is immutable.
- Downstream rollout is linked to ATYA-026, ATYA-031, ATYA-076, and ATYA-077 rather than performed here.

Working rules

Use a focused branch linked to ATYA-036; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

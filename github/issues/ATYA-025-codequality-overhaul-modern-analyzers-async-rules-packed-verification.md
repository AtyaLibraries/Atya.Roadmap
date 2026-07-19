# ATYA-025 — CodeQuality overhaul: modern analyzers, async rules, packed verification, charter

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-025 |
| Owning repository | CodeQuality |
| Primary contract owner | CodeQuality |
| Downstream repositories | Atya.Build.Sdk; managed SDK consumers; Atya.Templates.UiAutomation |
| Child migration requirement | required-existing |
| Child migration tasks | ATYA-030; ATYA-035; ATYA-077 |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-002 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0008 + S-0031) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

StyleCop.Analyzers 1.1.118 reportedly crashes (AD0001) on C# 14 syntax — the UiAutomation template already ships NoWarn AD0001; CA2007 is not enabled anywhere despite the fleet's ConfigureAwait rule (one shipped miss exists); CodeQuality's tests inspect the source tree, never the packed nupkg; its benchmark measures string length; its charter (style vs broader policy) is undefined.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. StyleCop.Analyzers 1.1.118 reportedly crashes (AD0001) on C# 14 syntax — the UiAutomation template already ships NoWarn AD0001; CA2007 is not enabled anywhere despite the fleet's ConfigureAwait rule (one shipped miss exists); CodeQuality's tests inspect the source tree, never the packed nupkg; its benchmark measures string length; its charter (style vs broader policy) is undefined.

## Desired outcome

Modernize and release Governance.CodeQuality as a verified packed analyzer product: the approved StyleCop prerelease exception, async rules, centrally tuned record/required-member rules, a clear charter, and pack-install positive/negative fixtures asserting diagnostic IDs, severities, and buildTransitive import. Publish a downstream adoption contract for ATYA-030, ATYA-035, and ATYA-077.

## In-scope work

Governance.CodeQuality source, analyzer configuration, charter, package metadata, packed consumer fixtures, release notes, and the CodeQuality release. No downstream repository edits.

## Out-of-scope work

Build.Sdk consumption, fleet pin rollout, and UiAutomation workaround removal; these independently executable migrations belong to ATYA-030, ATYA-035, and ATYA-077.

## Ownership and downstream migrations

- Primary contract owner: CodeQuality
- Final owning repository: CodeQuality
- Downstream repositories: Atya.Build.Sdk; managed SDK consumers; Atya.Templates.UiAutomation
- Child migration requirement: required-existing
- Child migration tasks: ATYA-030; ATYA-035; ATYA-077
- Rationale: CodeQuality owns analyzer behavior; Build.Sdk consumption, fleet rollout, and template-workaround removal are separately executable migrations.

## Hard dependencies

- ATYA-002

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-026
- ATYA-027
- ATYA-028

## Implementation sequence

1. Refresh analyzer/package evidence and accepted policy constraints.
2. Update analyzer dependencies and centrally owned rules.
3. Add packed positive/negative fixtures, including the AD0001 regression and buildTransitive proof.
4. Publish the charter, compatibility classification, and release evidence.
5. Hand the released contract to ATYA-030, ATYA-035, and ATYA-077 without editing their repositories here.

## Architecture guidance

Keep the change inside CodeQuality's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Expect new warnings-as-errors surfacing in several repos; sequence the roll with ECO-035; treat severity changes as breaking for safety.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Packed-analyzer fixture suite in CI..

## Documentation work

Update CodeQuality README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- A C# 14 packed-consumer fixture compiles without AD0001 or NoWarn.
- Negative fixtures prove the named async diagnostic IDs and severities.
- The charter, prerelease-analyzer exception, buildTransitive import, and compatibility classification are documented in the CodeQuality release.

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
# Task-specific proof: Packed-analyzer fixture suite in CI.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-025 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

CodeQuality overhaul: modern analyzers, async rules, packed verification, charter. Modernize and release Governance.CodeQuality as a verified packed analyzer product: the approved StyleCop prerelease exception, async rules, centrally tuned record/required-member rules, a clear charter, and pack-install positive/negative fixtures asserting diagnostic IDs, severities, and buildTransitive import. Publish a downstream adoption contract for ATYA-030, ATYA-035, and ATYA-077.

Exact repository/package scope

Owning repository: CodeQuality. In scope: Governance.CodeQuality source, analyzer configuration, charter, package metadata, packed consumer fixtures, release notes, and the CodeQuality release. No downstream repository edits.

Ownership and migration split

- Primary contract owner: CodeQuality
- Final owning repository: CodeQuality
- Downstream repositories: Atya.Build.Sdk; managed SDK consumers; Atya.Templates.UiAutomation
- Child migration requirement: required-existing
- Child migration tasks: ATYA-030; ATYA-035; ATYA-077
- Rationale: CodeQuality owns analyzer behavior; Build.Sdk consumption, fleet rollout, and template-workaround removal are separately executable migrations.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

StyleCop.Analyzers 1.1.118 reportedly crashes (AD0001) on C# 14 syntax — the UiAutomation template already ships NoWarn AD0001; CA2007 is not enabled anywhere despite the fleet's ConfigureAwait rule (one shipped miss exists); CodeQuality's tests inspect the source tree, never the packed nupkg; its benchmark measures string length; its charter (style vs broader policy) is undefined.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. StyleCop.Analyzers 1.1.118 reportedly crashes (AD0001) on C# 14 syntax — the UiAutomation template already ships NoWarn AD0001; CA2007 is not enabled anywhere despite the fleet's ConfigureAwait rule (one shipped miss exists); CodeQuality's tests inspect the source tree, never the packed nupkg; its benchmark measures string length; its charter (style vs broader policy) is undefined.

Required outcome

Modernize and release Governance.CodeQuality as a verified packed analyzer product: the approved StyleCop prerelease exception, async rules, centrally tuned record/required-member rules, a clear charter, and pack-install positive/negative fixtures asserting diagnostic IDs, severities, and buildTransitive import. Publish a downstream adoption contract for ATYA-030, ATYA-035, and ATYA-077.

In scope

Governance.CodeQuality source, analyzer configuration, charter, package metadata, packed consumer fixtures, release notes, and the CodeQuality release. No downstream repository edits.

Out of scope

Build.Sdk consumption, fleet pin rollout, and UiAutomation workaround removal; these independently executable migrations belong to ATYA-030, ATYA-035, and ATYA-077.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Refresh analyzer/package evidence and accepted policy constraints.
2. Update analyzer dependencies and centrally owned rules.
3. Add packed positive/negative fixtures, including the AD0001 regression and buildTransitive proof.
4. Publish the charter, compatibility classification, and release evidence.
5. Hand the released contract to ATYA-030, ATYA-035, and ATYA-077 without editing their repositories here.

Architecture constraints

Keep the change inside CodeQuality's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Expect new warnings-as-errors surfacing in several repos; sequence the roll with ECO-035; treat severity changes as breaking for safety.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Packed-analyzer fixture suite in CI..

Documentation

Update CodeQuality README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Packed-analyzer fixture suite in CI.
```

Acceptance criteria

- A C# 14 packed-consumer fixture compiles without AD0001 or NoWarn.
- Negative fixtures prove the named async diagnostic IDs and severities.
- The charter, prerelease-analyzer exception, buildTransitive import, and compatibility classification are documented in the CodeQuality release.

Working rules

Use a focused branch linked to ATYA-025; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-005 — Publish a framework-target and support policy by package archetype

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-005 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-001; ATYA-004 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0014) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

TFM strategy is an implicit Build.Sdk default, not a published support policy; no lifecycle windows or multi-targeting rules exist.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. TFM strategy is an implicit Build.Sdk default, not a published support policy; no lifecycle windows or multi-targeting rules exist.

## Desired outcome

ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web). Document support/deprecation windows. Make the SDK default explicit/archetype-driven. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.

## In-scope work

Build.Sdk defaults; all packages by archetype. ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web). Document support/deprecation windows. Make the SDK default explicit/archetype-driven. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

- ATYA-001
- ATYA-004

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web)
3. Document support/deprecation windows
4. Make the SDK default explicit/archetype-driven
5. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

Any TFM broadening is additive; narrowing waits for the 2.0 wave.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Packed-consumer fixture per supported TFM builds in CI..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR merged; SDK emits archetype-explicit TFMs; support table published on the site.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Packed-consumer fixture per supported TFM builds in CI.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-005 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Publish a framework-target and support policy by package archetype. ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web). Document support/deprecation windows. Make the SDK default explicit/archetype-driven. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Build.Sdk defaults; all packages by archetype. ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web). Document support/deprecation windows. Make the SDK default explicit/archetype-driven. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

TFM strategy is an implicit Build.Sdk default, not a published support policy; no lifecycle windows or multi-targeting rules exist.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. TFM strategy is an implicit Build.Sdk default, not a published support policy; no lifecycle windows or multi-targeting rules exist.

Required outcome

ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web). Document support/deprecation windows. Make the SDK default explicit/archetype-driven. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.

In scope

Build.Sdk defaults; all packages by archetype. ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web). Document support/deprecation windows. Make the SDK default explicit/archetype-driven. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-001, ATYA-004.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-01: decide TFMs per archetype (foundations, adapters, analyzers/generators, tools, templates, web)
3. Document support/deprecation windows
4. Make the SDK default explicit/archetype-driven
5. Do not multi-target without adopter evidence and per-TFM packed-consumer CI.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

Any TFM broadening is additive; narrowing waits for the 2.0 wave.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Packed-consumer fixture per supported TFM builds in CI..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Packed-consumer fixture per supported TFM builds in CI.
```

Acceptance criteria

- ADR merged; SDK emits archetype-explicit TFMs; support table published on the site.

Working rules

Use a focused branch linked to ATYA-005; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 1 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

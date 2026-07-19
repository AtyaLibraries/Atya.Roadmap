# ATYA-011 — Decide the FluentAssertions 7.x end-of-life strategy

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-011 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Ready |
| Hard dependencies | None |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0043) |
| Confidence | High |
| Risk | Low |
| Effort | M |

## Problem description

The fleet pins FA <8 for licensing; 7.x receives no fixes; the pin is load-bearing in Build.Sdk, renovate, and the constitution, and will eventually break against an xunit/.NET bump.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. The fleet pins FA <8 for licensing; 7.x receives no fixes; the pin is load-bearing in Build.Sdk, renovate, and the constitution, and will eventually break against an xunit/.NET bump.

## Desired outcome

Evaluate AwesomeAssertions (FA7-compatible fork) vs Shouldly vs plain asserts; ADR; swap the SDK-injected package on the chosen date; keep the ceiling until then (CC-35).

## In-scope work

Build.Sdk test injection, renovate ceiling, constitution. Evaluate AwesomeAssertions (FA7-compatible fork) vs Shouldly vs plain asserts; ADR; swap the SDK-injected package on the chosen date; keep the ceiling until then (CC-35).

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

None.

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. Evaluate AwesomeAssertions (FA7-compatible fork
3. vs Shouldly vs plain asserts
4. swap the SDK-injected package on the chosen date
5. keep the ceiling until then (CC-35).
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

Test-only; near-zero diff on the AwesomeAssertions path.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: One pilot repo migrated green..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR with trigger date/conditions; rollout script ready.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: One pilot repo migrated green.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-011 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Decide the FluentAssertions 7.x end-of-life strategy. Evaluate AwesomeAssertions (FA7-compatible fork) vs Shouldly vs plain asserts; ADR; swap the SDK-injected package on the chosen date; keep the ceiling until then (CC-35).

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Build.Sdk test injection, renovate ceiling, constitution. Evaluate AwesomeAssertions (FA7-compatible fork) vs Shouldly vs plain asserts; ADR; swap the SDK-injected package on the chosen date; keep the ceiling until then (CC-35).

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

The fleet pins FA <8 for licensing; 7.x receives no fixes; the pin is load-bearing in Build.Sdk, renovate, and the constitution, and will eventually break against an xunit/.NET bump.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. The fleet pins FA <8 for licensing; 7.x receives no fixes; the pin is load-bearing in Build.Sdk, renovate, and the constitution, and will eventually break against an xunit/.NET bump.

Required outcome

Evaluate AwesomeAssertions (FA7-compatible fork) vs Shouldly vs plain asserts; ADR; swap the SDK-injected package on the chosen date; keep the ceiling until then (CC-35).

In scope

Build.Sdk test injection, renovate ceiling, constitution. Evaluate AwesomeAssertions (FA7-compatible fork) vs Shouldly vs plain asserts; ADR; swap the SDK-injected package on the chosen date; keep the ceiling until then (CC-35).

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

No hard roadmap dependency blocks discovery or implementation.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. Evaluate AwesomeAssertions (FA7-compatible fork
3. vs Shouldly vs plain asserts
4. swap the SDK-injected package on the chosen date
5. keep the ceiling until then (CC-35).
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

Test-only; near-zero diff on the AwesomeAssertions path.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: One pilot repo migrated green..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: One pilot repo migrated green.
```

Acceptance criteria

- ADR with trigger date/conditions; rollout script ready.

Working rules

Use a focused branch linked to ATYA-011; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 1 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-010 — Ratify the test-platform direction (MTP vs VSTest)

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-010 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Ready |
| Hard dependencies | None |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0044) |
| Confidence | High |
| Risk | Low |
| Effort | M |

## Problem description

Build.Sdk injects VSTest-mode xunit.v3 while the UiAutomation template runs MTP; no ratified direction; Microsoft's direction is MTP; CI coverage collection differs between the two.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Build.Sdk injects VSTest-mode xunit.v3 while the UiAutomation template runs MTP; no ratified direction; Microsoft's direction is MTP; CI coverage collection differs between the two.

## Desired outcome

ADR-06; recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection). Don't rush; don't scaffold five templates before deciding.

## In-scope work

Build.Sdk test injection, CI coverage step, all test projects, test templates. ADR-06; recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection). Don't rush; don't scaffold five templates before deciding.

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
2. recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection)
3. don't scaffold five templates before deciding.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

SDK major; coverage pipeline is the risk — prove on two pilot repos first.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Coverage numbers match pre/post on pilots..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR merged; pilot repos green with identical coverage gates; constitution testing section amended.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Coverage numbers match pre/post on pilots.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-010 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Ratify the test-platform direction (MTP vs VSTest). ADR-06; recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection). Don't rush; don't scaffold five templates before deciding.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Build.Sdk test injection, CI coverage step, all test projects, test templates. ADR-06; recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection). Don't rush; don't scaffold five templates before deciding.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Build.Sdk injects VSTest-mode xunit.v3 while the UiAutomation template runs MTP; no ratified direction; Microsoft's direction is MTP; CI coverage collection differs between the two.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Build.Sdk injects VSTest-mode xunit.v3 while the UiAutomation template runs MTP; no ratified direction; Microsoft's direction is MTP; CI coverage collection differs between the two.

Required outcome

ADR-06; recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection). Don't rush; don't scaffold five templates before deciding.

In scope

Build.Sdk test injection, CI coverage step, all test projects, test templates. ADR-06; recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection). Don't rush; don't scaffold five templates before deciding.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

No hard roadmap dependency blocks discovery or implementation.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. recommend MTP fleet-wide at the next SDK major (flip the flag, drop VSTest packages, move coverage to MTP-compatible collection)
3. don't scaffold five templates before deciding.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

SDK major; coverage pipeline is the risk — prove on two pilot repos first.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Coverage numbers match pre/post on pilots..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Coverage numbers match pre/post on pilots.
```

Acceptance criteria

- ADR merged; pilot repos green with identical coverage gates; constitution testing section amended.

Working rules

Use a focused branch linked to ATYA-010; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 1 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

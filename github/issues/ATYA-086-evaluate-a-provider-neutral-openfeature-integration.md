# ATYA-086 — Evaluate a provider-neutral OpenFeature integration

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-086 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-068; ATYA-075; ATYA-079 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0070) |
| Confidence | High |
| Risk | Low |
| Effort | M |

## Problem description

Roadmap-requested; composition/telemetry contracts not yet stable; a provider-selecting package would break neutrality; evaluation context risks cardinality/privacy issues.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Roadmap-requested; composition/telemetry contracts not yet stable; a provider-selecting package would break neutrality; evaluation context risks cardinality/privacy issues.

## Desired outcome

Default disposition: template composition (per ECO-004's reclassification); ADR only if stable cross-service policy emerges; provider SDKs stay in applications; never in a foundation package.

## In-scope work

Possibly template content only. Default disposition: template composition (per ECO-004's reclassification); ADR only if stable cross-service policy emerges; provider SDKs stay in applications; never in a foundation package.

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions. No durable package or repository is created by this decision/proof task; any admitted implementation requires a separate task hard-dependent on ATYA-013.

## Hard dependencies

- ATYA-068
- ATYA-075
- ATYA-079

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. Default disposition: template composition (per ECO-004's reclassification)
3. ADR only if stable cross-service policy emerges
4. provider SDKs stay in applications
5. never in a foundation package.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

N/A until admitted.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Recorded decision; if built: outage/fallback integration tests.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: N/A.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-086 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Evaluate a provider-neutral OpenFeature integration. Default disposition: template composition (per ECO-004's reclassification); ADR only if stable cross-service policy emerges; provider SDKs stay in applications; never in a foundation package.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Possibly template content only. Default disposition: template composition (per ECO-004's reclassification); ADR only if stable cross-service policy emerges; provider SDKs stay in applications; never in a foundation package.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Roadmap-requested; composition/telemetry contracts not yet stable; a provider-selecting package would break neutrality; evaluation context risks cardinality/privacy issues.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Roadmap-requested; composition/telemetry contracts not yet stable; a provider-selecting package would break neutrality; evaluation context risks cardinality/privacy issues.

Required outcome

Default disposition: template composition (per ECO-004's reclassification); ADR only if stable cross-service policy emerges; provider SDKs stay in applications; never in a foundation package.

In scope

Possibly template content only. Default disposition: template composition (per ECO-004's reclassification); ADR only if stable cross-service policy emerges; provider SDKs stay in applications; never in a foundation package.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions. No durable package or repository is created by this decision/proof task; any admitted implementation requires a separate task hard-dependent on ATYA-013.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-068, ATYA-075, ATYA-079.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. Default disposition: template composition (per ECO-004's reclassification)
3. ADR only if stable cross-service policy emerges
4. provider SDKs stay in applications
5. never in a foundation package.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

N/A until admitted.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: N/A.
```

Acceptance criteria

- Recorded decision; if built: outage/fallback integration tests.

Working rules

Use a focused branch linked to ATYA-086; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 6 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

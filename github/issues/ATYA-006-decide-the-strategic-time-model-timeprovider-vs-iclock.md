# ATYA-006 — Decide the strategic Time model (TimeProvider vs IClock)

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-006 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-005 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0016 + S-0028) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

IClock/SystemClock duplicates a subset of BCL TimeProvider; the governance fake doesn't implement IClock; downstream packages (Idempotency, Outbox) force the choice onto consumers.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. IClock/SystemClock duplicates a subset of BCL TimeProvider; the governance fake doesn't implement IClock; downstream packages (Idempotency, Outbox) force the choice onto consumers.

## Desired outcome

ADR-02. Recommended direction (adjudicated): TimeProvider is the injection currency; IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway; one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.

## In-scope work

Foundation.Time, Governance.Testing, Idempotency, Outbox, BackgroundServices. ADR-02. Recommended direction (adjudicated): TimeProvider is the injection currency; IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway; one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

- ATYA-005

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. Recommended direction (adjudicated): TimeProvider is the injection currency
3. IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway
4. one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

Additive in 1.x; signature changes ride the 2.0 wave with adapters.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Deterministic multi-read/delay tests against the official fake..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR merged; adapter + DI overload shipped; Idempotency's private test fake deleted in favor of the governance fake (the dogfood proof).

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Deterministic multi-read/delay tests against the official fake.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-006 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Decide the strategic Time model (TimeProvider vs IClock). ADR-02. Recommended direction (adjudicated): TimeProvider is the injection currency; IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway; one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Foundation.Time, Governance.Testing, Idempotency, Outbox, BackgroundServices. ADR-02. Recommended direction (adjudicated): TimeProvider is the injection currency; IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway; one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

IClock/SystemClock duplicates a subset of BCL TimeProvider; the governance fake doesn't implement IClock; downstream packages (Idempotency, Outbox) force the choice onto consumers.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. IClock/SystemClock duplicates a subset of BCL TimeProvider; the governance fake doesn't implement IClock; downstream packages (Idempotency, Outbox) force the choice onto consumers.

Required outcome

ADR-02. Recommended direction (adjudicated): TimeProvider is the injection currency; IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway; one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.

In scope

Foundation.Time, Governance.Testing, Idempotency, Outbox, BackgroundServices. ADR-02. Recommended direction (adjudicated): TimeProvider is the injection currency; IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway; one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-005.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. Recommended direction (adjudicated): TimeProvider is the injection currency
3. IClock becomes a thin UTC-opinion adapter (Fable's additive path now — TimeProviderClock, AddAtyaClock(TimeProvider)), retirement folded into the 2.0 train only if it happens anyway
4. one official fake that satisfies the chosen contract (GPT's requirement), wrapping FakeTimeProvider.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

Additive in 1.x; signature changes ride the 2.0 wave with adapters.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Deterministic multi-read/delay tests against the official fake..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Deterministic multi-read/delay tests against the official fake.
```

Acceptance criteria

- ADR merged; adapter + DI overload shipped; Idempotency's private test fake deleted in favor of the governance fake (the dogfood proof).

Working rules

Use a focused branch linked to ATYA-006; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 1 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

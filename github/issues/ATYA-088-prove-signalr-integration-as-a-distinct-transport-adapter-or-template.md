# ATYA-088 — Prove SignalR integration as a distinct transport adapter (or template content)

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-088 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-009; ATYA-022; ATYA-075; ATYA-079 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0072) |
| Confidence | High |
| Risk | Low |
| Effort | M |

## Problem description

Hub invocation error shapes, correlation, lifecycle, backpressure, and reconnect are undefined by the current HTTP-oriented contracts; reusing ProblemDetails unchanged would mislead.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Hub invocation error shapes, correlation, lifecycle, backpressure, and reconnect are undefined by the current HTTP-oriented contracts; reusing ProblemDetails unchanged would mislead.

## Desired outcome

ADR mapping existing contracts to hub semantics; reference hub/client test matrix (auth expiry, propagation, structured errors, cancellation, reconnect, backpressure, telemetry); publish only stable integration policy; default: template/reference content per ECO-004.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Possibly template content only. ADR mapping existing contracts to hub semantics; reference hub/client test matrix (auth expiry, propagation, structured errors, cancellation, reconnect, backpressure, telemetry); publish only stable integration policy; default: template/reference content per ECO-004.

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions. No durable package or repository is created by this decision/proof task; any admitted implementation requires a separate task hard-dependent on ATYA-013.

## Hard dependencies

- ATYA-009
- ATYA-022
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
2. ADR mapping existing contracts to hub semantics
3. reference hub/client test matrix (auth expiry, propagation, structured errors, cancellation, reconnect, backpressure, telemetry)
4. publish only stable integration policy
5. default: template/reference content per ECO-004.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

N/A until admitted.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Recorded decision; reference matrix exists before any package.

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

You are implementing ATYA-088 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Prove SignalR integration as a distinct transport adapter (or template content). ADR mapping existing contracts to hub semantics; reference hub/client test matrix (auth expiry, propagation, structured errors, cancellation, reconnect, backpressure, telemetry); publish only stable integration policy; default: template/reference content per ECO-004.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Hub invocation error shapes, correlation, lifecycle, backpressure, and reconnect are undefined by the current HTTP-oriented contracts; reusing ProblemDetails unchanged would mislead.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Hub invocation error shapes, correlation, lifecycle, backpressure, and reconnect are undefined by the current HTTP-oriented contracts; reusing ProblemDetails unchanged would mislead.

Required outcome

ADR mapping existing contracts to hub semantics; reference hub/client test matrix (auth expiry, propagation, structured errors, cancellation, reconnect, backpressure, telemetry); publish only stable integration policy; default: template/reference content per ECO-004.

In scope

Possibly template content only. ADR mapping existing contracts to hub semantics; reference hub/client test matrix (auth expiry, propagation, structured errors, cancellation, reconnect, backpressure, telemetry); publish only stable integration policy; default: template/reference content per ECO-004.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions. No durable package or repository is created by this decision/proof task; any admitted implementation requires a separate task hard-dependent on ATYA-013.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-009, ATYA-022, ATYA-075, ATYA-079.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR mapping existing contracts to hub semantics
3. reference hub/client test matrix (auth expiry, propagation, structured errors, cancellation, reconnect, backpressure, telemetry)
4. publish only stable integration policy
5. default: template/reference content per ECO-004.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

N/A until admitted.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

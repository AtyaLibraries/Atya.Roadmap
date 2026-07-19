# ATYA-009 — Define the framework-neutral versioned HTTP error/validation wire contract

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-009 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-008 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0033) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

No versioned wire schema exists for error kind, stable code, safe detail, validation entries, metadata policy, and correlation; Http.Client couples to the server-oriented ProblemDetails package to share models; Validation's two paths emit incompatible shapes.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. No versioned wire schema exists for error kind, stable code, safe detail, validation entries, metadata policy, and correlation; Http.Client couples to the server-oriented ProblemDetails package to share models; Validation's two paths emit incompatible shapes.

## Desired outcome

ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation). Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided; new assembly only if not (deferred per §6). Golden JSON fixtures + tolerant-reader rules; actual HTTP status is transport-authoritative.

## In-scope work

ProblemDetails, Validation, Http.Client, Middleware; ErrorKind additions (ECO-045). ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation). Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided; new assembly only if not (deferred per §6). Golden JSON fixtures + tolerant-reader rules; actual HTTP status is transport-authoritative.

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

- ATYA-008

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation)
3. Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided
4. new assembly only if not (deferred per §6)
5. Golden JSON fixtures + tolerant-reader rules
6. actual HTTP status is transport-authoritative.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

Tolerant readers for legacy shapes during a stated window (ECO-052 implements).

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fixtures round-trip through server mapper and client reader in a reference test..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR + schema doc + golden fixtures merged; reserved extension names listed; version negotiation defined.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Fixtures round-trip through server mapper and client reader in a reference test.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-009 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Define the framework-neutral versioned HTTP error/validation wire contract. ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation). Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided; new assembly only if not (deferred per §6). Golden JSON fixtures + tolerant-reader rules; actual HTTP status is transport-authoritative.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: ProblemDetails, Validation, Http.Client, Middleware; ErrorKind additions (ECO-045). ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation). Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided; new assembly only if not (deferred per §6). Golden JSON fixtures + tolerant-reader rules; actual HTTP status is transport-authoritative.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

No versioned wire schema exists for error kind, stable code, safe detail, validation entries, metadata policy, and correlation; Http.Client couples to the server-oriented ProblemDetails package to share models; Validation's two paths emit incompatible shapes.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. No versioned wire schema exists for error kind, stable code, safe detail, validation entries, metadata policy, and correlation; Http.Client couples to the server-oriented ProblemDetails package to share models; Validation's two paths emit incompatible shapes.

Required outcome

ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation). Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided; new assembly only if not (deferred per §6). Golden JSON fixtures + tolerant-reader rules; actual HTTP status is transport-authoritative.

In scope

ProblemDetails, Validation, Http.Client, Middleware; ErrorKind additions (ECO-045). ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation). Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided; new assembly only if not (deferred per §6). Golden JSON fixtures + tolerant-reader rules; actual HTTP status is transport-authoritative.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-008.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-05: one contract (kind, code, message policy, target, validation entries, attempted-values policy, correlation field, schema version + negotiation)
3. Packaging home decided in the ADR — default: framework-neutral surface within existing ProblemDetails packaging if ASP.NET dependencies can be avoided
4. new assembly only if not (deferred per §6)
5. Golden JSON fixtures + tolerant-reader rules
6. actual HTTP status is transport-authoritative.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

Tolerant readers for legacy shapes during a stated window (ECO-052 implements).

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fixtures round-trip through server mapper and client reader in a reference test..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Fixtures round-trip through server mapper and client reader in a reference test.
```

Acceptance criteria

- ADR + schema doc + golden fixtures merged; reserved extension names listed; version negotiation defined.

Working rules

Use a focused branch linked to ATYA-009; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 1 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

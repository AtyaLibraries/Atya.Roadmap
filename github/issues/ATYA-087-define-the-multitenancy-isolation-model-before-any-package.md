# ATYA-087 — Define the multitenancy isolation model before any package

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-087 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-022; ATYA-068; ATYA-075; ATYA-123 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0071) |
| Confidence | High |
| Risk | Low |
| Effort | M |

## Problem description

No accepted tenant resolution/propagation/data-isolation/background-work model; an ambient mutable tenant accessor would leak across requests, scopes, and pooled resources.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. No accepted tenant resolution/propagation/data-isolation/background-work model; an ambient mutable tenant accessor would leak across requests, scopes, and pooled resources.

## Desired outcome

Threat model + ADR (immutable scoped context, trusted resolution precedence, spoofing protection, propagation through HTTP/messages/jobs, partitioning, bounded telemetry); isolation proven with parallel request/queue/worker/EF tests before any public abstraction; independent security review.

## In-scope work

Future package, gated. Threat model + ADR (immutable scoped context, trusted resolution precedence, spoofing protection, propagation through HTTP/messages/jobs, partitioning, bounded telemetry); isolation proven with parallel request/queue/worker/EF tests before any public abstraction; independent security review.

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions. No durable package or repository is created by this decision/proof task; any admitted implementation requires a separate task hard-dependent on ATYA-013.

## Hard dependencies

- ATYA-022
- ATYA-068
- ATYA-075
- ATYA-123

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. isolation proven with parallel request/queue/worker/EF tests before any public abstraction
3. independent security review.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

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

- Threat model + ADR exist before any PackageId; isolation test matrix defined.

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

You are implementing ATYA-087 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Define the multitenancy isolation model before any package. Threat model + ADR (immutable scoped context, trusted resolution precedence, spoofing protection, propagation through HTTP/messages/jobs, partitioning, bounded telemetry); isolation proven with parallel request/queue/worker/EF tests before any public abstraction; independent security review.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Future package, gated. Threat model + ADR (immutable scoped context, trusted resolution precedence, spoofing protection, propagation through HTTP/messages/jobs, partitioning, bounded telemetry); isolation proven with parallel request/queue/worker/EF tests before any public abstraction; independent security review.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

No accepted tenant resolution/propagation/data-isolation/background-work model; an ambient mutable tenant accessor would leak across requests, scopes, and pooled resources.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. No accepted tenant resolution/propagation/data-isolation/background-work model; an ambient mutable tenant accessor would leak across requests, scopes, and pooled resources.

Required outcome

Threat model + ADR (immutable scoped context, trusted resolution precedence, spoofing protection, propagation through HTTP/messages/jobs, partitioning, bounded telemetry); isolation proven with parallel request/queue/worker/EF tests before any public abstraction; independent security review.

In scope

Future package, gated. Threat model + ADR (immutable scoped context, trusted resolution precedence, spoofing protection, propagation through HTTP/messages/jobs, partitioning, bounded telemetry); isolation proven with parallel request/queue/worker/EF tests before any public abstraction; independent security review.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions. No durable package or repository is created by this decision/proof task; any admitted implementation requires a separate task hard-dependent on ATYA-013.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-022, ATYA-068, ATYA-075, ATYA-123.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. isolation proven with parallel request/queue/worker/EF tests before any public abstraction
3. independent security review.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

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

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: N/A.
```

Acceptance criteria

- Threat model + ADR exist before any PackageId; isolation test matrix defined.

Working rules

Use a focused branch linked to ATYA-087; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 6 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

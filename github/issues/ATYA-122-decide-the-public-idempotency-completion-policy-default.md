# ATYA-122 — Decide the public idempotency completion-policy default

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-122 |
| Owning repository | Idempotency |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-002; ATYA-008 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Split from Fable F-0026 and Claude consolidated ECO-057 |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

IdempotencyCompletionPolicy exposes SuccessOnly and SuccessAndFailure, but the public default changes replay and retry behavior and was left to implementation-time design review.

## Root cause

Failure replay, retry safety, operator expectations, and backward compatibility were not separated into an accepted public-contract decision.

## Desired outcome

Accept one public completion-policy default, define explicit override semantics, document compatibility with current behavior, and specify failure Result, exception, cancellation, lease-expiry, and replay outcomes so ATYA-057 only implements the decision.

## In-scope work

Idempotency public-contract ADR, behavior matrix, compatibility/migration policy, and default/override documentation.

## Out-of-scope work

Lease/store implementation or choosing the default during ATYA-057 coding.

## Hard dependencies

- ATYA-002
- ATYA-008

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-061

## Implementation sequence

1. Refresh current success/failure/exception/cancellation behavior.
2. Evaluate SuccessOnly and SuccessAndFailure against retry safety and compatibility.
3. Select one public default and define explicit override behavior.
4. Publish the full behavior/migration matrix and acceptance evidence.
5. Link ATYA-057 to the accepted decision.

## Architecture guidance

Idempotency owns this package-specific public contract. The ADR must be explicit, versioned, deterministic, and free of ambient defaults.

## Compatibility and migration

Name the existing behavior, the last compatible version, required major/minor classification, configuration override, and rollback behavior.

## Security and privacy considerations

Account for duplicate side effects, poisoned failure replay, payload mismatch, denial-of-service through retries, and sensitive failure payload retention.

## Testing strategy

Define table-driven tests for success Result, failure Result, throw, cancellation, stale lease, retry, and explicit override; ATYA-057 implements them.

## Documentation work

Publish the ADR, behavior matrix, migration guidance, and operational recommendations in Idempotency and link Atya.Roadmap evidence.

## Measurable acceptance criteria

- Exactly one public default is accepted with rationale and compatibility classification.
- Every result/exception/cancellation/replay case has a deterministic documented outcome.
- ATYA-057 contains no remaining default-selection language.

## Definition of done

- The ADR and behavior matrix are accepted.
- Compatibility, security, migration, override, and rollback rules are complete.
- ATYA-057 is an implementation-only task.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: completion-policy behavior matrix approved.
```

## Rollback strategy

Keep the old behavior available only through the explicitly documented compatibility override/window; never silently change persisted replay semantics.

## Standalone implementation prompt

You are implementing ATYA-122 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Decide the public idempotency completion-policy default. Accept one public completion-policy default, define explicit override semantics, document compatibility with current behavior, and specify failure Result, exception, cancellation, lease-expiry, and replay outcomes so ATYA-057 only implements the decision.

Exact repository/package scope

Owning repository: Idempotency. In scope: Idempotency public-contract ADR, behavior matrix, compatibility/migration policy, and default/override documentation.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

IdempotencyCompletionPolicy exposes SuccessOnly and SuccessAndFailure, but the public default changes replay and retry behavior and was left to implementation-time design review.

Root cause: Failure replay, retry safety, operator expectations, and backward compatibility were not separated into an accepted public-contract decision.

Required outcome

Accept one public completion-policy default, define explicit override semantics, document compatibility with current behavior, and specify failure Result, exception, cancellation, lease-expiry, and replay outcomes so ATYA-057 only implements the decision.

In scope

Idempotency public-contract ADR, behavior matrix, compatibility/migration policy, and default/override documentation.

Out of scope

Lease/store implementation or choosing the default during ATYA-057 coding.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002, ATYA-008.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Refresh current success/failure/exception/cancellation behavior.
2. Evaluate SuccessOnly and SuccessAndFailure against retry safety and compatibility.
3. Select one public default and define explicit override behavior.
4. Publish the full behavior/migration matrix and acceptance evidence.
5. Link ATYA-057 to the accepted decision.

Architecture constraints

Idempotency owns this package-specific public contract. The ADR must be explicit, versioned, deterministic, and free of ambient defaults.

Compatibility and migration requirements

Name the existing behavior, the last compatible version, required major/minor classification, configuration override, and rollback behavior.

Security and privacy requirements

Account for duplicate side effects, poisoned failure replay, payload mismatch, denial-of-service through retries, and sensitive failure payload retention.

Tests

Define table-driven tests for success Result, failure Result, throw, cancellation, stale lease, retry, and explicit override; ATYA-057 implements them.

Documentation

Publish the ADR, behavior matrix, migration guidance, and operational recommendations in Idempotency and link Atya.Roadmap evidence.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: completion-policy behavior matrix approved.
```

Acceptance criteria

- Exactly one public default is accepted with rationale and compatibility classification.
- Every result/exception/cancellation/replay case has a deterministic documented outcome.
- ATYA-057 contains no remaining default-selection language.

Working rules

Use a focused branch linked to ATYA-122; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

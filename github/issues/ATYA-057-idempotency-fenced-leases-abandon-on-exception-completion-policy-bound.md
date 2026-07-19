# ATYA-057 — Idempotency: fenced leases, abandon-on-exception, completion policy, bounded store

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-057 |
| Owning repository | Idempotency |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-006; ATYA-122; ATYA-051 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0026 + S-0034 + S-0035) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

A thrown operation leaves the key In-Progress until lease expiry; failure Results are stored and replayed for the TTL (or remain in-progress — the sources describe the mechanism differently; verify); the store protocol has no generation/fencing token, so an expired slow owner can complete over a newer owner; finalization rides the caller's cancellation token; the in-memory store grows unboundedly; typed-replay TValue mismatch untested.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. A thrown operation leaves the key In-Progress until lease expiry; failure Results are stored and replayed for the TTL (or remain in-progress — the sources describe the mechanism differently; verify); the store protocol has no generation/fencing token, so an expired slow owner can complete over a newer owner; finalization rides the caller's cancellation token; the in-memory store grows unboundedly; typed-replay TValue mismatch untested.

## Desired outcome

Implement the completion-policy default accepted by ATYA-122; replace status-only begin with an opaque fenced execution lease; compare-and-set complete/renew/abandon; make finalization cancellation-independent and bounded; detect payload mismatch; mark the in-memory store test/development-only and enforce configurable finite capacity with deterministic expiry cleanup; publish conformance tests; and replace Idempotency's private fake with the ATYA-051 Governance.Testing contract.

## In-scope work

Application.Idempotency contract-breaking implementation and tests. The public completion default is read from accepted ATYA-122 and must not be chosen during coding. Includes the Idempotency-owned ATYA-051 fake migration.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-006
- ATYA-122
- ATYA-051

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-122
- ATYA-051
- ATYA-058
- ATYA-061

## Implementation sequence

1. Read accepted ATYA-122 and ATYA-051 contracts; stop if either is not accepted.
2. Introduce the opaque generation/fencing lease.
3. Implement fenced complete, renew, and abandon with cancellation-independent finalization.
4. Implement the accepted completion default and payload mismatch handling; mark the in-memory store test/development-only and enforce configurable finite capacity plus deterministic expiry cleanup.
5. Replace the private test fake with Governance.Testing.
6. Add deterministic stale-owner, exception, replay, capacity, and typed-payload conformance tests.
7. Publish migration/API/release evidence without revisiting the accepted default.

## Architecture guidance

Keep the change inside Idempotency's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Breaking store contract; single coordinated change in the 2.0 wave; conformance suite is the migration contract for any future store.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Deterministic-clock interleaving tests via the ECO-051 fake..

## Documentation work

Update Idempotency README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- An expired owner's completion is rejected after a new owner begins and a thrown operation frees the key immediately.
- Failure replay exactly matches the ATYA-122 accepted default; the implementation contains no open design choice.
- The conformance suite is green on the in-memory store; capacity and expiry tests prove bounded cleanup; production registration rejects or warns against the test/development-only store; Idempotency tests use the ATYA-051 governance fake.

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
# Task-specific proof: Deterministic-clock interleaving tests via the ECO-051 fake.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-057 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Idempotency: fenced leases, abandon-on-exception, completion policy, bounded store. Implement the completion-policy default accepted by ATYA-122; replace status-only begin with an opaque fenced execution lease; compare-and-set complete/renew/abandon; make finalization cancellation-independent and bounded; detect payload mismatch; mark the in-memory store test/development-only and enforce configurable finite capacity with deterministic expiry cleanup; publish conformance tests; and replace Idempotency's private fake with the ATYA-051 Governance.Testing contract.

Exact repository/package scope

Owning repository: Idempotency. In scope: Application.Idempotency contract-breaking implementation and tests. The public completion default is read from accepted ATYA-122 and must not be chosen during coding. Includes the Idempotency-owned ATYA-051 fake migration.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

A thrown operation leaves the key In-Progress until lease expiry; failure Results are stored and replayed for the TTL (or remain in-progress — the sources describe the mechanism differently; verify); the store protocol has no generation/fencing token, so an expired slow owner can complete over a newer owner; finalization rides the caller's cancellation token; the in-memory store grows unboundedly; typed-replay TValue mismatch untested.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. A thrown operation leaves the key In-Progress until lease expiry; failure Results are stored and replayed for the TTL (or remain in-progress — the sources describe the mechanism differently; verify); the store protocol has no generation/fencing token, so an expired slow owner can complete over a newer owner; finalization rides the caller's cancellation token; the in-memory store grows unboundedly; typed-replay TValue mismatch untested.

Required outcome

Implement the completion-policy default accepted by ATYA-122; replace status-only begin with an opaque fenced execution lease; compare-and-set complete/renew/abandon; make finalization cancellation-independent and bounded; detect payload mismatch; mark the in-memory store test/development-only and enforce configurable finite capacity with deterministic expiry cleanup; publish conformance tests; and replace Idempotency's private fake with the ATYA-051 Governance.Testing contract.

In scope

Application.Idempotency contract-breaking implementation and tests. The public completion default is read from accepted ATYA-122 and must not be chosen during coding. Includes the Idempotency-owned ATYA-051 fake migration.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-006, ATYA-122, ATYA-051.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Read accepted ATYA-122 and ATYA-051 contracts; stop if either is not accepted.
2. Introduce the opaque generation/fencing lease.
3. Implement fenced complete, renew, and abandon with cancellation-independent finalization.
4. Implement the accepted completion default and payload mismatch handling; mark the in-memory store test/development-only and enforce configurable finite capacity plus deterministic expiry cleanup.
5. Replace the private test fake with Governance.Testing.
6. Add deterministic stale-owner, exception, replay, capacity, and typed-payload conformance tests.
7. Publish migration/API/release evidence without revisiting the accepted default.

Architecture constraints

Keep the change inside Idempotency's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Breaking store contract; single coordinated change in the 2.0 wave; conformance suite is the migration contract for any future store.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Deterministic-clock interleaving tests via the ECO-051 fake..

Documentation

Update Idempotency README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Deterministic-clock interleaving tests via the ECO-051 fake.
```

Acceptance criteria

- An expired owner's completion is rejected after a new owner begins and a thrown operation frees the key immediately.
- Failure replay exactly matches the ATYA-122 accepted default; the implementation contains no open design choice.
- The conformance suite is green on the in-memory store; capacity and expiry tests prove bounded cleanup; production registration rejects or warns against the test/development-only store; Idempotency tests use the ATYA-051 governance fake.

Working rules

Use a focused branch linked to ATYA-057; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

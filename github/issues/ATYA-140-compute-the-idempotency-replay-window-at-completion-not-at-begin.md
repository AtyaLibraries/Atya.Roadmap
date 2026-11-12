# ATYA-140 — Compute the idempotency replay window at completion, not at begin

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-140 |
| Owning repository | Idempotency |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-057; ATYA-122 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-09) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

`Application/Idempotency/src/Idempotency/IdempotentExecutor.cs` computes `IdempotencyLease.From(_clock, timeToLive)` BEFORE calling TryBeginAsync, and `InMemoryIdempotencyStore.Entry.Complete` carries that original Lease forward onto the completed record. The lease therefore serves two incompatible purposes — the in-progress lock window and the replay-validity window — both anchored to the moment the operation STARTED. If the operation takes longer than timeToLive (a payment call, a slow third-party API — exactly the operations idempotency exists for) the completed record is already expired at the instant it is stored. The next caller with the same key receives IdempotencyErrors.Expired, and the call after that has the expired entry removed by TryBeginAsync and re-executes the operation. Idempotency silently degrades to at-least-once precisely under the latency conditions that cause clients to retry. This is distinct from the fencing and ownership defects already scheduled under ATYA-057: it reproduces with a single caller and no concurrency at all.

## Root cause

One lease value models two independent time windows with different start instants.

## Desired outcome

The replay window starts when the result becomes durable, independently of how long the operation ran, so a slow operation remains replayable.

## Affected scope

Primary owner: **Idempotency**. Package: `Atya.Application.Idempotency`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Application.Idempotency. The replay window starts when the result becomes durable, independently of how long the operation ran, so a slow operation remains replayable.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-057
- ATYA-122

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-123
- ATYA-061

## Implementation sequence

1. Separate the two windows in IIdempotencyStore: TryBeginAsync takes an execution/lock lease; CompleteAsync takes its own IdempotencyLease (or a TimeSpan replayTimeToLive) computed from clock.UtcNowOffset at completion time.
2. Update IdempotentExecutor.ExecuteAsync to accept an explicit executionTimeout and replayTimeToLive; do not derive one from the other.
3. Update InMemoryIdempotencyStore.Entry.Complete to store the completion lease.
4. Document the invariant that the replay window starts when the result is durable.
5. Add controllable-IClock tests: an operation exceeding the execution lease still produces a replayable record, and a second caller receives Completed rather than Expired immediately afterwards.

## Architecture guidance

Execution leases and replay windows are separate concepts and must be separate parameters in the store contract. Any durable adapter designed before this fix will bake the conflation into its schema, so this must precede ATYA-123.

## Compatibility and migration

Breaking for IIdempotencyStore implementers. The interface is already being reshaped by ATYA-057 — land both changes in one release so implementers migrate once.

## Security and privacy considerations

Prevents unintended duplicate execution of non-idempotent side effects (payments, provisioning) under the retry conditions that make duplicates most likely.

## Testing strategy

Controllable-clock scenarios: operation shorter than TTL, operation longer than TTL, operation longer than TTL followed by two subsequent callers.

## Documentation work

Document both windows, their defaults, and guidance for choosing them relative to expected operation latency.

## Measurable acceptance criteria

- An operation that runs longer than the execution lease still stores a replayable record.
- A caller arriving immediately after such a completion receives Completed, not Expired.
- The operation body is executed exactly once across the whole scenario.
- TryBeginAsync and CompleteAsync take independent lease parameters.

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
# Task-specific proof: Controllable-clock scenario proving a slow operation remains replayable and executes once.
dotnet test -c Release --filter FullyQualifiedName~SlowOperationReplay
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-140 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Compute the idempotency replay window at completion, not at begin. The replay window starts when the result becomes durable, independently of how long the operation ran, so a slow operation remains replayable.

Exact repository/package scope

Owning repository: Idempotency. In scope: `Atya.Application.Idempotency` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Application/Idempotency/src/Idempotency/IdempotentExecutor.cs` computes `IdempotencyLease.From(_clock, timeToLive)` BEFORE calling TryBeginAsync, and `InMemoryIdempotencyStore.Entry.Complete` carries that original Lease forward onto the completed record. The lease therefore serves two incompatible purposes — the in-progress lock window and the replay-validity window — both anchored to the moment the operation STARTED. If the operation takes longer than timeToLive (a payment call, a slow third-party API — exactly the operations idempotency exists for) the completed record is already expired at the instant it is stored. The next caller with the same key receives IdempotencyErrors.Expired, and the call after that has the expired entry removed by TryBeginAsync and re-executes the operation. Idempotency silently degrades to at-least-once precisely under the latency conditions that cause clients to retry. This is distinct from the fencing and ownership defects already scheduled under ATYA-057: it reproduces with a single caller and no concurrency at all.

Root cause: One lease value models two independent time windows with different start instants.

Required outcome

The replay window starts when the result becomes durable, independently of how long the operation ran, so a slow operation remains replayable.

Blockers and dependencies

Blocked until these complete: ATYA-057, ATYA-122.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Separate the two windows in IIdempotencyStore: TryBeginAsync takes an execution/lock lease; CompleteAsync takes its own IdempotencyLease (or a TimeSpan replayTimeToLive) computed from clock.UtcNowOffset at completion time.
2. Update IdempotentExecutor.ExecuteAsync to accept an explicit executionTimeout and replayTimeToLive; do not derive one from the other.
3. Update InMemoryIdempotencyStore.Entry.Complete to store the completion lease.
4. Document the invariant that the replay window starts when the result is durable.
5. Add controllable-IClock tests: an operation exceeding the execution lease still produces a replayable record, and a second caller receives Completed rather than Expired immediately afterwards.

Architecture constraints

Execution leases and replay windows are separate concepts and must be separate parameters in the store contract. Any durable adapter designed before this fix will bake the conflation into its schema, so this must precede ATYA-123.

Compatibility and migration requirements

Breaking for IIdempotencyStore implementers. The interface is already being reshaped by ATYA-057 — land both changes in one release so implementers migrate once.

Security and privacy requirements

Prevents unintended duplicate execution of non-idempotent side effects (payments, provisioning) under the retry conditions that make duplicates most likely.

Tests

Controllable-clock scenarios: operation shorter than TTL, operation longer than TTL, operation longer than TTL followed by two subsequent callers.

Documentation

Document both windows, their defaults, and guidance for choosing them relative to expected operation latency.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Controllable-clock scenario proving a slow operation remains replayable and executes once.
dotnet test -c Release --filter FullyQualifiedName~SlowOperationReplay
```

Acceptance criteria

- An operation that runs longer than the execution lease still stores a replayable record.
- A caller arriving immediately after such a completion receives Completed, not Expired.
- The operation body is executed exactly once across the whole scenario.
- TryBeginAsync and CompleteAsync take independent lease parameters.

Working rules

Use a focused branch linked to ATYA-140; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

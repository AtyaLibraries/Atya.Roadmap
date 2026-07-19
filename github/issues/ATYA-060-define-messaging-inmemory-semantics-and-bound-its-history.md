# ATYA-060 — Define Messaging.InMemory semantics and bound its history

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-060 |
| Owning repository | Messaging.InMemory |
| Priority | P2 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-059 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0028 (InMemory half) + S-0052) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

PublishedMessages grows without bound (leak in long-lived hosts); a throwing consumer skips later handlers and propagates to the publisher; the bus reportedly records a message as published before handlers complete; concurrent publish/reentrancy rules undefined; production-vs-test positioning ambiguous.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. PublishedMessages grows without bound (leak in long-lived hosts); a throwing consumer skips later handlers and propagates to the publisher; the bus reportedly records a message as published before handlers complete; concurrent publish/reentrancy rules undefined; production-vs-test positioning ambiguous.

## Desired outcome

Declare the transport test/development-only. Accept a publish only after validation, the pre-acceptance cancellation check, monotonic sequence assignment, subscriber snapshot, and append to a configurable capacity ring buffer whose default is 1,024 messages. Dispatch non-reentrant publishes serially in acceptance-sequence order; invoke each snapshot sequentially in registration order; subscription changes affect the next publish only. Allow a handler's reentrant publish to execute depth-first with the next sequence so awaiting it cannot deadlock. Continue through all snapshotted handlers after an exception, report delivery failures through an explicit error observer, and never revoke acceptance; post-acceptance caller cancellation does not abort dispatch. PublishAsync completes after that message's dispatch. Clear() clears retained history but not subscriptions or the monotonic sequence. Add exception, cancellation, concurrency, reentrancy, subscribe-during-dispatch, and retention tests. Make no durability or broker claim.

## In-scope work

Messaging.InMemory. Declare the transport test/development-only. Accept a publish only after validation, the pre-acceptance cancellation check, monotonic sequence assignment, subscriber snapshot, and append to a configurable capacity ring buffer whose default is 1,024 messages. Dispatch non-reentrant publishes serially in acceptance-sequence order; invoke each snapshot sequentially in registration order; subscription changes affect the next publish only. Allow a handler's reentrant publish to execute depth-first with the next sequence so awaiting it cannot deadlock. Continue through all snapshotted handlers after an exception, report delivery failures through an explicit error observer, and never revoke acceptance; post-acceptance caller cancellation does not abort dispatch. PublishAsync completes after that message's dispatch. Clear() clears retained history but not subscriptions or the monotonic sequence. Add exception, cancellation, concurrency, reentrancy, subscribe-during-dispatch, and retention tests. Make no durability or broker claim.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-059

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Declare the transport test/development-only and implement the ATYA-059 acceptance boundary: validate and honor cancellation, assign a monotonic sequence, snapshot subscribers, and append history before acceptance
3. Dispatch non-reentrant publishes serially by acceptance sequence and handlers sequentially by registration order; apply subscription changes to the next publish only; execute awaited reentrant publishes depth-first
4. Continue after handler exceptions, report each through an explicit delivery-error observer, preserve acceptance, and ignore caller cancellation after acceptance
5. Use a configurable ring history with a default capacity of 1,024; Clear() removes history but preserves subscriptions and sequence monotonicity
6. Test exceptions, pre/post-acceptance cancellation, concurrent ordering, reentrancy, subscribe-during-dispatch, observer reporting, and retention
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Messaging.InMemory's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Ship the deterministic dispatch and bounded-history behavior in the 2.0 wave. The default retained-history capacity becomes 1,024, handler failure no longer skips later handlers or revokes acceptance, and post-acceptance cancellation no longer aborts dispatch; document configuration and migration for tests that relied on the accidental behavior.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Retention + concurrency tests..

## Documentation work

Update Messaging.InMemory README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- A long-running publish loop remains within the configured 1,024-message default; concurrent non-reentrant publishes dispatch in acceptance-sequence order; handlers run in registration order; an awaited reentrant publish completes depth-first without deadlock; a throwing handler is reported while later handlers still run; pre-acceptance cancellation rejects and post-acceptance cancellation does not revoke; Clear() preserves subscriptions and sequence monotonicity; the ATYA-059 contract kit passes.

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
# Task-specific proof: Retention + concurrency tests.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-060 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Define Messaging.InMemory semantics and bound its history. Declare the transport test/development-only. Accept a publish only after validation, the pre-acceptance cancellation check, monotonic sequence assignment, subscriber snapshot, and append to a configurable capacity ring buffer whose default is 1,024 messages. Dispatch non-reentrant publishes serially in acceptance-sequence order; invoke each snapshot sequentially in registration order; subscription changes affect the next publish only. Allow a handler's reentrant publish to execute depth-first with the next sequence so awaiting it cannot deadlock. Continue through all snapshotted handlers after an exception, report delivery failures through an explicit error observer, and never revoke acceptance; post-acceptance caller cancellation does not abort dispatch. PublishAsync completes after that message's dispatch. Clear() clears retained history but not subscriptions or the monotonic sequence. Add exception, cancellation, concurrency, reentrancy, subscribe-during-dispatch, and retention tests. Make no durability or broker claim.

Exact repository/package scope

Owning repository: Messaging.InMemory. In scope: Messaging.InMemory. Declare the transport test/development-only. Accept a publish only after validation, the pre-acceptance cancellation check, monotonic sequence assignment, subscriber snapshot, and append to a configurable capacity ring buffer whose default is 1,024 messages. Dispatch non-reentrant publishes serially in acceptance-sequence order; invoke each snapshot sequentially in registration order; subscription changes affect the next publish only. Allow a handler's reentrant publish to execute depth-first with the next sequence so awaiting it cannot deadlock. Continue through all snapshotted handlers after an exception, report delivery failures through an explicit error observer, and never revoke acceptance; post-acceptance caller cancellation does not abort dispatch. PublishAsync completes after that message's dispatch. Clear() clears retained history but not subscriptions or the monotonic sequence. Add exception, cancellation, concurrency, reentrancy, subscribe-during-dispatch, and retention tests. Make no durability or broker claim.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

PublishedMessages grows without bound (leak in long-lived hosts); a throwing consumer skips later handlers and propagates to the publisher; the bus reportedly records a message as published before handlers complete; concurrent publish/reentrancy rules undefined; production-vs-test positioning ambiguous.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. PublishedMessages grows without bound (leak in long-lived hosts); a throwing consumer skips later handlers and propagates to the publisher; the bus reportedly records a message as published before handlers complete; concurrent publish/reentrancy rules undefined; production-vs-test positioning ambiguous.

Required outcome

Declare the transport test/development-only. Accept a publish only after validation, the pre-acceptance cancellation check, monotonic sequence assignment, subscriber snapshot, and append to a configurable capacity ring buffer whose default is 1,024 messages. Dispatch non-reentrant publishes serially in acceptance-sequence order; invoke each snapshot sequentially in registration order; subscription changes affect the next publish only. Allow a handler's reentrant publish to execute depth-first with the next sequence so awaiting it cannot deadlock. Continue through all snapshotted handlers after an exception, report delivery failures through an explicit error observer, and never revoke acceptance; post-acceptance caller cancellation does not abort dispatch. PublishAsync completes after that message's dispatch. Clear() clears retained history but not subscriptions or the monotonic sequence. Add exception, cancellation, concurrency, reentrancy, subscribe-during-dispatch, and retention tests. Make no durability or broker claim.

In scope

Messaging.InMemory. Declare the transport test/development-only. Accept a publish only after validation, the pre-acceptance cancellation check, monotonic sequence assignment, subscriber snapshot, and append to a configurable capacity ring buffer whose default is 1,024 messages. Dispatch non-reentrant publishes serially in acceptance-sequence order; invoke each snapshot sequentially in registration order; subscription changes affect the next publish only. Allow a handler's reentrant publish to execute depth-first with the next sequence so awaiting it cannot deadlock. Continue through all snapshotted handlers after an exception, report delivery failures through an explicit error observer, and never revoke acceptance; post-acceptance caller cancellation does not abort dispatch. PublishAsync completes after that message's dispatch. Clear() clears retained history but not subscriptions or the monotonic sequence. Add exception, cancellation, concurrency, reentrancy, subscribe-during-dispatch, and retention tests. Make no durability or broker claim.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-059.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Declare the transport test/development-only and implement the ATYA-059 acceptance boundary: validate and honor cancellation, assign a monotonic sequence, snapshot subscribers, and append history before acceptance
3. Dispatch non-reentrant publishes serially by acceptance sequence and handlers sequentially by registration order; apply subscription changes to the next publish only; execute awaited reentrant publishes depth-first
4. Continue after handler exceptions, report each through an explicit delivery-error observer, preserve acceptance, and ignore caller cancellation after acceptance
5. Use a configurable ring history with a default capacity of 1,024; Clear() removes history but preserves subscriptions and sequence monotonicity
6. Test exceptions, pre/post-acceptance cancellation, concurrent ordering, reentrancy, subscribe-during-dispatch, observer reporting, and retention
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Messaging.InMemory's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Ship the deterministic dispatch and bounded-history behavior in the 2.0 wave. The default retained-history capacity becomes 1,024, handler failure no longer skips later handlers or revokes acceptance, and post-acceptance cancellation no longer aborts dispatch; document configuration and migration for tests that relied on the accidental behavior.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Retention + concurrency tests..

Documentation

Update Messaging.InMemory README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Retention + concurrency tests.
```

Acceptance criteria

- A long-running publish loop remains within the configured 1,024-message default; concurrent non-reentrant publishes dispatch in acceptance-sequence order; handlers run in registration order; an awaited reentrant publish completes depth-first without deadlock; a throwing handler is reported while later handlers still run; pre-acceptance cancellation rejects and post-acceptance cancellation does not revoke; Clear() preserves subscriptions and sequence monotonicity; the ATYA-059 contract kit passes.

Working rules

Use a focused branch linked to ATYA-060; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-135 — Stop graceful shutdown during failure backoff from faulting the host

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-135 |
| Owning repository | BackgroundServices |
| Priority | P1 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-021 |
| Advisory prerequisites | ATYA-134 |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-04) |
| Confidence | High |
| Risk | High |
| Effort | S |

## Problem description

In both `PeriodicBackgroundService.RunLoopAsync` and `ScopedPeriodicBackgroundService.RunLoopAsync` the retry path is `catch (Exception exception) when (consecutiveFailures + 1 < _options.MaxConsecutiveFailures) { … await DelayAsync(_options.FailureDelay, stoppingToken); }`. The await sits inside a catch clause, and C# does not route exceptions thrown from a catch clause to sibling catch clauses of the same try. The neighbouring `catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)` therefore cannot observe the TaskCanceledException that Task.Delay raises when the host stops during the backoff window. The exception escapes ExecuteAsync, and with the default `BackgroundServiceExceptionBehavior.StopHost` the host logs a fatal unhandled-exception error on what was a clean shutdown. Any deployment, scale-down or pod eviction landing in a 5-second backoff window produces a false-alarm crash record, which trains operators to ignore the one signal that matters.

## Root cause

An awaited cancellable operation was placed inside a catch clause whose sibling handler was assumed to cover it. The interval delay in the try block is covered; the failure delay in the catch block is not.

## Desired outcome

Host shutdown at any point in the loop — including mid-backoff — completes cleanly with no unhandled exception, no faulted ExecuteTask and no fatal log entry.

## Affected scope

Primary owner: **BackgroundServices**. Package: `Atya.Hosting.BackgroundServices`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Hosting.BackgroundServices. Host shutdown at any point in the loop — including mid-backoff — completes cleanly with no unhandled exception, no faulted ExecuteTask and no fatal log entry.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-021

## Advisory prerequisites

- ATYA-134

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-134
- ATYA-136

## Implementation sequence

1. Restructure so no await occurs inside a catch clause: capture the retry decision as a `TimeSpan? pendingDelay`, exit the try/catch, then perform the delay in its own guarded block.
2. Guard that delay with `catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { break; }`.
3. Apply the identical change to both PeriodicBackgroundService and ScopedPeriodicBackgroundService.
4. Add a test that faults the first iteration, requests host shutdown during FailureDelay, and asserts StopAsync completes with no logged unhandled exception and a non-faulted ExecuteTask.

## Architecture guidance

Cancellation is a normal control-flow outcome for a hosted service, not a failure. Every awaited call in the loop must route cancellation to the same break path.

## Compatibility and migration

Non-breaking. Changes only the shutdown-path outcome from faulted to clean.

## Security and privacy considerations

None directly; removes a false-positive fatal signal that masks real incidents in operational logs.

## Testing strategy

Shutdown-during-backoff test, shutdown-during-interval test, and shutdown-during-iteration test, each asserting a clean StopAsync.

## Documentation work

Document the cancellation contract: the loop exits cleanly on stoppingToken cancellation from any state.

## Measurable acceptance criteria

- Requesting host shutdown while the service is inside FailureDelay completes StopAsync without a logged unhandled exception.
- ExecuteTask is not in the Faulted state after such a shutdown.
- No await remains inside any catch clause in either RunLoopAsync.
- Shutdown during iteration and during the interval delay remain clean.

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
# Task-specific proof: Shutdown-during-backoff integration test asserting a non-faulted ExecuteTask.
dotnet test -c Release --filter FullyQualifiedName~ShutdownDuringBackoff
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-135 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Stop graceful shutdown during failure backoff from faulting the host. Host shutdown at any point in the loop — including mid-backoff — completes cleanly with no unhandled exception, no faulted ExecuteTask and no fatal log entry.

Exact repository/package scope

Owning repository: BackgroundServices. In scope: `Atya.Hosting.BackgroundServices` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

In both `PeriodicBackgroundService.RunLoopAsync` and `ScopedPeriodicBackgroundService.RunLoopAsync` the retry path is `catch (Exception exception) when (consecutiveFailures + 1 < _options.MaxConsecutiveFailures) { … await DelayAsync(_options.FailureDelay, stoppingToken); }`. The await sits inside a catch clause, and C# does not route exceptions thrown from a catch clause to sibling catch clauses of the same try. The neighbouring `catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)` therefore cannot observe the TaskCanceledException that Task.Delay raises when the host stops during the backoff window. The exception escapes ExecuteAsync, and with the default `BackgroundServiceExceptionBehavior.StopHost` the host logs a fatal unhandled-exception error on what was a clean shutdown. Any deployment, scale-down or pod eviction landing in a 5-second backoff window produces a false-alarm crash record, which trains operators to ignore the one signal that matters.

Root cause: An awaited cancellable operation was placed inside a catch clause whose sibling handler was assumed to cover it. The interval delay in the try block is covered; the failure delay in the catch block is not.

Required outcome

Host shutdown at any point in the loop — including mid-backoff — completes cleanly with no unhandled exception, no faulted ExecuteTask and no fatal log entry.

Blockers and dependencies

Blocked until these complete: ATYA-021.

Advisory prerequisites

Advisory only, nonblocking: ATYA-134.

Detailed implementation steps

1. Restructure so no await occurs inside a catch clause: capture the retry decision as a `TimeSpan? pendingDelay`, exit the try/catch, then perform the delay in its own guarded block.
2. Guard that delay with `catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested) { break; }`.
3. Apply the identical change to both PeriodicBackgroundService and ScopedPeriodicBackgroundService.
4. Add a test that faults the first iteration, requests host shutdown during FailureDelay, and asserts StopAsync completes with no logged unhandled exception and a non-faulted ExecuteTask.

Architecture constraints

Cancellation is a normal control-flow outcome for a hosted service, not a failure. Every awaited call in the loop must route cancellation to the same break path.

Compatibility and migration requirements

Non-breaking. Changes only the shutdown-path outcome from faulted to clean.

Security and privacy requirements

None directly; removes a false-positive fatal signal that masks real incidents in operational logs.

Tests

Shutdown-during-backoff test, shutdown-during-interval test, and shutdown-during-iteration test, each asserting a clean StopAsync.

Documentation

Document the cancellation contract: the loop exits cleanly on stoppingToken cancellation from any state.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Shutdown-during-backoff integration test asserting a non-faulted ExecuteTask.
dotnet test -c Release --filter FullyQualifiedName~ShutdownDuringBackoff
```

Acceptance criteria

- Requesting host shutdown while the service is inside FailureDelay completes StopAsync without a logged unhandled exception.
- ExecuteTask is not in the Faulted state after such a shutdown.
- No await remains inside any catch clause in either RunLoopAsync.
- Shutdown during iteration and during the interval delay remain clean.

Working rules

Use a focused branch linked to ATYA-135; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 2 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

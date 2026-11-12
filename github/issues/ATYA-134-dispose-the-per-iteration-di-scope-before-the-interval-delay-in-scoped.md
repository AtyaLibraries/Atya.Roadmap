# ATYA-134 — Dispose the per-iteration DI scope before the interval delay in ScopedPeriodicBackgroundService

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-134 |
| Owning repository | BackgroundServices |
| Priority | P1 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-021 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-03); corrects the remedy in GPT 5.6 SOL S-0039 |
| Confidence | High |
| Risk | High |
| Effort | S |

## Problem description

`Hosting/BackgroundServices/src/BackgroundServices/ScopedPeriodicBackgroundService.cs` `RunLoopAsync` contains `using IServiceScope scope = _scopeFactory.CreateScope();` as a using-DECLARATION inside the loop's try block. The scope is therefore disposed at the end of the try, which is AFTER `await DelayAsync(_options.Interval, stoppingToken)`. With the default Interval of one minute, every scoped DbContext, database connection, HttpClient handler lease and message-broker channel resolved by an iteration is held open for the full idle period — permanently, in steady state. A fleet of N such workers holds N pooled connections doing nothing, and pool exhaustion under load presents as an unrelated timeout in the request path. SOL S-0039 cites these same lines but describes the defect as "scopes use synchronous disposal", which is a separate and much smaller issue; converting to `await using` in place does not fix the lifetime.

## Root cause

A using-declaration scopes to the enclosing block, and the delay was placed in the same block as the work. The intended lifetime (one iteration) and the lexical lifetime (one iteration plus one interval) diverge silently.

## Desired outcome

The per-iteration scope is created, used and asynchronously disposed strictly around the iteration body, with no scoped service held across any delay.

## Affected scope

Primary owner: **BackgroundServices**. Package: `Atya.Hosting.BackgroundServices`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Hosting.BackgroundServices. The per-iteration scope is created, used and asynchronously disposed strictly around the iteration body, with no scoped service held across any delay.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-021

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-135
- ATYA-136
- ATYA-117

## Implementation sequence

1. Replace the using-declaration with an explicit block: `await using (var scope = _scopeFactory.CreateAsyncScope()) { await ExecuteIterationAsync(scope.ServiceProvider, stoppingToken).ConfigureAwait(false); }`.
2. Move `consecutiveFailures = 0;` and the interval delay outside that block.
3. Use `CreateAsyncScope` / `await using` so scoped `IAsyncDisposable` services dispose correctly (this retains the SOL S-0039 point).
4. Add a Host-based integration test with a scoped service recording construction and disposal timestamps, asserting disposal precedes the interval delay by less than the delay duration.

## Architecture guidance

Scope lifetime must equal iteration lifetime. Do not introduce a long-lived scope or resolve scoped services into fields on the hosted service.

## Compatibility and migration

Non-breaking for derived types: `ExecuteIterationAsync(IServiceProvider, CancellationToken)` keeps its signature. Derived classes that captured the provider beyond the iteration were already broken and will now fail fast on a disposed scope.

## Security and privacy considerations

No new trust boundary. Shorter scope lifetime reduces the window in which credentials held by scoped services stay resident.

## Testing strategy

Real `Host` integration test asserting disposal ordering; a leak test running N iterations and asserting the scoped-instance count equals N with none live during the delay.

## Documentation work

Document the per-iteration scope lifetime guarantee in the BackgroundServices README so consumers know not to capture the provider.

## Measurable acceptance criteria

- The DI scope is disposed before the interval delay begins, proven by timestamp ordering in an integration test.
- Scope disposal is asynchronous (`CreateAsyncScope` / `await using`).
- Running N iterations creates and disposes exactly N scopes with none live during any delay.
- `dotnet build -warnaserror` and `dotnet test` pass with no public API change.

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
# Task-specific proof: Host integration test asserting scope disposal precedes the interval delay.
dotnet test -c Release --filter FullyQualifiedName~ScopeLifetime
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-134 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Dispose the per-iteration DI scope before the interval delay in ScopedPeriodicBackgroundService. The per-iteration scope is created, used and asynchronously disposed strictly around the iteration body, with no scoped service held across any delay.

Exact repository/package scope

Owning repository: BackgroundServices. In scope: `Atya.Hosting.BackgroundServices` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Hosting/BackgroundServices/src/BackgroundServices/ScopedPeriodicBackgroundService.cs` `RunLoopAsync` contains `using IServiceScope scope = _scopeFactory.CreateScope();` as a using-DECLARATION inside the loop's try block. The scope is therefore disposed at the end of the try, which is AFTER `await DelayAsync(_options.Interval, stoppingToken)`. With the default Interval of one minute, every scoped DbContext, database connection, HttpClient handler lease and message-broker channel resolved by an iteration is held open for the full idle period — permanently, in steady state. A fleet of N such workers holds N pooled connections doing nothing, and pool exhaustion under load presents as an unrelated timeout in the request path. SOL S-0039 cites these same lines but describes the defect as "scopes use synchronous disposal", which is a separate and much smaller issue; converting to `await using` in place does not fix the lifetime.

Root cause: A using-declaration scopes to the enclosing block, and the delay was placed in the same block as the work. The intended lifetime (one iteration) and the lexical lifetime (one iteration plus one interval) diverge silently.

Required outcome

The per-iteration scope is created, used and asynchronously disposed strictly around the iteration body, with no scoped service held across any delay.

Blockers and dependencies

Blocked until these complete: ATYA-021.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Replace the using-declaration with an explicit block: `await using (var scope = _scopeFactory.CreateAsyncScope()) { await ExecuteIterationAsync(scope.ServiceProvider, stoppingToken).ConfigureAwait(false); }`.
2. Move `consecutiveFailures = 0;` and the interval delay outside that block.
3. Use `CreateAsyncScope` / `await using` so scoped `IAsyncDisposable` services dispose correctly (this retains the SOL S-0039 point).
4. Add a Host-based integration test with a scoped service recording construction and disposal timestamps, asserting disposal precedes the interval delay by less than the delay duration.

Architecture constraints

Scope lifetime must equal iteration lifetime. Do not introduce a long-lived scope or resolve scoped services into fields on the hosted service.

Compatibility and migration requirements

Non-breaking for derived types: `ExecuteIterationAsync(IServiceProvider, CancellationToken)` keeps its signature. Derived classes that captured the provider beyond the iteration were already broken and will now fail fast on a disposed scope.

Security and privacy requirements

No new trust boundary. Shorter scope lifetime reduces the window in which credentials held by scoped services stay resident.

Tests

Real `Host` integration test asserting disposal ordering; a leak test running N iterations and asserting the scoped-instance count equals N with none live during the delay.

Documentation

Document the per-iteration scope lifetime guarantee in the BackgroundServices README so consumers know not to capture the provider.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Host integration test asserting scope disposal precedes the interval delay.
dotnet test -c Release --filter FullyQualifiedName~ScopeLifetime
```

Acceptance criteria

- The DI scope is disposed before the interval delay begins, proven by timestamp ordering in an integration test.
- Scope disposal is asynchronous (`CreateAsyncScope` / `await using`).
- Running N iterations creates and disposes exactly N scopes with none live during any delay.
- `dotnet build -warnaserror` and `dotnet test` pass with no public API change.

Working rules

Use a focused branch linked to ATYA-134; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 2 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

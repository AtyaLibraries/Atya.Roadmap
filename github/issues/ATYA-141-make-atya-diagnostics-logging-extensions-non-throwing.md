# ATYA-141 — Make Atya.Diagnostics.Logging extensions non-throwing

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-141 |
| Owning repository | Logging |
| Priority | P2 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-068; ATYA-025 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-10) |
| Confidence | High |
| Risk | Medium |
| Effort | S |

## Problem description

Every public helper in `Diagnostics/Logging/src/Logging/Extensions/LoggerExtensions.cs` validates by throwing: `Guard.AgainstNullOrWhiteSpace(operationName)` raises ArgumentException, and LogRetryAttempt additionally raises ArgumentOutOfRangeException when `attemptNumber > maxAttempts`. Logging calls appear overwhelmingly in catch blocks, and an exception raised from a logging call inside a catch block replaces the exception being handled — the original stack trace is lost and the reported failure is a misleading ArgumentException from the diagnostics package. Hosting/BackgroundServices demonstrates the coupling directly: PeriodicBackgroundService.RunLoopAsync calls `_logger.LogRetryAttempt(OperationName, consecutiveFailures, _options.MaxConsecutiveFailures)` from inside a catch clause, so the two packages are one arithmetic change away from destroying every background-worker failure report. The guards also run before any IsEnabled check, so validation cost is paid even at disabled log levels.

## Root cause

Argument-validation conventions written for domain APIs were applied to a diagnostics API, where the caller is usually already handling a failure.

## Desired outcome

No public logging helper throws for any input, and disabled log levels cost nothing beyond the level check.

## Affected scope

Primary owner: **Logging**. Package: `Atya.Diagnostics.Logging`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Diagnostics.Logging. No public logging helper throws for any input, and disabled log levels cost nothing beyond the level check.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-068
- ATYA-025

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-135
- ATYA-136

## Implementation sequence

1. Adopt "logging never throws" as a package charter rule and record it in Governance.CodeQuality (ATYA-025).
2. Replace throwing guards with defensive normalization: substitute a documented placeholder ("<unspecified>") for null/whitespace names and clamp attemptNumber rather than rejecting it.
3. Remove the `attemptNumber > maxAttempts` check entirely.
4. Add an `ILogger.IsEnabled(level)` short-circuit before argument work in each helper.
5. Add a test that calls every public helper with null, empty, whitespace and out-of-range arguments and asserts none throws.

## Architecture guidance

Diagnostics APIs are total functions. Validation failures degrade the message, never the caller's control flow.

## Compatibility and migration

Behaviourally breaking for anyone relying on the guards as assertions; frame as a fix in release notes. No signature changes.

## Security and privacy considerations

Placeholder substitution must not echo unbounded caller input into log messages; keep existing length expectations.

## Testing strategy

Exhaustive hostile-argument test over every public helper; an allocation/level test proving disabled levels short-circuit before argument work.

## Documentation work

State the never-throws guarantee in the Logging README and in the CodeQuality charter.

## Measurable acceptance criteria

- No public helper in LoggerExtensions throws for null, empty, whitespace or out-of-range arguments.
- Each helper short-circuits on `IsEnabled(level) == false` before performing argument work.
- The `attemptNumber > maxAttempts` check is removed.
- The never-throws rule is recorded in the Governance.CodeQuality charter.

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
# Task-specific proof: Hostile-argument test asserting no public logging helper throws.
dotnet test -c Release --filter FullyQualifiedName~LoggingNeverThrows
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-141 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make Atya.Diagnostics.Logging extensions non-throwing. No public logging helper throws for any input, and disabled log levels cost nothing beyond the level check.

Exact repository/package scope

Owning repository: Logging. In scope: `Atya.Diagnostics.Logging` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Every public helper in `Diagnostics/Logging/src/Logging/Extensions/LoggerExtensions.cs` validates by throwing: `Guard.AgainstNullOrWhiteSpace(operationName)` raises ArgumentException, and LogRetryAttempt additionally raises ArgumentOutOfRangeException when `attemptNumber > maxAttempts`. Logging calls appear overwhelmingly in catch blocks, and an exception raised from a logging call inside a catch block replaces the exception being handled — the original stack trace is lost and the reported failure is a misleading ArgumentException from the diagnostics package. Hosting/BackgroundServices demonstrates the coupling directly: PeriodicBackgroundService.RunLoopAsync calls `_logger.LogRetryAttempt(OperationName, consecutiveFailures, _options.MaxConsecutiveFailures)` from inside a catch clause, so the two packages are one arithmetic change away from destroying every background-worker failure report. The guards also run before any IsEnabled check, so validation cost is paid even at disabled log levels.

Root cause: Argument-validation conventions written for domain APIs were applied to a diagnostics API, where the caller is usually already handling a failure.

Required outcome

No public logging helper throws for any input, and disabled log levels cost nothing beyond the level check.

Blockers and dependencies

Blocked until these complete: ATYA-068, ATYA-025.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Adopt "logging never throws" as a package charter rule and record it in Governance.CodeQuality (ATYA-025).
2. Replace throwing guards with defensive normalization: substitute a documented placeholder ("<unspecified>") for null/whitespace names and clamp attemptNumber rather than rejecting it.
3. Remove the `attemptNumber > maxAttempts` check entirely.
4. Add an `ILogger.IsEnabled(level)` short-circuit before argument work in each helper.
5. Add a test that calls every public helper with null, empty, whitespace and out-of-range arguments and asserts none throws.

Architecture constraints

Diagnostics APIs are total functions. Validation failures degrade the message, never the caller's control flow.

Compatibility and migration requirements

Behaviourally breaking for anyone relying on the guards as assertions; frame as a fix in release notes. No signature changes.

Security and privacy requirements

Placeholder substitution must not echo unbounded caller input into log messages; keep existing length expectations.

Tests

Exhaustive hostile-argument test over every public helper; an allocation/level test proving disabled levels short-circuit before argument work.

Documentation

State the never-throws guarantee in the Logging README and in the CodeQuality charter.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Hostile-argument test asserting no public logging helper throws.
dotnet test -c Release --filter FullyQualifiedName~LoggingNeverThrows
```

Acceptance criteria

- No public helper in LoggerExtensions throws for null, empty, whitespace or out-of-range arguments.
- Each helper short-circuits on `IsEnabled(level) == false` before performing argument work.
- The `attemptNumber > maxAttempts` check is removed.
- The never-throws rule is recorded in the Governance.CodeQuality charter.

Working rules

Use a focused branch linked to ATYA-141; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

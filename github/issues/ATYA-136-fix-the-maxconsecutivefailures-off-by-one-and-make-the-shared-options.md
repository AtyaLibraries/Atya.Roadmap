# ATYA-136 — Fix the MaxConsecutiveFailures off-by-one and make the shared options default immutable

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-136 |
| Owning repository | BackgroundServices |
| Priority | P2 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-021 |
| Advisory prerequisites | ATYA-135 |
| Implementation state | Partially satisfied |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-05); extends GPT 5.6 SOL S-0039 |
| Confidence | High |
| Risk | Medium |
| Effort | S |

## Problem description

Two defects in Hosting/BackgroundServices. (1) The retry filter is `when (consecutiveFailures + 1 < _options.MaxConsecutiveFailures)`, so a configured value of N tolerates N−1 failures, and `MaxConsecutiveFailures = 1` rethrows on the very first failure — zero retries — while the XML documentation states "the number of consecutive failures allowed before the exception is rethrown". A caller who sets 1 expecting one retry gets a host stop. (2) `PeriodicBackgroundServiceOptions.Default` is a public static instance with public setters, and Validate() returns `this` rather than a snapshot, so both base classes alias a caller-mutable object and every service that omits options shares one mutable instance. Setting `PeriodicBackgroundServiceOptions.Default.Interval = TimeSpan.Zero` anywhere in a process converts every default-configured worker into a busy loop. SOL S-0039 identified the mutable global default; the off-by-one is new.

## Root cause

The retry filter predicts the next failure count instead of comparing the current one, and the options type serves as both the DI binding surface and the runtime snapshot.

## Desired outcome

MaxConsecutiveFailures = N tolerates exactly N consecutive failures before rethrow, and no worker can be affected by another component mutating shared option state.

## Affected scope

Primary owner: **BackgroundServices**. Package: `Atya.Hosting.BackgroundServices`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Hosting.BackgroundServices. MaxConsecutiveFailures = N tolerates exactly N consecutive failures before rethrow, and no worker can be affected by another component mutating shared option state.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-021

## Advisory prerequisites

- ATYA-135

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-134
- ATYA-135

## Implementation sequence

1. Change the filter to compare the current count after increment, or restate it with an explicit attempt counter, so N means N.
2. Add a table-driven test asserting the observed retry count for MaxConsecutiveFailures ∈ {1, 2, 3}.
3. Introduce an immutable settings snapshot returned by Validate() and stored by both base classes; keep the mutable options class purely as the IOptions binding surface.
4. Remove or [Obsolete] the public static Default property.

## Architecture guidance

Configuration binding surface and runtime snapshot are different concerns. The snapshot must be immutable and per-worker, consistent with the ATYA-021 redesign.

## Compatibility and migration

The filter change is behaviourally breaking for anyone who tuned around the current semantics — release-note it as a fix. Removing or obsoleting the public Default property is a source-breaking change; stage it via [Obsolete] first if a compatibility window is required.

## Security and privacy considerations

Removes an action-at-a-distance vector where unrelated code can force every default-configured worker into a busy loop.

## Testing strategy

Table-driven retry-count test; a test asserting mutation of the previously shared default cannot affect a constructed service.

## Documentation work

Correct the XML documentation for MaxConsecutiveFailures to match the implemented semantics and note the change in release notes.

## Measurable acceptance criteria

- MaxConsecutiveFailures = 1 permits exactly one retry before rethrow; = 3 permits exactly three.
- The XML documentation matches the observed behaviour.
- No public mutable static options instance remains reachable, or it is [Obsolete] with a documented replacement.
- A constructed service is unaffected by post-construction mutation of the options object it was built from.

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
# Task-specific proof: Table-driven retry-count assertions across MaxConsecutiveFailures values.
dotnet test -c Release --filter FullyQualifiedName~RetryPolicy
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-136 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Fix the MaxConsecutiveFailures off-by-one and make the shared options default immutable. MaxConsecutiveFailures = N tolerates exactly N consecutive failures before rethrow, and no worker can be affected by another component mutating shared option state.

Exact repository/package scope

Owning repository: BackgroundServices. In scope: `Atya.Hosting.BackgroundServices` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Two defects in Hosting/BackgroundServices. (1) The retry filter is `when (consecutiveFailures + 1 < _options.MaxConsecutiveFailures)`, so a configured value of N tolerates N−1 failures, and `MaxConsecutiveFailures = 1` rethrows on the very first failure — zero retries — while the XML documentation states "the number of consecutive failures allowed before the exception is rethrown". A caller who sets 1 expecting one retry gets a host stop. (2) `PeriodicBackgroundServiceOptions.Default` is a public static instance with public setters, and Validate() returns `this` rather than a snapshot, so both base classes alias a caller-mutable object and every service that omits options shares one mutable instance. Setting `PeriodicBackgroundServiceOptions.Default.Interval = TimeSpan.Zero` anywhere in a process converts every default-configured worker into a busy loop. SOL S-0039 identified the mutable global default; the off-by-one is new.

Root cause: The retry filter predicts the next failure count instead of comparing the current one, and the options type serves as both the DI binding surface and the runtime snapshot.

Required outcome

MaxConsecutiveFailures = N tolerates exactly N consecutive failures before rethrow, and no worker can be affected by another component mutating shared option state.

Blockers and dependencies

Blocked until these complete: ATYA-021.

Advisory prerequisites

Advisory only, nonblocking: ATYA-135.

Detailed implementation steps

1. Change the filter to compare the current count after increment, or restate it with an explicit attempt counter, so N means N.
2. Add a table-driven test asserting the observed retry count for MaxConsecutiveFailures ∈ {1, 2, 3}.
3. Introduce an immutable settings snapshot returned by Validate() and stored by both base classes; keep the mutable options class purely as the IOptions binding surface.
4. Remove or [Obsolete] the public static Default property.

Architecture constraints

Configuration binding surface and runtime snapshot are different concerns. The snapshot must be immutable and per-worker, consistent with the ATYA-021 redesign.

Compatibility and migration requirements

The filter change is behaviourally breaking for anyone who tuned around the current semantics — release-note it as a fix. Removing or obsoleting the public Default property is a source-breaking change; stage it via [Obsolete] first if a compatibility window is required.

Security and privacy requirements

Removes an action-at-a-distance vector where unrelated code can force every default-configured worker into a busy loop.

Tests

Table-driven retry-count test; a test asserting mutation of the previously shared default cannot affect a constructed service.

Documentation

Correct the XML documentation for MaxConsecutiveFailures to match the implemented semantics and note the change in release notes.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Table-driven retry-count assertions across MaxConsecutiveFailures values.
dotnet test -c Release --filter FullyQualifiedName~RetryPolicy
```

Acceptance criteria

- MaxConsecutiveFailures = 1 permits exactly one retry before rethrow; = 3 permits exactly three.
- The XML documentation matches the observed behaviour.
- No public mutable static options instance remains reachable, or it is [Obsolete] with a documented replacement.
- A constructed service is unaffected by post-construction mutation of the options object it was built from.

Working rules

Use a focused branch linked to ATYA-136; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 2 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

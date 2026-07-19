# ATYA-021 — Make BackgroundServices consume per-worker validated options

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-021 |
| Owning repository | BackgroundServices |
| Priority | P1 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-002; ATYA-006 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (S-0038 + S-0039) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Reportedly, registered IOptions are never consumed by the base services (defaults silently win) and one global options object cannot serve multiple workers; scoped workers dispose scopes synchronously; loop duplication and static-time delays (backlog-only claim).

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Reportedly, registered IOptions are never consumed by the base services (defaults silently win) and one global options object cannot serve multiple workers; scoped workers dispose scopes synchronously; loop duplication and static-time delays (backlog-only claim).

## Desired outcome

Per-worker generic/named validated options snapshotted at startup; replace the mutable static default; CreateAsyncScope/await using; one internal loop policy; inject the chosen time abstraction; distinguish completed/stopped/faulted; then (only) opt-in fixed-rate/backoff/metrics. Host integration test with two workers on distinct configs.

## In-scope work

Hosting.BackgroundServices. Per-worker generic/named validated options snapshotted at startup; replace the mutable static default; CreateAsyncScope/await using; one internal loop policy; inject the chosen time abstraction; distinguish completed/stopped/faulted; then (only) opt-in fixed-rate/backoff/metrics. Host integration test with two workers on distinct configs.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-002
- ATYA-006

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-014
- ATYA-015
- ATYA-016

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Per-worker generic/named validated options snapshotted at startup
3. replace the mutable static default
4. CreateAsyncScope/await using
5. one internal loop policy
6. inject the chosen time abstraction
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside BackgroundServices's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Possibly breaking ctors; make it explicit rather than preserving broken ambiguity (GPT), ride the coordinated wave if breaking.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-03 probe re-run post-fix..

## Documentation work

Update BackgroundServices README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Two-worker test proves distinct intervals/failure caps from public registration; async disposal verified; no mutable global default remains.

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
# Task-specific proof: SP-03 probe re-run post-fix.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-021 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make BackgroundServices consume per-worker validated options. Per-worker generic/named validated options snapshotted at startup; replace the mutable static default; CreateAsyncScope/await using; one internal loop policy; inject the chosen time abstraction; distinguish completed/stopped/faulted; then (only) opt-in fixed-rate/backoff/metrics. Host integration test with two workers on distinct configs.

Exact repository/package scope

Owning repository: BackgroundServices. In scope: Hosting.BackgroundServices. Per-worker generic/named validated options snapshotted at startup; replace the mutable static default; CreateAsyncScope/await using; one internal loop policy; inject the chosen time abstraction; distinguish completed/stopped/faulted; then (only) opt-in fixed-rate/backoff/metrics. Host integration test with two workers on distinct configs.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Reportedly, registered IOptions are never consumed by the base services (defaults silently win) and one global options object cannot serve multiple workers; scoped workers dispose scopes synchronously; loop duplication and static-time delays (backlog-only claim).

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Reportedly, registered IOptions are never consumed by the base services (defaults silently win) and one global options object cannot serve multiple workers; scoped workers dispose scopes synchronously; loop duplication and static-time delays (backlog-only claim).

Required outcome

Per-worker generic/named validated options snapshotted at startup; replace the mutable static default; CreateAsyncScope/await using; one internal loop policy; inject the chosen time abstraction; distinguish completed/stopped/faulted; then (only) opt-in fixed-rate/backoff/metrics. Host integration test with two workers on distinct configs.

In scope

Hosting.BackgroundServices. Per-worker generic/named validated options snapshotted at startup; replace the mutable static default; CreateAsyncScope/await using; one internal loop policy; inject the chosen time abstraction; distinguish completed/stopped/faulted; then (only) opt-in fixed-rate/backoff/metrics. Host integration test with two workers on distinct configs.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002, ATYA-006.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Per-worker generic/named validated options snapshotted at startup
3. replace the mutable static default
4. CreateAsyncScope/await using
5. one internal loop policy
6. inject the chosen time abstraction
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside BackgroundServices's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Possibly breaking ctors; make it explicit rather than preserving broken ambiguity (GPT), ride the coordinated wave if breaking.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-03 probe re-run post-fix..

Documentation

Update BackgroundServices README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: SP-03 probe re-run post-fix.
```

Acceptance criteria

- Two-worker test proves distinct intervals/failure caps from public registration; async disposal verified; no mutable global default remains.

Working rules

Use a focused branch linked to ATYA-021; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 2 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

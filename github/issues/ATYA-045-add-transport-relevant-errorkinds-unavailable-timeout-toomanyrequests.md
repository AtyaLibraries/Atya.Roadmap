# ATYA-045 — Add transport-relevant ErrorKinds (Unavailable, Timeout, TooManyRequests)

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-045 |
| Owning repository | Results |
| Primary contract owner | Results |
| Downstream repositories | ProblemDetails; Client |
| Child migration requirement | required-existing |
| Child migration tasks | ATYA-053; ATYA-056 |
| Priority | P2 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-009 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0015) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

ErrorKind stops at Unexpected; 429/502/503/504 collapse into generic kinds; ProblemDetails can't round-trip them.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. ErrorKind stops at Unexpected; 429/502/503/504 collapse into generic kinds; ProblemDetails can't round-trip them.

## Desired outcome

Append Unavailable, Timeout, and TooManyRequests to ErrorKind as an additive change; publish the normative HTTP mapping table, older-consumer 422 fallback, API baseline, and switch-exhaustiveness release guidance. ATYA-053 and ATYA-056 implement server and client mappings.

## In-scope work

Foundation.Results enum, normative transport mapping table, public API baseline, compatibility note, and release notes only.

## Out-of-scope work

ProblemDetails and Http.Client mapping code; ATYA-053 and ATYA-056 own those independently executable migrations.

## Ownership and downstream migrations

- Primary contract owner: Results
- Final owning repository: Results
- Downstream repositories: ProblemDetails; Client
- Child migration requirement: required-existing
- Child migration tasks: ATYA-053; ATYA-056
- Rationale: Results owns the enum and normative table; server and client mappings can ship independently after the additive enum and therefore remain separate tasks.

## Hard dependencies

- ATYA-009

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-053
- ATYA-056
- ATYA-023

## Implementation sequence

1. Confirm enum/API compatibility and the accepted wire contract.
2. Append the three enum values without renumbering existing values.
3. Publish the normative status mapping and older-consumer fallback.
4. Update API baselines and switch-exhaustiveness release notes.
5. Hand server and client implementation to ATYA-053 and ATYA-056.

## Architecture guidance

Keep the change inside Results's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Additive; consumer switch warnings noted.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Golden-fixture round-trip..

## Documentation work

Update Results README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- The Results API baseline contains the three additive ErrorKinds without changing existing numeric values.
- A normative table defines 429/503/504 mappings and the older-consumer 422 fallback.
- ATYA-053 and ATYA-056 link to the released enum/table for server and client implementation.

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
# Task-specific proof: Golden-fixture round-trip.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-045 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Add transport-relevant ErrorKinds (Unavailable, Timeout, TooManyRequests). Append Unavailable, Timeout, and TooManyRequests to ErrorKind as an additive change; publish the normative HTTP mapping table, older-consumer 422 fallback, API baseline, and switch-exhaustiveness release guidance. ATYA-053 and ATYA-056 implement server and client mappings.

Exact repository/package scope

Owning repository: Results. In scope: Foundation.Results enum, normative transport mapping table, public API baseline, compatibility note, and release notes only.

Ownership and migration split

- Primary contract owner: Results
- Final owning repository: Results
- Downstream repositories: ProblemDetails; Client
- Child migration requirement: required-existing
- Child migration tasks: ATYA-053; ATYA-056
- Rationale: Results owns the enum and normative table; server and client mappings can ship independently after the additive enum and therefore remain separate tasks.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

ErrorKind stops at Unexpected; 429/502/503/504 collapse into generic kinds; ProblemDetails can't round-trip them.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. ErrorKind stops at Unexpected; 429/502/503/504 collapse into generic kinds; ProblemDetails can't round-trip them.

Required outcome

Append Unavailable, Timeout, and TooManyRequests to ErrorKind as an additive change; publish the normative HTTP mapping table, older-consumer 422 fallback, API baseline, and switch-exhaustiveness release guidance. ATYA-053 and ATYA-056 implement server and client mappings.

In scope

Foundation.Results enum, normative transport mapping table, public API baseline, compatibility note, and release notes only.

Out of scope

ProblemDetails and Http.Client mapping code; ATYA-053 and ATYA-056 own those independently executable migrations.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-009.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Confirm enum/API compatibility and the accepted wire contract.
2. Append the three enum values without renumbering existing values.
3. Publish the normative status mapping and older-consumer fallback.
4. Update API baselines and switch-exhaustiveness release notes.
5. Hand server and client implementation to ATYA-053 and ATYA-056.

Architecture constraints

Keep the change inside Results's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Additive; consumer switch warnings noted.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Golden-fixture round-trip..

Documentation

Update Results README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Golden-fixture round-trip.
```

Acceptance criteria

- The Results API baseline contains the three additive ErrorKinds without changing existing numeric values.
- A normative table defines 429/503/504 mappings and the older-consumer 422 fallback.
- ATYA-053 and ATYA-056 link to the released enum/table for server and client implementation.

Working rules

Use a focused branch linked to ATYA-045; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

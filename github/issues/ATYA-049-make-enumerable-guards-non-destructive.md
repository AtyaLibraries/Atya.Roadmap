# ATYA-049 — Make enumerable guards non-destructive

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-049 |
| Owning repository | Guards |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-002 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0027) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Guard.AgainstNullOrEmpty(IEnumerable<T>) reportedly probes MoveNext on arbitrary sequences and returns the original — one-shot/stateful streams lose their first element by being validated.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Guard.AgainstNullOrEmpty(IEnumerable<T>) reportedly probes MoveNext on arbitrary sequences and returns the original — one-shot/stateful streams lose their first element by being validated.

## Desired outcome

Add the one-shot regression fixture first; retain the arbitrary-enumerable overload but enumerate once into a materialized snapshot and return that documented snapshot; use collection-specific fast paths where they preserve the same contract; preserve parameter diagnostics; benchmark the allocation-bearing path.

## In-scope work

Foundation.Guards. Add the one-shot regression fixture first; retain the arbitrary-enumerable overload but enumerate once into a materialized snapshot and return that documented snapshot; use collection-specific fast paths where they preserve the same contract; preserve parameter diagnostics; benchmark the allocation-bearing path.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-002

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-043
- ATYA-044
- ATYA-045

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. One-shot regression fixture first
3. Retain the arbitrary-enumerable overload, enumerate it once into a materialized snapshot, and return the documented snapshot; add collection-specific fast paths only where semantics remain identical
4. preserve parameter diagnostics
5. benchmark any allocation-bearing replacement.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Guards's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

The arbitrary-enumerable overload remains source-compatible, but callers that relied on deferred execution or reference identity will now receive a documented materialized snapshot. Publish that behavior change and its allocation profile in migration notes.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-10 regression test..

## Documentation work

Update Guards README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- An iterator-backed one-shot sequence is enumerated exactly once and the returned materialized snapshot contains every element in order; collection fast paths preserve the same observable contract.

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
# Task-specific proof: SP-10 regression test.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-049 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make enumerable guards non-destructive. Add the one-shot regression fixture first; retain the arbitrary-enumerable overload but enumerate once into a materialized snapshot and return that documented snapshot; use collection-specific fast paths where they preserve the same contract; preserve parameter diagnostics; benchmark the allocation-bearing path.

Exact repository/package scope

Owning repository: Guards. In scope: Foundation.Guards. Add the one-shot regression fixture first; retain the arbitrary-enumerable overload but enumerate once into a materialized snapshot and return that documented snapshot; use collection-specific fast paths where they preserve the same contract; preserve parameter diagnostics; benchmark the allocation-bearing path.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Guard.AgainstNullOrEmpty(IEnumerable<T>) reportedly probes MoveNext on arbitrary sequences and returns the original — one-shot/stateful streams lose their first element by being validated.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Guard.AgainstNullOrEmpty(IEnumerable<T>) reportedly probes MoveNext on arbitrary sequences and returns the original — one-shot/stateful streams lose their first element by being validated.

Required outcome

Add the one-shot regression fixture first; retain the arbitrary-enumerable overload but enumerate once into a materialized snapshot and return that documented snapshot; use collection-specific fast paths where they preserve the same contract; preserve parameter diagnostics; benchmark the allocation-bearing path.

In scope

Foundation.Guards. Add the one-shot regression fixture first; retain the arbitrary-enumerable overload but enumerate once into a materialized snapshot and return that documented snapshot; use collection-specific fast paths where they preserve the same contract; preserve parameter diagnostics; benchmark the allocation-bearing path.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. One-shot regression fixture first
3. Retain the arbitrary-enumerable overload, enumerate it once into a materialized snapshot, and return the documented snapshot; add collection-specific fast paths only where semantics remain identical
4. preserve parameter diagnostics
5. benchmark any allocation-bearing replacement.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Guards's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

The arbitrary-enumerable overload remains source-compatible, but callers that relied on deferred execution or reference identity will now receive a documented materialized snapshot. Publish that behavior change and its allocation profile in migration notes.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-10 regression test..

Documentation

Update Guards README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: SP-10 regression test.
```

Acceptance criteria

- An iterator-backed one-shot sequence is enumerated exactly once and the returned materialized snapshot contains every element in order; collection fast paths preserve the same observable contract.

Working rules

Use a focused branch linked to ATYA-049; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

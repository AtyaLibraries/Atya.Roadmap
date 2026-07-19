# ATYA-065 — Make Data.Pagination internally coherent and immutable

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-065 |
| Owning repository | Pagination |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-008; ATYA-042 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0051); also closes Fable's unbacklogged review findings [Review §8.1 point 4] |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

LongOffset is exposed but offsets beyond Int32 are rejected; contradictory totals/pages are accepted; mutable collections are retained by reference; no configurable max page size exists; cursor/keyset pagination has no separately admitted design.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. LongOffset is exposed but offsets beyond Int32 are rejected; contradictory totals/pages are accepted; mutable collections are retained by reference; no configurable max page size exists; cursor/keyset pagination has no separately admitted design.

## Desired outcome

Make LongOffset the canonical Int64 offset and accept every non-negative offset representable by the current Int32 page-number/page-size inputs using checked arithmetic; obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; keep page size Int32-bounded; snapshot items; enforce sparse/out-of-range invariants; add a configurable non-global max-page-size binding policy and boundary/property/mutation/JSON tests. Cursor/keyset pagination remains out of scope and requires a separate adopter-gated ADR.

## In-scope work

Data.Pagination. Make LongOffset the canonical Int64 offset and accept every non-negative offset representable by the current Int32 page-number/page-size inputs using checked arithmetic; obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; keep page size Int32-bounded; snapshot items; enforce sparse/out-of-range invariants; add a configurable non-global max-page-size binding policy and boundary/property/mutation/JSON tests. Cursor/keyset pagination is excluded from this implementation.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-008
- ATYA-042

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Make LongOffset the canonical Int64 offset, accept every offset representable by the Int32 inputs with checked arithmetic, obsolete Int32 Offset in the final 1.x line, and remove Offset in 2.0
3. sparse/out-of-range invariants
4. configurable non-global max-page-size binding policy
5. boundary/property/mutation/JSON tests
6. cursor/keyset designed separately with opaque tokens, adopter-gated.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Pagination's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Accepting offsets above Int32.MaxValue through LongOffset is corrective. Obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; migration guidance requires consumers to use LongOffset. Rejecting negative, overflowed, or internally inconsistent values and snapshotting input collections can change behavior; ship those changes with migration notes.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Property tests..

## Documentation work

Update Pagination README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- LongOffset accepts values above Int32.MaxValue through the maximum representable by the Int32 inputs when all invariants hold; Int32 Offset is obsolete in the final 1.x line and absent in 2.0; negative or checked-overflow offsets fail deterministically; invalid totals/pages are unconstructible; oversized page size is clamped per policy; items are immutable post-construction.

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
# Task-specific proof: Property tests.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-065 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make Data.Pagination internally coherent and immutable. Make LongOffset the canonical Int64 offset and accept every non-negative offset representable by the current Int32 page-number/page-size inputs using checked arithmetic; obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; keep page size Int32-bounded; snapshot items; enforce sparse/out-of-range invariants; add a configurable non-global max-page-size binding policy and boundary/property/mutation/JSON tests. Cursor/keyset pagination remains out of scope and requires a separate adopter-gated ADR.

Exact repository/package scope

Owning repository: Pagination. In scope: Data.Pagination. Make LongOffset the canonical Int64 offset and accept every non-negative offset representable by the current Int32 page-number/page-size inputs using checked arithmetic; obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; keep page size Int32-bounded; snapshot items; enforce sparse/out-of-range invariants; add a configurable non-global max-page-size binding policy and boundary/property/mutation/JSON tests. Cursor/keyset pagination is excluded from this implementation.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

LongOffset is exposed but offsets beyond Int32 are rejected; contradictory totals/pages are accepted; mutable collections are retained by reference; no configurable max page size exists; cursor/keyset pagination has no separately admitted design.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. LongOffset is exposed but offsets beyond Int32 are rejected; contradictory totals/pages are accepted; mutable collections are retained by reference; no configurable max page size exists; cursor/keyset pagination has no separately admitted design.

Required outcome

Make LongOffset the canonical Int64 offset and accept every non-negative offset representable by the current Int32 page-number/page-size inputs using checked arithmetic; obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; keep page size Int32-bounded; snapshot items; enforce sparse/out-of-range invariants; add a configurable non-global max-page-size binding policy and boundary/property/mutation/JSON tests. Cursor/keyset pagination remains out of scope and requires a separate adopter-gated ADR.

In scope

Data.Pagination. Make LongOffset the canonical Int64 offset and accept every non-negative offset representable by the current Int32 page-number/page-size inputs using checked arithmetic; obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; keep page size Int32-bounded; snapshot items; enforce sparse/out-of-range invariants; add a configurable non-global max-page-size binding policy and boundary/property/mutation/JSON tests. Cursor/keyset pagination is excluded from this implementation.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-008, ATYA-042.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Make LongOffset the canonical Int64 offset, accept every offset representable by the Int32 inputs with checked arithmetic, obsolete Int32 Offset in the final 1.x line, and remove Offset in 2.0
3. sparse/out-of-range invariants
4. configurable non-global max-page-size binding policy
5. boundary/property/mutation/JSON tests
6. cursor/keyset designed separately with opaque tokens, adopter-gated.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Pagination's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Accepting offsets above Int32.MaxValue through LongOffset is corrective. Obsolete the Int32 Offset property in the final 1.x line and remove it in 2.0; migration guidance requires consumers to use LongOffset. Rejecting negative, overflowed, or internally inconsistent values and snapshotting input collections can change behavior; ship those changes with migration notes.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Property tests..

Documentation

Update Pagination README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Property tests.
```

Acceptance criteria

- LongOffset accepts values above Int32.MaxValue through the maximum representable by the Int32 inputs when all invariants hold; Int32 Offset is obsolete in the final 1.x line and absent in 2.0; negative or checked-overflow offsets fail deterministically; invalid totals/pages are unconstructible; oversized page size is clamped per policy; items are immutable post-construction.

Working rules

Use a focused branch linked to ATYA-065; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

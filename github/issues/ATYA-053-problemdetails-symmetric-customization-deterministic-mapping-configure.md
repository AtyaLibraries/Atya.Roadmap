# ATYA-053 — ProblemDetails: symmetric customization, deterministic mapping, ConfigureAwait fix

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-053 |
| Owning repository | ProblemDetails |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-009; ATYA-014; ATYA-045 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0023 + S-0044) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

CustomizeProblemDetails fires only on the exception path; assignable-mapping precedence depends on registration order; options/lists mutable in singletons; extension names can collide; non-error statuses accepted; the handler misses ConfigureAwait(false).

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. CustomizeProblemDetails fires only on the exception path; assignable-mapping precedence depends on registration order; options/lists mutable in singletons; extension names can collide; non-error statuses accepted; the handler misses ConfigureAwait(false).

## Desired outcome

Unified ProblemDetailsCustomizationContext (nullable Exception/Error) invoked on both paths, old property kept as sugar; most-specific-type mapping with deterministic tie-breaking; startup-frozen validated option snapshots; reserved/deduplicated extension names; 400–599 status policy with a named escape hatch; add the ConfigureAwait. Add the server-side 429/503/504 rows from the ATYA-045 normative ErrorKind mapping table.

## In-scope work

Errors.ProblemDetails. Unified ProblemDetailsCustomizationContext (nullable Exception/Error) invoked on both paths, old property kept as sugar; most-specific-type mapping with deterministic tie-breaking; startup-frozen validated option snapshots; reserved/deduplicated extension names; 400–599 status policy with a named escape hatch; add the ConfigureAwait. Includes the ProblemDetails-owned ATYA-045 mapping migration.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-009
- ATYA-014
- ATYA-045

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-014
- ATYA-043
- ATYA-044

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Unified ProblemDetailsCustomizationContext (nullable Exception/Error
3. invoked on both paths, old property kept as sugar
4. most-specific-type mapping with deterministic tie-breaking
5. startup-frozen validated option snapshots
6. reserved/deduplicated extension names
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside ProblemDetails's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Minor for additive customization; freezing mutable options is behavior-noted.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Order-permutation tests..

## Documentation work

Update ProblemDetails README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Result-path customization test passes; mapping outcome independent of registration order; precedence/collision/invalid-status tests green.
- Unavailable, Timeout, and TooManyRequests map deterministically to 503, 504, and 429 respectively.

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
# Task-specific proof: Order-permutation tests.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-053 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

ProblemDetails: symmetric customization, deterministic mapping, ConfigureAwait fix. Unified ProblemDetailsCustomizationContext (nullable Exception/Error) invoked on both paths, old property kept as sugar; most-specific-type mapping with deterministic tie-breaking; startup-frozen validated option snapshots; reserved/deduplicated extension names; 400–599 status policy with a named escape hatch; add the ConfigureAwait. Add the server-side 429/503/504 rows from the ATYA-045 normative ErrorKind mapping table.

Exact repository/package scope

Owning repository: ProblemDetails. In scope: Errors.ProblemDetails. Unified ProblemDetailsCustomizationContext (nullable Exception/Error) invoked on both paths, old property kept as sugar; most-specific-type mapping with deterministic tie-breaking; startup-frozen validated option snapshots; reserved/deduplicated extension names; 400–599 status policy with a named escape hatch; add the ConfigureAwait. Includes the ProblemDetails-owned ATYA-045 mapping migration.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

CustomizeProblemDetails fires only on the exception path; assignable-mapping precedence depends on registration order; options/lists mutable in singletons; extension names can collide; non-error statuses accepted; the handler misses ConfigureAwait(false).

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. CustomizeProblemDetails fires only on the exception path; assignable-mapping precedence depends on registration order; options/lists mutable in singletons; extension names can collide; non-error statuses accepted; the handler misses ConfigureAwait(false).

Required outcome

Unified ProblemDetailsCustomizationContext (nullable Exception/Error) invoked on both paths, old property kept as sugar; most-specific-type mapping with deterministic tie-breaking; startup-frozen validated option snapshots; reserved/deduplicated extension names; 400–599 status policy with a named escape hatch; add the ConfigureAwait. Add the server-side 429/503/504 rows from the ATYA-045 normative ErrorKind mapping table.

In scope

Errors.ProblemDetails. Unified ProblemDetailsCustomizationContext (nullable Exception/Error) invoked on both paths, old property kept as sugar; most-specific-type mapping with deterministic tie-breaking; startup-frozen validated option snapshots; reserved/deduplicated extension names; 400–599 status policy with a named escape hatch; add the ConfigureAwait. Includes the ProblemDetails-owned ATYA-045 mapping migration.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-009, ATYA-014, ATYA-045.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Unified ProblemDetailsCustomizationContext (nullable Exception/Error
3. invoked on both paths, old property kept as sugar
4. most-specific-type mapping with deterministic tie-breaking
5. startup-frozen validated option snapshots
6. reserved/deduplicated extension names
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside ProblemDetails's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Minor for additive customization; freezing mutable options is behavior-noted.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Order-permutation tests..

Documentation

Update ProblemDetails README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Order-permutation tests.
```

Acceptance criteria

- Result-path customization test passes; mapping outcome independent of registration order; precedence/collision/invalid-status tests green.
- Unavailable, Timeout, and TooManyRequests map deterministically to 503, 504, and 429 respectively.

Working rules

Use a focused branch linked to ATYA-053; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

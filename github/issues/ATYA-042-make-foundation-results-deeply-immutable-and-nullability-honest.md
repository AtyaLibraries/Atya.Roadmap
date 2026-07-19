# ATYA-042 — Make Foundation.Results deeply immutable and nullability-honest

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-042 |
| Owning repository | Results |
| Priority | P1 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | Implementation |
| Initial status | Ready |
| Hard dependencies | None |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0025) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Error.Details reportedly exposes its backing array through IReadOnlyList (castable → mutable, breaking equality/hash); Result<T>.Success(null) semantics ambiguous against a non-nullable Value.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Error.Details reportedly exposes its backing array through IReadOnlyList (castable → mutable, breaking equality/hash); Result<T>.Success(null) semantics ambiguous against a non-nullable Value.

## Desired outcome

Use a non-castable immutable snapshot for Details with hash/equality mutation regression tests. Define typed success as non-null: Result.Success<T>(null) and any successful Map projection returning null throw ArgumentNullException; Result<T>.Value remains non-nullable T. Callers that need absence must model it explicitly in the success type rather than using null. Encode the contract in annotations, factories, combinators, XML docs, and tests.

## In-scope work

Foundation.Results. Use a non-castable immutable snapshot for Details with hash/equality mutation regression tests. Define typed success as non-null: Result.Success<T>(null) and any successful Map projection returning null throw ArgumentNullException; Result<T>.Value remains non-nullable T. Callers that need absence must model it explicitly in the success type rather than using null. Encode the contract in annotations, factories, combinators, XML docs, and tests.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

None.

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-005
- ATYA-006
- ATYA-007

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Non-castable immutable snapshot for Details
3. hash/equality mutation regression tests
4. Enforce the non-null typed-success contract in annotations, factories, and combinators: Success(null) and a null Map projection throw ArgumentNullException, and Value remains non-nullable
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Results's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

The collection-representation change may affect serialization/API baselines; preserve or explicitly version wire behavior on the ATYA-043 train. Rejecting a null typed success is breaking for callers that relied on the ambiguous behavior; ship it in 2.0 with guidance to model absence explicitly in the success type.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Adversarial mutation tests..

## Documentation work

Update Results README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Cast-and-mutate attempts cannot alter equality/hash; Success(null) and a successful Map returning null throw ArgumentNullException; Value is annotated non-nullable; docs show explicit absence modeling instead of null success.

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
# Task-specific proof: Adversarial mutation tests.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-042 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make Foundation.Results deeply immutable and nullability-honest. Use a non-castable immutable snapshot for Details with hash/equality mutation regression tests. Define typed success as non-null: Result.Success<T>(null) and any successful Map projection returning null throw ArgumentNullException; Result<T>.Value remains non-nullable T. Callers that need absence must model it explicitly in the success type rather than using null. Encode the contract in annotations, factories, combinators, XML docs, and tests.

Exact repository/package scope

Owning repository: Results. In scope: Foundation.Results. Use a non-castable immutable snapshot for Details with hash/equality mutation regression tests. Define typed success as non-null: Result.Success<T>(null) and any successful Map projection returning null throw ArgumentNullException; Result<T>.Value remains non-nullable T. Callers that need absence must model it explicitly in the success type rather than using null. Encode the contract in annotations, factories, combinators, XML docs, and tests.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Error.Details reportedly exposes its backing array through IReadOnlyList (castable → mutable, breaking equality/hash); Result<T>.Success(null) semantics ambiguous against a non-nullable Value.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Error.Details reportedly exposes its backing array through IReadOnlyList (castable → mutable, breaking equality/hash); Result<T>.Success(null) semantics ambiguous against a non-nullable Value.

Required outcome

Use a non-castable immutable snapshot for Details with hash/equality mutation regression tests. Define typed success as non-null: Result.Success<T>(null) and any successful Map projection returning null throw ArgumentNullException; Result<T>.Value remains non-nullable T. Callers that need absence must model it explicitly in the success type rather than using null. Encode the contract in annotations, factories, combinators, XML docs, and tests.

In scope

Foundation.Results. Use a non-castable immutable snapshot for Details with hash/equality mutation regression tests. Define typed success as non-null: Result.Success<T>(null) and any successful Map projection returning null throw ArgumentNullException; Result<T>.Value remains non-nullable T. Callers that need absence must model it explicitly in the success type rather than using null. Encode the contract in annotations, factories, combinators, XML docs, and tests.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

No hard roadmap dependency blocks discovery or implementation.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Non-castable immutable snapshot for Details
3. hash/equality mutation regression tests
4. Enforce the non-null typed-success contract in annotations, factories, and combinators: Success(null) and a null Map projection throw ArgumentNullException, and Value remains non-nullable
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Results's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

The collection-representation change may affect serialization/API baselines; preserve or explicitly version wire behavior on the ATYA-043 train. Rejecting a null typed success is breaking for callers that relied on the ambiguous behavior; ship it in 2.0 with guidance to model absence explicitly in the success type.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Adversarial mutation tests..

Documentation

Update Results README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Adversarial mutation tests.
```

Acceptance criteria

- Cast-and-mutate attempts cannot alter equality/hash; Success(null) and a successful Map returning null throw ArgumentNullException; Value is annotated non-nullable; docs show explicit absence modeling instead of null success.

Working rules

Use a focused branch linked to ATYA-042; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 1 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

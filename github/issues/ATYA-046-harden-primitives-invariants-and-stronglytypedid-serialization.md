# ATYA-046 — Harden Primitives invariants and StronglyTypedId serialization

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-046 |
| Owning repository | Primitives |
| Primary contract owner | Primitives |
| Downstream repositories | Serialization |
| Child migration requirement | required-existing |
| Child migration tasks | ATYA-048 |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-008 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (S-0026 (invariant half) + F-0019) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Public init setters let with expressions bypass constructor guards in Error/paging/STID types; collection inputs stay aliased; StronglyTypedId<TValue> is an abstract record class (heap alloc per id) with no STJ converter (ids serialize as {"value":…}), no EF/route-binding recipes.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Public init setters let with expressions bypass constructor guards in Error/paging/STID types; collection inputs stay aliased; StronglyTypedId<TValue> is an abstract record class (heap alloc per id) with no STJ converter (ids serialize as {"value":…}), no EF/route-binding recipes.

## Desired outcome

Make surviving Foundation.Primitives types use get-only state established by validated constructors/factories; obsolete public init-based materialization in the final 1.x line and remove it in 2.0 rather than revalidating mutable init paths. Snapshot collection inputs and prove with-expression/hash stability. Define a readonly record struct StronglyTypedId shape plus EF ValueConverter and TryParse binding recipes. ATYA-048 owns JSON converter implementation.

## In-scope work

Foundation.Primitives surviving types after ATYA-008: get-only construction/materialization through validated constructors/factories, removal of public init paths in 2.0, collection snapshots, equality/hash tests, StronglyTypedId shape guidance, and compile-tested recipes.

## Out-of-scope work

Error/paging contracts and StronglyTypedIdJsonConverterFactory implementation; Results/Pagination own the former and Serialization ATYA-048 owns the latter.

## Ownership and downstream migrations

- Primary contract owner: Primitives
- Final owning repository: Primitives
- Downstream repositories: Serialization
- Child migration requirement: required-existing
- Child migration tasks: ATYA-048
- Rationale: Primitives owns invariant and StronglyTypedId shape contracts; Serialization owns the converter implementation.

## Hard dependencies

- ATYA-008

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-043
- ATYA-044
- ATYA-045

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Replace public init-based materialization with get-only state established by validated constructors/factories; obsolete init paths in the final 1.x line and remove them in 2.0
3. snapshot collections
4. with-expression/aliasing/hash-stability tests
5. Define and compile-test the readonly record struct StronglyTypedId shape owned by Primitives
6. Publish compile-tested EF ValueConverter and TryParse binding recipes plus the shape contract consumed by ATYA-048; do not implement the JSON converter in this task
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Primitives's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Introduce validated get-only construction/factory paths in the final 1.x line, mark public init-based materialization obsolete there, and remove those init paths in 2.0. Publish serializer/ORM migration recipes that call validated factories.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Adversarial construction tests plus compile-tested EF ValueConverter/TryParse recipes; ATYA-048 owns JSON round trips.

## Documentation work

Update Primitives README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Public state is get-only in 2.0; serializers/ORM materializers use validated constructors/factories; no init path can bypass invariants; collection aliasing cannot change hash/equality after construction.
- StronglyTypedId, EF ValueConverter, and TryParse recipes compile.
- ATYA-048 owns and tests the JSON converter against the documented shape contract.

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
# Task-specific proof: Adversarial construction tests and compile-tested EF ValueConverter/TryParse recipes; ATYA-048 owns JSON round trips.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-046 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Harden Primitives invariants and StronglyTypedId serialization. Make surviving Foundation.Primitives types use get-only state established by validated constructors/factories; obsolete public init-based materialization in the final 1.x line and remove it in 2.0 rather than revalidating mutable init paths. Snapshot collection inputs and prove with-expression/hash stability. Define a readonly record struct StronglyTypedId shape plus EF ValueConverter and TryParse binding recipes. ATYA-048 owns JSON converter implementation.

Exact repository/package scope

Owning repository: Primitives. In scope: Foundation.Primitives surviving types after ATYA-008: get-only construction/materialization through validated constructors/factories, removal of public init paths in 2.0, collection snapshots, equality/hash tests, StronglyTypedId shape guidance, and compile-tested recipes.

Ownership and migration split

- Primary contract owner: Primitives
- Final owning repository: Primitives
- Downstream repositories: Serialization
- Child migration requirement: required-existing
- Child migration tasks: ATYA-048
- Rationale: Primitives owns invariant and StronglyTypedId shape contracts; Serialization owns the converter implementation.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Public init setters let with expressions bypass constructor guards in Error/paging/STID types; collection inputs stay aliased; StronglyTypedId<TValue> is an abstract record class (heap alloc per id) with no STJ converter (ids serialize as {"value":…}), no EF/route-binding recipes.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Public init setters let with expressions bypass constructor guards in Error/paging/STID types; collection inputs stay aliased; StronglyTypedId<TValue> is an abstract record class (heap alloc per id) with no STJ converter (ids serialize as {"value":…}), no EF/route-binding recipes.

Required outcome

Make surviving Foundation.Primitives types use get-only state established by validated constructors/factories; obsolete public init-based materialization in the final 1.x line and remove it in 2.0 rather than revalidating mutable init paths. Snapshot collection inputs and prove with-expression/hash stability. Define a readonly record struct StronglyTypedId shape plus EF ValueConverter and TryParse binding recipes. ATYA-048 owns JSON converter implementation.

In scope

Foundation.Primitives surviving types after ATYA-008: get-only construction/materialization through validated constructors/factories, removal of public init paths in 2.0, collection snapshots, equality/hash tests, StronglyTypedId shape guidance, and compile-tested recipes.

Out of scope

Error/paging contracts and StronglyTypedIdJsonConverterFactory implementation; Results/Pagination own the former and Serialization ATYA-048 owns the latter.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-008.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Replace public init-based materialization with get-only state established by validated constructors/factories; obsolete init paths in the final 1.x line and remove them in 2.0
3. snapshot collections
4. with-expression/aliasing/hash-stability tests
5. Define and compile-test the readonly record struct StronglyTypedId shape owned by Primitives
6. Publish compile-tested EF ValueConverter and TryParse binding recipes plus the shape contract consumed by ATYA-048; do not implement the JSON converter in this task
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Primitives's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Introduce validated get-only construction/factory paths in the final 1.x line, mark public init-based materialization obsolete there, and remove those init paths in 2.0. Publish serializer/ORM migration recipes that call validated factories.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Adversarial construction tests plus compile-tested EF ValueConverter/TryParse recipes; ATYA-048 owns JSON round trips.

Documentation

Update Primitives README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Adversarial construction tests and compile-tested EF ValueConverter/TryParse recipes; ATYA-048 owns JSON round trips.
```

Acceptance criteria

- Public state is get-only in 2.0; serializers/ORM materializers use validated constructors/factories; no init path can bypass invariants; collection aliasing cannot change hash/equality after construction.
- StronglyTypedId, EF ValueConverter, and TryParse recipes compile.
- ATYA-048 owns and tests the JSON converter against the documented shape contract.

Working rules

Use a focused branch linked to ATYA-046; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-145 — Install the middleware correlation accessor with PostConfigure so consumer configuration cannot silently disable it

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-145 |
| Owning repository | Middleware |
| Priority | P2 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-022; ATYA-055 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-14) |
| Confidence | High |
| Risk | Medium |
| Effort | S |

## Problem description

`Web/Middleware/src/Middleware/Extensions/ServiceCollectionExtensions.cs` AddAtyaWebMiddleware wires feature-based correlation into ProblemDetails by calling `services.Configure<AtyaProblemDetailsOptions>(options => { var fallback = options.CorrelationIdAccessor; options.CorrelationIdAccessor = ctx => AtyaCorrelationIdAccessor.GetCorrelationId(ctx) ?? fallback(ctx); })`. IConfigureOptions callbacks run in registration order, so any consumer who calls `services.Configure<AtyaProblemDetailsOptions>(o => o.CorrelationIdAccessor = mine)` AFTER AddAtyaWebMiddleware() — the natural position, since AddAtyaWebMiddleware is called early in composition — replaces the wrapper outright and permanently disables the middleware's correlation feature. Nothing warns; the correlationId extension simply reverts to raw header sniffing and the middleware-generated id for header-less requests disappears. Additionally, calling AddAtyaWebMiddleware twice (modular startup, or a ServiceDefaults package plus an explicit call) registers the wrapper twice, nesting the closures.

## Root cause

A composition-time wrapper was installed with Configure, which is order-sensitive, rather than PostConfigure, which always runs last.

## Desired outcome

Feature-based correlation survives any consumer configuration order, and repeated registration is idempotent.

## Affected scope

Primary owner: **Middleware**. Package: `Atya.Web.Middleware`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Web.Middleware. Feature-based correlation survives any consumer configuration order, and repeated registration is idempotent.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-022
- ATYA-055

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-139

## Implementation sequence

1. Move the accessor wiring to `services.PostConfigure<AtyaProblemDetailsOptions>(…)` so it always runs after consumer Configure callbacks.
2. Guard against double registration by keying on a marker service and registering the post-configure only when the marker was newly added.
3. Add tests asserting a consumer Configure registered after AddAtyaWebMiddleware still yields feature-based correlation with the consumer accessor as fallback.
4. Add a test asserting AddAtyaWebMiddleware called twice produces exactly one wrapper.
5. Apply the same idempotency treatment to AddAtyaProblemDetails, AddAtyaHttpClient, AddAtyaWebHealthChecks and AddAtyaMediator.

## Architecture guidance

Library-owned option composition uses PostConfigure; consumer-owned option values use Configure. Registration helpers must be idempotent.

## Compatibility and migration

Non-breaking. Changes only which accessor wins when the consumer configures one after the fact — restoring the documented behaviour.

## Security and privacy considerations

Ensures the bounded correlation policy from ATYA-022 cannot be bypassed by ordinary consumer configuration.

## Testing strategy

Registration-order matrix (before/after/twice) for every Add* helper in the ecosystem.

## Documentation work

Document the composition contract: library wrappers post-configure, consumer values configure, helpers are idempotent.

## Measurable acceptance criteria

- A consumer Configure registered after AddAtyaWebMiddleware still yields feature-based correlation, with the consumer accessor used as fallback.
- Calling AddAtyaWebMiddleware twice produces exactly one wrapper.
- Every ecosystem Add* helper is idempotent under repeated registration, proven by test.
- The composition contract is documented.

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
# Task-specific proof: Registration-order matrix asserting feature-based correlation survives consumer configuration.
dotnet test -c Release --filter FullyQualifiedName~RegistrationOrder
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-145 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Install the middleware correlation accessor with PostConfigure so consumer configuration cannot silently disable it. Feature-based correlation survives any consumer configuration order, and repeated registration is idempotent.

Exact repository/package scope

Owning repository: Middleware. In scope: `Atya.Web.Middleware` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Web/Middleware/src/Middleware/Extensions/ServiceCollectionExtensions.cs` AddAtyaWebMiddleware wires feature-based correlation into ProblemDetails by calling `services.Configure<AtyaProblemDetailsOptions>(options => { var fallback = options.CorrelationIdAccessor; options.CorrelationIdAccessor = ctx => AtyaCorrelationIdAccessor.GetCorrelationId(ctx) ?? fallback(ctx); })`. IConfigureOptions callbacks run in registration order, so any consumer who calls `services.Configure<AtyaProblemDetailsOptions>(o => o.CorrelationIdAccessor = mine)` AFTER AddAtyaWebMiddleware() — the natural position, since AddAtyaWebMiddleware is called early in composition — replaces the wrapper outright and permanently disables the middleware's correlation feature. Nothing warns; the correlationId extension simply reverts to raw header sniffing and the middleware-generated id for header-less requests disappears. Additionally, calling AddAtyaWebMiddleware twice (modular startup, or a ServiceDefaults package plus an explicit call) registers the wrapper twice, nesting the closures.

Root cause: A composition-time wrapper was installed with Configure, which is order-sensitive, rather than PostConfigure, which always runs last.

Required outcome

Feature-based correlation survives any consumer configuration order, and repeated registration is idempotent.

Blockers and dependencies

Blocked until these complete: ATYA-022, ATYA-055.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Move the accessor wiring to `services.PostConfigure<AtyaProblemDetailsOptions>(…)` so it always runs after consumer Configure callbacks.
2. Guard against double registration by keying on a marker service and registering the post-configure only when the marker was newly added.
3. Add tests asserting a consumer Configure registered after AddAtyaWebMiddleware still yields feature-based correlation with the consumer accessor as fallback.
4. Add a test asserting AddAtyaWebMiddleware called twice produces exactly one wrapper.
5. Apply the same idempotency treatment to AddAtyaProblemDetails, AddAtyaHttpClient, AddAtyaWebHealthChecks and AddAtyaMediator.

Architecture constraints

Library-owned option composition uses PostConfigure; consumer-owned option values use Configure. Registration helpers must be idempotent.

Compatibility and migration requirements

Non-breaking. Changes only which accessor wins when the consumer configures one after the fact — restoring the documented behaviour.

Security and privacy requirements

Ensures the bounded correlation policy from ATYA-022 cannot be bypassed by ordinary consumer configuration.

Tests

Registration-order matrix (before/after/twice) for every Add* helper in the ecosystem.

Documentation

Document the composition contract: library wrappers post-configure, consumer values configure, helpers are idempotent.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Registration-order matrix asserting feature-based correlation survives consumer configuration.
dotnet test -c Release --filter FullyQualifiedName~RegistrationOrder
```

Acceptance criteria

- A consumer Configure registered after AddAtyaWebMiddleware still yields feature-based correlation, with the consumer accessor used as fallback.
- Calling AddAtyaWebMiddleware twice produces exactly one wrapper.
- Every ecosystem Add* helper is idempotent under repeated registration, proven by test.
- The composition contract is documented.

Working rules

Use a focused branch linked to ATYA-145; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

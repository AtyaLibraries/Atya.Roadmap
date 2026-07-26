# ATYA-142 — Break the Mediator captive dependency and stop constructing every handler per scope

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-142 |
| Owning repository | Mediator |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-062 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-11); sharpens GPT 5.6 SOL S-0050 |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

`MediatorServiceCollectionExtensions.AddAtyaMediator` registers IMediator as Scoped while MediatorRegistrationBuilder registers every IRequestHandler<> and every IMediatorRequestDispatcher/IMediatorResponseDispatcher as Transient. Mediator's constructor takes `IEnumerable<IMediatorRequestDispatcher>` and `IEnumerable<IMediatorResponseDispatcher>` and enumerates both eagerly to build its FrozenDictionary lookups. Consequences: (1) resolving IMediator once — which happens on any request that touches it — constructs EVERY dispatcher, which constructs EVERY handler in the application, which resolves each handler's entire dependency graph: every DbContext, repository, typed HttpClient and cache client, whether or not the request uses them. (2) Those transient instances are captured for the lifetime of the scoped Mediator, a textbook captive dependency, so transient handlers behave as scoped. In a service with 50 handlers, one lightweight query pays the construction cost of all 50 and holds them until the request ends.

## Root cause

The dispatch lookup is built from resolved service instances rather than from registration metadata, so constructing the lookup forces construction of the whole handler graph.

## Desired outcome

Resolving IMediator constructs no handlers; dispatching one request constructs exactly one handler from the ambient scope; no transient is captured by a longer-lived object.

## Affected scope

Primary owner: **Mediator**. Package: `Atya.Application.Mediator`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Application.Mediator. Resolving IMediator constructs no handlers; dispatching one request constructs exactly one handler from the ambient scope; no transient is captured by a longer-lived object.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-062

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-063
- ATYA-117
- ATYA-051

## Implementation sequence

1. Build the request-type → dispatcher-type map once at registration time as a singleton (FrozenDictionary<Type, Type> of registration metadata populated by the source generator, holding no service instances).
2. Register IMediator as Singleton over that map plus IServiceScopeFactory / IServiceProvider.
3. Have Send resolve the single required dispatcher from the CURRENT scope at dispatch time; keep handlers transient.
4. Add tests asserting: resolving IMediator constructs zero handlers; dispatching one request constructs exactly one handler; a handler taking a scoped dependency resolves the same instance as the ambient scope.
5. Add a DI validation test running BuildServiceProvider with ValidateScopes = true and ValidateOnBuild = true.

## Architecture guidance

Dispatch metadata is compile-time knowledge and belongs in a singleton; handler instances are per-request and belong to the ambient scope. The pipeline-behaviour work in ATYA-063 must be designed on the lazy model, so this lands first.

## Compatibility and migration

Breaking for anyone depending on IMediator being Scoped — rare, as it holds no state. Handler lifetimes and the IMediator surface are unchanged.

## Security and privacy considerations

Removes unnecessary construction of components holding credentials or connections for requests that never use them.

## Testing strategy

Handler-construction counting tests; ambient-scope identity test; ValidateScopes/ValidateOnBuild provider build.

## Documentation work

Document the resolution model and the lifetime contract for handlers and their dependencies.

## Measurable acceptance criteria

- Resolving IMediator constructs zero handler instances, asserted by a construction counter.
- Dispatching one request constructs exactly one handler.
- A handler's scoped dependency is the same instance as the ambient scope's.
- BuildServiceProvider with ValidateScopes = true and ValidateOnBuild = true succeeds.

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
# Task-specific proof: Construction-counter assertions plus a ValidateScopes provider build.
dotnet test -c Release --filter FullyQualifiedName~ResolutionModel
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-142 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Break the Mediator captive dependency and stop constructing every handler per scope. Resolving IMediator constructs no handlers; dispatching one request constructs exactly one handler from the ambient scope; no transient is captured by a longer-lived object.

Exact repository/package scope

Owning repository: Mediator. In scope: `Atya.Application.Mediator` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`MediatorServiceCollectionExtensions.AddAtyaMediator` registers IMediator as Scoped while MediatorRegistrationBuilder registers every IRequestHandler<> and every IMediatorRequestDispatcher/IMediatorResponseDispatcher as Transient. Mediator's constructor takes `IEnumerable<IMediatorRequestDispatcher>` and `IEnumerable<IMediatorResponseDispatcher>` and enumerates both eagerly to build its FrozenDictionary lookups. Consequences: (1) resolving IMediator once — which happens on any request that touches it — constructs EVERY dispatcher, which constructs EVERY handler in the application, which resolves each handler's entire dependency graph: every DbContext, repository, typed HttpClient and cache client, whether or not the request uses them. (2) Those transient instances are captured for the lifetime of the scoped Mediator, a textbook captive dependency, so transient handlers behave as scoped. In a service with 50 handlers, one lightweight query pays the construction cost of all 50 and holds them until the request ends.

Root cause: The dispatch lookup is built from resolved service instances rather than from registration metadata, so constructing the lookup forces construction of the whole handler graph.

Required outcome

Resolving IMediator constructs no handlers; dispatching one request constructs exactly one handler from the ambient scope; no transient is captured by a longer-lived object.

Blockers and dependencies

Blocked until these complete: ATYA-062.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Build the request-type → dispatcher-type map once at registration time as a singleton (FrozenDictionary<Type, Type> of registration metadata populated by the source generator, holding no service instances).
2. Register IMediator as Singleton over that map plus IServiceScopeFactory / IServiceProvider.
3. Have Send resolve the single required dispatcher from the CURRENT scope at dispatch time; keep handlers transient.
4. Add tests asserting: resolving IMediator constructs zero handlers; dispatching one request constructs exactly one handler; a handler taking a scoped dependency resolves the same instance as the ambient scope.
5. Add a DI validation test running BuildServiceProvider with ValidateScopes = true and ValidateOnBuild = true.

Architecture constraints

Dispatch metadata is compile-time knowledge and belongs in a singleton; handler instances are per-request and belong to the ambient scope. The pipeline-behaviour work in ATYA-063 must be designed on the lazy model, so this lands first.

Compatibility and migration requirements

Breaking for anyone depending on IMediator being Scoped — rare, as it holds no state. Handler lifetimes and the IMediator surface are unchanged.

Security and privacy requirements

Removes unnecessary construction of components holding credentials or connections for requests that never use them.

Tests

Handler-construction counting tests; ambient-scope identity test; ValidateScopes/ValidateOnBuild provider build.

Documentation

Document the resolution model and the lifetime contract for handlers and their dependencies.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Construction-counter assertions plus a ValidateScopes provider build.
dotnet test -c Release --filter FullyQualifiedName~ResolutionModel
```

Acceptance criteria

- Resolving IMediator constructs zero handler instances, asserted by a construction counter.
- Dispatching one request constructs exactly one handler.
- A handler's scoped dependency is the same instance as the ambient scope's.
- BuildServiceProvider with ValidateScopes = true and ValidateOnBuild = true succeeds.

Working rules

Use a focused branch linked to ATYA-142; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

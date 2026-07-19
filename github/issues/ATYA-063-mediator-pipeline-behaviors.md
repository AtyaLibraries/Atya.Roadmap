# ATYA-063 — Mediator pipeline behaviors

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-063 |
| Owning repository | Mediator |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-062; ATYA-043 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0024); resequenced after ECO-062 per [Review DIS-006]; GPT's P2 rejected per §6 |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

No IPipelineBehavior seam: Validation, Idempotency, logging/metrics can't compose around handlers — the #1 MediatR migration expectation and the composition story the atya-api template requires.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. No IPipelineBehavior seam: Validation, Idempotency, logging/metrics can't compose around handlers — the #1 MediatR migration expectation and the composition story the atya-api template requires.

## Desired outcome

IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct); composed in the source generator as a static chain per request type (reflection-free/AOT-clean; ordering = DI registration order); ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27); benchmark the chain.

## In-scope work

Application.Mediator. IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct); composed in the source generator as a static chain per request type (reflection-free/AOT-clean; ordering = DI registration order); ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27); benchmark the chain.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-062
- ATYA-043

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct)
3. composed in the source generator as a static chain per request type (reflection-free/AOT-clean
4. ordering = DI registration order)
5. ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27)
6. benchmark the chain.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Mediator's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Additive minor.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Generator snapshot tests + benchmark..

## Documentation work

Update Mediator README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Validation behavior sample short-circuits invalid requests fleet-style; chain benchmark within the allocation rule; ordering deterministic.

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
# Task-specific proof: Generator snapshot tests + benchmark.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-063 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Mediator pipeline behaviors. IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct); composed in the source generator as a static chain per request type (reflection-free/AOT-clean; ordering = DI registration order); ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27); benchmark the chain.

Exact repository/package scope

Owning repository: Mediator. In scope: Application.Mediator. IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct); composed in the source generator as a static chain per request type (reflection-free/AOT-clean; ordering = DI registration order); ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27); benchmark the chain.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

No IPipelineBehavior seam: Validation, Idempotency, logging/metrics can't compose around handlers — the #1 MediatR migration expectation and the composition story the atya-api template requires.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. No IPipelineBehavior seam: Validation, Idempotency, logging/metrics can't compose around handlers — the #1 MediatR migration expectation and the composition story the atya-api template requires.

Required outcome

IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct); composed in the source generator as a static chain per request type (reflection-free/AOT-clean; ordering = DI registration order); ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27); benchmark the chain.

In scope

Application.Mediator. IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct); composed in the source generator as a static chain per request type (reflection-free/AOT-clean; ordering = DI registration order); ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27); benchmark the chain.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-062, ATYA-043.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. IMediatorBehavior<TRequest,TResponse> with ValueTask<Result<TResponse>> Handle(request, next, ct)
3. composed in the source generator as a static chain per request type (reflection-free/AOT-clean
4. ordering = DI registration order)
5. ValidationBehavior + LoggingBehavior as samples/docs, not packages (CC-27)
6. benchmark the chain.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Mediator's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Additive minor.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Generator snapshot tests + benchmark..

Documentation

Update Mediator README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Generator snapshot tests + benchmark.
```

Acceptance criteria

- Validation behavior sample short-circuits invalid requests fleet-style; chain benchmark within the allocation rule; ordering deterministic.

Working rules

Use a focused branch linked to ATYA-063; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

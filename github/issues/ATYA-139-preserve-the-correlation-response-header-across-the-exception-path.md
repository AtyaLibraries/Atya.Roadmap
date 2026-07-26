# ATYA-139 — Preserve the correlation response header across the exception path

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-139 |
| Owning repository | Middleware |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-022; ATYA-055 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-08) |
| Confidence | High |
| Risk | High |
| Effort | S |

## Problem description

`Web/Middleware/src/Middleware/Internal/AtyaCorrelationIdMiddleware.cs` sets `httpContext.Response.Headers[headerName] = correlationId` when the request enters the pipeline. `UseAtyaWebMiddleware` then calls `UseAtyaProblemDetails()`, which is `app.UseExceptionHandler()`. When an exception reaches ExceptionHandlerMiddleware it calls ClearHttpContext(), which calls `HttpResponse.Clear()` — resetting the status code and CLEARING ALL RESPONSE HEADERS — before re-running the handler pipeline that writes the ProblemDetails body. The correlation header is therefore present on every successful response and absent on every error response: exactly inverted from where a support engineer needs it. The correlationId extension still appears in the ProblemDetails body, so the bug is invisible to body-level tests and surfaces only when a client or proxy reads the header.

## Root cause

The header is written once on the inbound path, but the error path rewrites the response after that point. Nothing re-applies it before headers are flushed.

## Desired outcome

The correlation header is present on every response — 2xx, mapped 4xx and unhandled 5xx — and its value matches the correlationId extension in the ProblemDetails body.

## Affected scope

Primary owner: **Middleware**. Package: `Atya.Web.Middleware`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Web.Middleware. The correlation header is present on every response — 2xx, mapped 4xx and unhandled 5xx — and its value matches the correlationId extension in the ProblemDetails body.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-022
- ATYA-055

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-145
- ATYA-085

## Implementation sequence

1. Register the header via `httpContext.Response.OnStarting(…)` inside AtyaCorrelationIdMiddleware.InvokeAsync, reading the id back from AtyaCorrelationIdFeature. OnStarting callbacks survive Response.Clear() because they fire immediately before headers are flushed, and the feature lives on HttpContext.Features, which ClearHttpContext does not reset.
2. Keep the eager write so downstream middleware can still observe the header.
3. Add a TestServer integration test asserting the header is present on a 200, on a mapped 4xx and on an unhandled-exception 500.
4. Assert the header value equals the correlationId extension in the ProblemDetails body.

## Architecture guidance

Correlation is a response-wide invariant, not an inbound-path side effect. Bind it to the response lifecycle, not to middleware ordering.

## Compatibility and migration

Non-breaking. Adds the header where it was previously missing; never changes an existing value.

## Security and privacy considerations

Keep the bounded correlation policy from ATYA-022: the echoed value must remain length- and character-validated before it reaches a response header.

## Testing strategy

TestServer matrix over 2xx, mapped 4xx and unhandled 5xx, asserting header presence and header/body agreement.

## Documentation work

Document the guarantee that the correlation header is present on all responses, including errors.

## Measurable acceptance criteria

- The correlation header is present on a 200 response.
- The correlation header is present on a mapped 4xx ProblemDetails response.
- The correlation header is present on an unhandled-exception 500 ProblemDetails response.
- The header value equals the correlationId extension value in the body on every error response.

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
# Task-specific proof: TestServer assertions across 2xx / mapped 4xx / unhandled 5xx.
dotnet test -c Release --filter FullyQualifiedName~CorrelationHeaderOnErrorPath
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-139 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Preserve the correlation response header across the exception path. The correlation header is present on every response — 2xx, mapped 4xx and unhandled 5xx — and its value matches the correlationId extension in the ProblemDetails body.

Exact repository/package scope

Owning repository: Middleware. In scope: `Atya.Web.Middleware` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Web/Middleware/src/Middleware/Internal/AtyaCorrelationIdMiddleware.cs` sets `httpContext.Response.Headers[headerName] = correlationId` when the request enters the pipeline. `UseAtyaWebMiddleware` then calls `UseAtyaProblemDetails()`, which is `app.UseExceptionHandler()`. When an exception reaches ExceptionHandlerMiddleware it calls ClearHttpContext(), which calls `HttpResponse.Clear()` — resetting the status code and CLEARING ALL RESPONSE HEADERS — before re-running the handler pipeline that writes the ProblemDetails body. The correlation header is therefore present on every successful response and absent on every error response: exactly inverted from where a support engineer needs it. The correlationId extension still appears in the ProblemDetails body, so the bug is invisible to body-level tests and surfaces only when a client or proxy reads the header.

Root cause: The header is written once on the inbound path, but the error path rewrites the response after that point. Nothing re-applies it before headers are flushed.

Required outcome

The correlation header is present on every response — 2xx, mapped 4xx and unhandled 5xx — and its value matches the correlationId extension in the ProblemDetails body.

Blockers and dependencies

Blocked until these complete: ATYA-022, ATYA-055.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Register the header via `httpContext.Response.OnStarting(…)` inside AtyaCorrelationIdMiddleware.InvokeAsync, reading the id back from AtyaCorrelationIdFeature. OnStarting callbacks survive Response.Clear() because they fire immediately before headers are flushed, and the feature lives on HttpContext.Features, which ClearHttpContext does not reset.
2. Keep the eager write so downstream middleware can still observe the header.
3. Add a TestServer integration test asserting the header is present on a 200, on a mapped 4xx and on an unhandled-exception 500.
4. Assert the header value equals the correlationId extension in the ProblemDetails body.

Architecture constraints

Correlation is a response-wide invariant, not an inbound-path side effect. Bind it to the response lifecycle, not to middleware ordering.

Compatibility and migration requirements

Non-breaking. Adds the header where it was previously missing; never changes an existing value.

Security and privacy requirements

Keep the bounded correlation policy from ATYA-022: the echoed value must remain length- and character-validated before it reaches a response header.

Tests

TestServer matrix over 2xx, mapped 4xx and unhandled 5xx, asserting header presence and header/body agreement.

Documentation

Document the guarantee that the correlation header is present on all responses, including errors.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: TestServer assertions across 2xx / mapped 4xx / unhandled 5xx.
dotnet test -c Release --filter FullyQualifiedName~CorrelationHeaderOnErrorPath
```

Acceptance criteria

- The correlation header is present on a 200 response.
- The correlation header is present on a mapped 4xx ProblemDetails response.
- The correlation header is present on an unhandled-exception 500 ProblemDetails response.
- The header value equals the correlationId extension value in the body on every error response.

Working rules

Use a focused branch linked to ATYA-139; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-138 — Make AtyaHttpClient tolerate non-JSON responses instead of throwing

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-138 |
| Owning repository | Client |
| Priority | P1 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-023 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-07) |
| Confidence | High |
| Risk | High |
| Effort | S |

## Problem description

`Http/Client/src/Client/AtyaHttpClient.cs` exists to "return Atya result values instead of throwing for non-success HTTP responses", but it throws for a common class of them. `ReadProblemDetailsAsync` calls `response.Content.ReadFromJsonAsync<ProblemDetails>(…)` and catches only JsonException. `HttpContent.ReadFromJsonAsync` validates the response media type first and raises NotSupportedException — not JsonException — when the content type is not application/json or an application/*+json suffix. Reverse proxies, WAFs, load balancers and CDNs routinely return text/html for 502/503/504, so the failure path this class exists to model is the one that escapes it. The same applies to the success path: `SendJsonAsync<TValue>` calls ReadFromJsonAsync<TValue> with no guard at all, so a 200 with an unexpected content type throws out of a method whose contract is a Result<TValue>.

## Root cause

The exception filter was written against the deserialization failure mode and not against the media-type validation that runs before it.

## Desired outcome

Every HTTP outcome — including non-JSON error pages and unexpected success content types — is returned as a Result, never thrown.

## Affected scope

Primary owner: **Client**. Package: `Atya.Http.Client`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Http.Client. Every HTTP outcome — including non-JSON error pages and unexpected success content types — is returned as a Result, never thrown.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-023

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-132
- ATYA-045

## Implementation sequence

1. Check `response.Content.Headers.ContentType?.MediaType` before attempting deserialization and treat anything non-JSON as "no problem details available", falling back to AtyaHttpClientErrors.HttpFailure.
2. Broaden the catch to `catch (Exception ex) when (ex is JsonException or NotSupportedException)` as defence in depth.
3. On the success path, return a typed failure error (`atya.http.client.unexpected_content_type`, ErrorKind.Unexpected) carrying the observed media type rather than throwing.
4. Add tests for: non-success with text/html, non-success with no Content-Type, non-success with application/problem+json, success with text/plain, and success with a truncated JSON body.

## Architecture guidance

Keep media-type policy beside the tolerant reader so the abstractions package from ATYA-132 carries it, not the server package.

## Compatibility and migration

Non-breaking: converts a thrown exception into a failed Result, which is the documented contract. Callers with defensive try/catch can remove it.

## Security and privacy considerations

Prevents an upstream-controlled content type from turning into an unhandled exception path, and bounds what is parsed from an untrusted body.

## Testing strategy

Media-type matrix over success and failure statuses, including absent and malformed Content-Type headers.

## Documentation work

Document exactly which conditions produce which error codes, including the new unexpected-content-type code.

## Measurable acceptance criteria

- A 502 with `text/html` returns a failed Result, not an exception.
- A 200 with `text/plain` returns a failed Result carrying the observed media type, not an exception.
- A response with no Content-Type header returns a failed Result.
- `application/problem+json` continues to parse into a mapped Error with details preserved.

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
# Task-specific proof: Media-type matrix test asserting no exception escapes any AtyaHttpClient entry point.
dotnet test -c Release --filter FullyQualifiedName~MediaType
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-138 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make AtyaHttpClient tolerate non-JSON responses instead of throwing. Every HTTP outcome — including non-JSON error pages and unexpected success content types — is returned as a Result, never thrown.

Exact repository/package scope

Owning repository: Client. In scope: `Atya.Http.Client` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Http/Client/src/Client/AtyaHttpClient.cs` exists to "return Atya result values instead of throwing for non-success HTTP responses", but it throws for a common class of them. `ReadProblemDetailsAsync` calls `response.Content.ReadFromJsonAsync<ProblemDetails>(…)` and catches only JsonException. `HttpContent.ReadFromJsonAsync` validates the response media type first and raises NotSupportedException — not JsonException — when the content type is not application/json or an application/*+json suffix. Reverse proxies, WAFs, load balancers and CDNs routinely return text/html for 502/503/504, so the failure path this class exists to model is the one that escapes it. The same applies to the success path: `SendJsonAsync<TValue>` calls ReadFromJsonAsync<TValue> with no guard at all, so a 200 with an unexpected content type throws out of a method whose contract is a Result<TValue>.

Root cause: The exception filter was written against the deserialization failure mode and not against the media-type validation that runs before it.

Required outcome

Every HTTP outcome — including non-JSON error pages and unexpected success content types — is returned as a Result, never thrown.

Blockers and dependencies

Blocked until these complete: ATYA-023.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Check `response.Content.Headers.ContentType?.MediaType` before attempting deserialization and treat anything non-JSON as "no problem details available", falling back to AtyaHttpClientErrors.HttpFailure.
2. Broaden the catch to `catch (Exception ex) when (ex is JsonException or NotSupportedException)` as defence in depth.
3. On the success path, return a typed failure error (`atya.http.client.unexpected_content_type`, ErrorKind.Unexpected) carrying the observed media type rather than throwing.
4. Add tests for: non-success with text/html, non-success with no Content-Type, non-success with application/problem+json, success with text/plain, and success with a truncated JSON body.

Architecture constraints

Keep media-type policy beside the tolerant reader so the abstractions package from ATYA-132 carries it, not the server package.

Compatibility and migration requirements

Non-breaking: converts a thrown exception into a failed Result, which is the documented contract. Callers with defensive try/catch can remove it.

Security and privacy requirements

Prevents an upstream-controlled content type from turning into an unhandled exception path, and bounds what is parsed from an untrusted body.

Tests

Media-type matrix over success and failure statuses, including absent and malformed Content-Type headers.

Documentation

Document exactly which conditions produce which error codes, including the new unexpected-content-type code.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Media-type matrix test asserting no exception escapes any AtyaHttpClient entry point.
dotnet test -c Release --filter FullyQualifiedName~MediaType
```

Acceptance criteria

- A 502 with `text/html` returns a failed Result, not an exception.
- A 200 with `text/plain` returns a failed Result carrying the observed media type, not an exception.
- A response with no Content-Type header returns a failed Result.
- `application/problem+json` continues to parse into a mapped Error with details preserved.

Working rules

Use a focused branch linked to ATYA-138; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 2 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

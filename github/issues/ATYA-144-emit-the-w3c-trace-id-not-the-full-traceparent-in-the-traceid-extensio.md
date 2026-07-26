# ATYA-144 — Emit the W3C trace id, not the full traceparent, in the traceId extension

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-144 |
| Owning repository | ProblemDetails |
| Priority | P3 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-053; ATYA-066 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-13) |
| Confidence | High |
| Risk | Low |
| Effort | S |

## Problem description

Both DefaultExceptionToProblemDetailsMapper.AddExtensions and DefaultResultToProblemDetailsMapper.AddExtensions set the traceId problem-details extension to `Activity.Current?.Id ?? httpContext.TraceIdentifier`. Under the W3C ID format — the .NET default since .NET 5 — Activity.Id is the full traceparent value `00-<32-hex trace-id>-<16-hex span-id>-<flags>`, not the trace id. A client, log pipeline or APM tool correlating on the documented traceId field must string-slice the value, and the emitted value additionally differs in shape from httpContext.TraceIdentifier (Kestrel's connection-scoped "0HN…:00000001"), so the same field carries two unrelated formats depending on whether an Activity is present. Neither is what Activity.Current.TraceId returns, which is the value every OpenTelemetry backend indexes on.

## Root cause

Activity.Id was used as a stand-in for the trace id without accounting for the W3C composite format or for the fallback's different shape.

## Desired outcome

The traceId extension always carries a value an APM backend accepts, in one documented format, consistent with the trace id recorded in logs.

## Affected scope

Primary owner: **ProblemDetails**. Package: `Atya.Errors.ProblemDetails`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Errors.ProblemDetails. The traceId extension always carries a value an APM backend accepts, in one documented format, consistent with the trace id recorded in logs.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-053
- ATYA-066

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-143
- ATYA-022

## Implementation sequence

1. Emit `Activity.Current?.TraceId.ToString()` when `Activity.Current?.IdFormat == ActivityIdFormat.W3C`.
2. Fall back to Activity.Current?.Id for hierarchical format, then to httpContext.TraceIdentifier.
3. Consider emitting the span id under a separate spanId extension and the full traceparent under traceparent if the raw value is genuinely wanted.
4. Coordinate the emitted value with Atya.Diagnostics.Tracing TracingTagNames and KnownLogPropertyNames.TraceId so the log field and the response field carry the same value.
5. Add tests for all three states: W3C activity present, hierarchical activity present, no activity.

## Architecture guidance

The HTTP error surface is part of the telemetry contract owned by ATYA-066; the trace identifier must be identical across logs, traces and error responses.

## Compatibility and migration

Wire-visible change to a field consumers may already parse. Release-note it and state the previous and new formats explicitly.

## Security and privacy considerations

Emitting only the trace id rather than the full traceparent avoids exposing sampling flags and span topology to clients.

## Testing strategy

Three-state activity matrix; a cross-package test asserting the log TraceId property and the response traceId extension match.

## Documentation work

Document the emitted format in the ProblemDetails README and in the telemetry semantics documentation.

## Measurable acceptance criteria

- With a W3C activity present, traceId is the 32-hex trace id with no prefix, span id or flags.
- With no activity, traceId falls back to a documented value and the format is stated in the docs.
- The response traceId matches the TraceId property emitted in logs for the same request.
- Release notes state the previous and new formats.

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
# Task-specific proof: Three-state activity matrix asserting the emitted traceId format.
dotnet test -c Release --filter FullyQualifiedName~TraceIdExtension
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-144 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Emit the W3C trace id, not the full traceparent, in the traceId extension. The traceId extension always carries a value an APM backend accepts, in one documented format, consistent with the trace id recorded in logs.

Exact repository/package scope

Owning repository: ProblemDetails. In scope: `Atya.Errors.ProblemDetails` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Both DefaultExceptionToProblemDetailsMapper.AddExtensions and DefaultResultToProblemDetailsMapper.AddExtensions set the traceId problem-details extension to `Activity.Current?.Id ?? httpContext.TraceIdentifier`. Under the W3C ID format — the .NET default since .NET 5 — Activity.Id is the full traceparent value `00-<32-hex trace-id>-<16-hex span-id>-<flags>`, not the trace id. A client, log pipeline or APM tool correlating on the documented traceId field must string-slice the value, and the emitted value additionally differs in shape from httpContext.TraceIdentifier (Kestrel's connection-scoped "0HN…:00000001"), so the same field carries two unrelated formats depending on whether an Activity is present. Neither is what Activity.Current.TraceId returns, which is the value every OpenTelemetry backend indexes on.

Root cause: Activity.Id was used as a stand-in for the trace id without accounting for the W3C composite format or for the fallback's different shape.

Required outcome

The traceId extension always carries a value an APM backend accepts, in one documented format, consistent with the trace id recorded in logs.

Blockers and dependencies

Blocked until these complete: ATYA-053, ATYA-066.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Emit `Activity.Current?.TraceId.ToString()` when `Activity.Current?.IdFormat == ActivityIdFormat.W3C`.
2. Fall back to Activity.Current?.Id for hierarchical format, then to httpContext.TraceIdentifier.
3. Consider emitting the span id under a separate spanId extension and the full traceparent under traceparent if the raw value is genuinely wanted.
4. Coordinate the emitted value with Atya.Diagnostics.Tracing TracingTagNames and KnownLogPropertyNames.TraceId so the log field and the response field carry the same value.
5. Add tests for all three states: W3C activity present, hierarchical activity present, no activity.

Architecture constraints

The HTTP error surface is part of the telemetry contract owned by ATYA-066; the trace identifier must be identical across logs, traces and error responses.

Compatibility and migration requirements

Wire-visible change to a field consumers may already parse. Release-note it and state the previous and new formats explicitly.

Security and privacy requirements

Emitting only the trace id rather than the full traceparent avoids exposing sampling flags and span topology to clients.

Tests

Three-state activity matrix; a cross-package test asserting the log TraceId property and the response traceId extension match.

Documentation

Document the emitted format in the ProblemDetails README and in the telemetry semantics documentation.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Three-state activity matrix asserting the emitted traceId format.
dotnet test -c Release --filter FullyQualifiedName~TraceIdExtension
```

Acceptance criteria

- With a W3C activity present, traceId is the 32-hex trace id with no prefix, span id or flags.
- With no activity, traceId falls back to a documented value and the format is stated in the docs.
- The response traceId matches the TraceId property emitted in logs for the same request.
- Release notes state the previous and new formats.

Working rules

Use a focused branch linked to ATYA-144; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

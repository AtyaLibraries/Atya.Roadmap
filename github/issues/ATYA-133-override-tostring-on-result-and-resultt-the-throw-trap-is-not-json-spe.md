# ATYA-133 — Override ToString on Result and Result<T> — the throw-trap is not JSON-specific

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-133 |
| Owning repository | Results |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-042 |
| Advisory prerequisites | ATYA-044 |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified by execution during the Opus 5 delta review (2026-07-26); reproduction commands and observed output are recorded in the task body. |
| Origin | Opus 5 delta review (O5-02); corrects Fable ATYA-0014 framing |
| Confidence | High |
| Risk | High |
| Effort | S |

## Problem description

`Foundation/Results/src/Results/Result.cs` and `ResultOfT.cs` are `sealed record class` types whose `Error` getter throws on success and whose `Value` getter throws on failure. The C# compiler synthesises `PrintMembers` over all public readable properties, so `ToString()` invokes those getters. Verified by compiling a minimal reproduction on net8.0: `Result.Success().ToString()` threw `InvalidOperationException: A successful result does not have an error.`, and `$"{result}"` threw the same. `Result<T>.ToString()` throws in BOTH states — success reaches `Error`, failure reaches `Value`. Every `logger.LogInformation("{Result}", result)`, interpolated diagnostic string, xUnit assertion failure message and debugger ToString() evaluation is a latent crash, and because the crash occurs inside the logging call it typically replaces a real error with a misleading one. Fable ATYA-0014 identified the System.Text.Json manifestation of the same root cause but framed it as an STJ problem; neither of its proposed remedies (converters, or documenting "Results are not wire types") fixes ToString().

## Root cause

Throwing accessors were combined with a record declaration. Records synthesise a display contract over public readable properties, so the type has a display contract it never opted into and cannot satisfy.

## Desired outcome

`ToString()` on Result and Result<T> is total: it never throws in any state, never emits the success value, and produces a stable, greppable form usable in structured logs and assertion messages.

## Affected scope

Primary owner: **Results**. Package: `Atya.Foundation.Results`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Foundation.Results. `ToString()` on Result and Result<T> is total: it never throws in any state, never emits the success value, and produces a stable, greppable form usable in structured logs and assertion messages.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-042

## Advisory prerequisites

- ATYA-044

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-044
- ATYA-065

## Implementation sequence

1. Add `public sealed override string ToString()` to Result: "Success" / $"Failure({Error.Code})".
2. Add `public sealed override string ToString()` to Result<T>: $"Success({typeof(TValue).Name})" / $"Failure({Error.Code})". Never render the success value — it may carry PII.
3. Add `[DebuggerDisplay]` to both types so debugger inspection does not re-enter the synthesised member.
4. Add regression tests calling ToString(), $"{r}", string.Concat(r) and a real ILogger structured-log call in both states for both types, asserting no throw and asserting the success value never appears.
5. Re-scope ATYA-044 to serialization only and record that documentation alone does not close the trap.

## Architecture guidance

Keep the throwing accessors — they are the correct contract for an unchecked read. Fix the display path, not the access path. `sealed override` prevents a later refactor from silently restoring PrintMembers.

## Compatibility and migration

Non-breaking and additive. Anyone who currently catches the exception around a log call can remove the catch. No public API surface change beyond the ToString override.

## Security and privacy considerations

Deliberately excludes the success value from the rendered form so Results carrying personal or secret data cannot leak into logs through an incidental ToString().

## Testing strategy

Both types, both states, four call paths (explicit ToString, interpolation, concat, ILogger template). Assert absence of the success value in output.

## Documentation work

Document the display contract in the Results README next to the throwing-accessor documentation, and note that Results are still not wire types.

## Measurable acceptance criteria

- `Result.Success().ToString()`, `Result.Failure(e).ToString()`, `Result<T>.Success(v).ToString()` and `Result<T>.Failure(e).ToString()` all return without throwing.
- String interpolation and `string.Concat` over any Result in any state do not throw.
- A structured `ILogger` call with a Result argument does not throw and does not emit the success value.
- Both overrides are `sealed override`, and a test asserts the synthesised PrintMembers is not reachable.

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
# Task-specific proof: Compiled reproduction: ToString() and interpolation on a successful Result both threw InvalidOperationException before the fix.
dotnet test -c Release --filter FullyQualifiedName~ToStringContract
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-133 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Override ToString on Result and Result<T> — the throw-trap is not JSON-specific. `ToString()` on Result and Result<T> is total: it never throws in any state, never emits the success value, and produces a stable, greppable form usable in structured logs and assertion messages.

Exact repository/package scope

Owning repository: Results. In scope: `Atya.Foundation.Results` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Foundation/Results/src/Results/Result.cs` and `ResultOfT.cs` are `sealed record class` types whose `Error` getter throws on success and whose `Value` getter throws on failure. The C# compiler synthesises `PrintMembers` over all public readable properties, so `ToString()` invokes those getters. Verified by compiling a minimal reproduction on net8.0: `Result.Success().ToString()` threw `InvalidOperationException: A successful result does not have an error.`, and `$"{result}"` threw the same. `Result<T>.ToString()` throws in BOTH states — success reaches `Error`, failure reaches `Value`. Every `logger.LogInformation("{Result}", result)`, interpolated diagnostic string, xUnit assertion failure message and debugger ToString() evaluation is a latent crash, and because the crash occurs inside the logging call it typically replaces a real error with a misleading one. Fable ATYA-0014 identified the System.Text.Json manifestation of the same root cause but framed it as an STJ problem; neither of its proposed remedies (converters, or documenting "Results are not wire types") fixes ToString().

Root cause: Throwing accessors were combined with a record declaration. Records synthesise a display contract over public readable properties, so the type has a display contract it never opted into and cannot satisfy.

Required outcome

`ToString()` on Result and Result<T> is total: it never throws in any state, never emits the success value, and produces a stable, greppable form usable in structured logs and assertion messages.

Blockers and dependencies

Blocked until these complete: ATYA-042.

Advisory prerequisites

Advisory only, nonblocking: ATYA-044.

Detailed implementation steps

1. Add `public sealed override string ToString()` to Result: "Success" / $"Failure({Error.Code})".
2. Add `public sealed override string ToString()` to Result<T>: $"Success({typeof(TValue).Name})" / $"Failure({Error.Code})". Never render the success value — it may carry PII.
3. Add `[DebuggerDisplay]` to both types so debugger inspection does not re-enter the synthesised member.
4. Add regression tests calling ToString(), $"{r}", string.Concat(r) and a real ILogger structured-log call in both states for both types, asserting no throw and asserting the success value never appears.
5. Re-scope ATYA-044 to serialization only and record that documentation alone does not close the trap.

Architecture constraints

Keep the throwing accessors — they are the correct contract for an unchecked read. Fix the display path, not the access path. `sealed override` prevents a later refactor from silently restoring PrintMembers.

Compatibility and migration requirements

Non-breaking and additive. Anyone who currently catches the exception around a log call can remove the catch. No public API surface change beyond the ToString override.

Security and privacy requirements

Deliberately excludes the success value from the rendered form so Results carrying personal or secret data cannot leak into logs through an incidental ToString().

Tests

Both types, both states, four call paths (explicit ToString, interpolation, concat, ILogger template). Assert absence of the success value in output.

Documentation

Document the display contract in the Results README next to the throwing-accessor documentation, and note that Results are still not wire types.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Compiled reproduction: ToString() and interpolation on a successful Result both threw InvalidOperationException before the fix.
dotnet test -c Release --filter FullyQualifiedName~ToStringContract
```

Acceptance criteria

- `Result.Success().ToString()`, `Result.Failure(e).ToString()`, `Result<T>.Success(v).ToString()` and `Result<T>.Failure(e).ToString()` all return without throwing.
- String interpolation and `string.Concat` over any Result in any state do not throw.
- A structured `ILogger` call with a Result argument does not throw and does not emit the success value.
- Both overrides are `sealed override`, and a test asserts the synthesised PrintMembers is not reachable.

Working rules

Use a focused branch linked to ATYA-133; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

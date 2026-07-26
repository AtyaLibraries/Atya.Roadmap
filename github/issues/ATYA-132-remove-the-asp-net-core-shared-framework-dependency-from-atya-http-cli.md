# ATYA-132 — Remove the ASP.NET Core shared-framework dependency from Atya.Http.Client

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-132 |
| Owning repository | Client |
| Priority | P0 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-009; ATYA-032 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified by execution during the Opus 5 delta review (2026-07-26); reproduction commands and observed output are recorded in the task body. |
| Origin | Opus 5 delta review (O5-01) |
| Confidence | High |
| Risk | Critical |
| Effort | L |

## Problem description

`Http/Client/src/Client/Client.csproj` declares `PackageReference Include="Atya.Errors.ProblemDetails"`. `Errors/ProblemDetails/src/ProblemDetails/ProblemDetails.csproj` declares `<FrameworkReference Include="Microsoft.AspNetCore.App" />`. FrameworkReference is transitive, so every consumer of Atya.Http.Client must build against the ASP.NET Core shared framework. `AtyaHttpClient.cs:10` compounds this with a direct `using Microsoft.AspNetCore.Mvc;` for the ProblemDetails DTO, and `AtyaHttpClientOptions.ProblemDetailsOptions` exposes `AtyaProblemDetailsOptions`, a type whose surface is built on `HttpContext`. A worker service, console tool, integration-test harness, Blazor WebAssembly app or MAUI client — the exact consumers a typed HTTP client package exists for — either fails to restore or is forced onto `Microsoft.NET.Sdk.Web`. The package description ("Typed HttpClient helpers that return Atya Result values") states no such constraint.

## Root cause

The client was built inside the server-side error stack and reuses the server package's DTOs rather than a framework-neutral contract. No archetype axis exists in the ecosystem manifest and no CI gate restores a packed artifact into a non-web project, so the leak was never observable.

## Desired outcome

Atya.Http.Client restores and builds cleanly in a `Microsoft.NET.Sdk` project targeting net8.0 with no ASP.NET Core shared-framework reference anywhere in its transitive restore graph, while server-side ProblemDetails behaviour is unchanged.

## Affected scope

Primary owner: **Client**. Package: `Atya.Http.Client`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Http.Client. Atya.Http.Client restores and builds cleanly in a `Microsoft.NET.Sdk` project targeting net8.0 with no ASP.NET Core shared-framework reference anywhere in its transitive restore graph, while server-side ProblemDetails behaviour is unchanged.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-009
- ATYA-032

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-023
- ATYA-053
- ATYA-147

## Implementation sequence

1. Extract a new framework-neutral `Atya.Errors.ProblemDetails.Abstractions` package (no FrameworkReference) containing an Atya-owned problem-details DTO, the validation-error DTO, the ErrorKind ⇄ status-code mapping table, and the tolerant reader.
2. Make Atya.Errors.ProblemDetails (server) depend on the abstractions package and adapt to `Microsoft.AspNetCore.Mvc.ProblemDetails` at its own boundary only.
3. Repoint Atya.Http.Client at the abstractions package; replace `AtyaHttpClientOptions.ProblemDetailsOptions` with a client-owned status-to-ErrorKind map.
4. Add a conformance fixture built with `Microsoft.NET.Sdk` (not .Web) that references Atya.Http.Client from the packed .nupkg via a local feed and fails when the shared framework appears in the restore graph.
5. Add a Blazor WebAssembly and a net8.0 worker restore fixture to cover the client-facing archetypes.

## Architecture guidance

The neutral contract defined by ATYA-009 belongs in the abstractions package; the server package becomes an adapter over it. Dependency direction stays Foundation → Errors.Abstractions → {Errors.ProblemDetails, Http.Client}. Do not invert it by having the client reference the server package for DTO reuse.

## Compatibility and migration

Breaking for Atya.Http.Client consumers that touch `AtyaHttpClientOptions.ProblemDetailsOptions`. Schedule in the same major train as ATYA-009. The new abstractions package needs a PackageId reservation, a publisher allowlist entry (ATYA-016) and a manifest entry (ATYA-001) before first publish.

## Security and privacy considerations

The tolerant reader parses attacker-influenced upstream payloads; keep the payload bounds and media-type handling from ATYA-023 and ATYA-138 in the abstractions package, not in the server package.

## Testing strategy

Restore-graph assertions for each archetype fixture; parity tests proving server-emitted and client-parsed problem details agree after the split; existing ProblemDetails behaviour tests must pass unchanged.

## Documentation work

Document the archetype of every package in its README. State explicitly which Atya packages are safe to reference from non-web projects.

## Measurable acceptance criteria

- A `Microsoft.NET.Sdk` net8.0 console project referencing the packed Atya.Http.Client restores and builds with no `Microsoft.AspNetCore.App` FrameworkReference in the restore graph.
- A Blazor WebAssembly project and a net8.0 worker project referencing the packed package both build.
- `Atya.Http.Client` has no compile-time reference to any `Microsoft.AspNetCore.*` type.
- Server-side ProblemDetails emission is byte-identical before and after the split for the existing test corpus.

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
# Task-specific proof: Packed-artifact restore into non-web archetype fixtures.
dotnet nuget locals all --clear && dotnet restore ./tests/Conformance.NonWeb --locked-mode
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-132 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Remove the ASP.NET Core shared-framework dependency from Atya.Http.Client. Atya.Http.Client restores and builds cleanly in a `Microsoft.NET.Sdk` project targeting net8.0 with no ASP.NET Core shared-framework reference anywhere in its transitive restore graph, while server-side ProblemDetails behaviour is unchanged.

Exact repository/package scope

Owning repository: Client. In scope: `Atya.Http.Client` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Http/Client/src/Client/Client.csproj` declares `PackageReference Include="Atya.Errors.ProblemDetails"`. `Errors/ProblemDetails/src/ProblemDetails/ProblemDetails.csproj` declares `<FrameworkReference Include="Microsoft.AspNetCore.App" />`. FrameworkReference is transitive, so every consumer of Atya.Http.Client must build against the ASP.NET Core shared framework. `AtyaHttpClient.cs:10` compounds this with a direct `using Microsoft.AspNetCore.Mvc;` for the ProblemDetails DTO, and `AtyaHttpClientOptions.ProblemDetailsOptions` exposes `AtyaProblemDetailsOptions`, a type whose surface is built on `HttpContext`. A worker service, console tool, integration-test harness, Blazor WebAssembly app or MAUI client — the exact consumers a typed HTTP client package exists for — either fails to restore or is forced onto `Microsoft.NET.Sdk.Web`. The package description ("Typed HttpClient helpers that return Atya Result values") states no such constraint.

Root cause: The client was built inside the server-side error stack and reuses the server package's DTOs rather than a framework-neutral contract. No archetype axis exists in the ecosystem manifest and no CI gate restores a packed artifact into a non-web project, so the leak was never observable.

Required outcome

Atya.Http.Client restores and builds cleanly in a `Microsoft.NET.Sdk` project targeting net8.0 with no ASP.NET Core shared-framework reference anywhere in its transitive restore graph, while server-side ProblemDetails behaviour is unchanged.

Blockers and dependencies

Blocked until these complete: ATYA-009, ATYA-032.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Extract a new framework-neutral `Atya.Errors.ProblemDetails.Abstractions` package (no FrameworkReference) containing an Atya-owned problem-details DTO, the validation-error DTO, the ErrorKind ⇄ status-code mapping table, and the tolerant reader.
2. Make Atya.Errors.ProblemDetails (server) depend on the abstractions package and adapt to `Microsoft.AspNetCore.Mvc.ProblemDetails` at its own boundary only.
3. Repoint Atya.Http.Client at the abstractions package; replace `AtyaHttpClientOptions.ProblemDetailsOptions` with a client-owned status-to-ErrorKind map.
4. Add a conformance fixture built with `Microsoft.NET.Sdk` (not .Web) that references Atya.Http.Client from the packed .nupkg via a local feed and fails when the shared framework appears in the restore graph.
5. Add a Blazor WebAssembly and a net8.0 worker restore fixture to cover the client-facing archetypes.

Architecture constraints

The neutral contract defined by ATYA-009 belongs in the abstractions package; the server package becomes an adapter over it. Dependency direction stays Foundation → Errors.Abstractions → {Errors.ProblemDetails, Http.Client}. Do not invert it by having the client reference the server package for DTO reuse.

Compatibility and migration requirements

Breaking for Atya.Http.Client consumers that touch `AtyaHttpClientOptions.ProblemDetailsOptions`. Schedule in the same major train as ATYA-009. The new abstractions package needs a PackageId reservation, a publisher allowlist entry (ATYA-016) and a manifest entry (ATYA-001) before first publish.

Security and privacy requirements

The tolerant reader parses attacker-influenced upstream payloads; keep the payload bounds and media-type handling from ATYA-023 and ATYA-138 in the abstractions package, not in the server package.

Tests

Restore-graph assertions for each archetype fixture; parity tests proving server-emitted and client-parsed problem details agree after the split; existing ProblemDetails behaviour tests must pass unchanged.

Documentation

Document the archetype of every package in its README. State explicitly which Atya packages are safe to reference from non-web projects.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Packed-artifact restore into non-web archetype fixtures.
dotnet nuget locals all --clear && dotnet restore ./tests/Conformance.NonWeb --locked-mode
```

Acceptance criteria

- A `Microsoft.NET.Sdk` net8.0 console project referencing the packed Atya.Http.Client restores and builds with no `Microsoft.AspNetCore.App` FrameworkReference in the restore graph.
- A Blazor WebAssembly project and a net8.0 worker project referencing the packed package both build.
- `Atya.Http.Client` has no compile-time reference to any `Microsoft.AspNetCore.*` type.
- Server-side ProblemDetails emission is byte-identical before and after the split for the existing test corpus.

Working rules

Use a focused branch linked to ATYA-132; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

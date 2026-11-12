# ATYA-147 — Add a non-web consumer conformance gate to the fleet audit

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-147 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-001; ATYA-030; ATYA-032; ATYA-132 |
| Advisory prerequisites | ATYA-039 |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-16) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

ATYA-132 exists because nothing in the fleet verifies which packages a non-web project can consume. Atya.Http.Client acquired a transitive `FrameworkReference Microsoft.AspNetCore.App` and shipped to NuGet without any check catching it, because every test and sample project in the ecosystem is either a web project or references the package by ProjectReference — which does not exercise the packed dependency graph. The same class of leak can recur in any package: Errors.Validation and Errors.Exceptions are framework-neutral today, but nothing enforces that, and the roadmap adds Atya.Errors.ProblemDetails.Abstractions, OpenAPI, EF Core and OpenFeature packages whose layering assumptions are equally unenforced.

## Root cause

The ecosystem manifest has no archetype axis, and no CI stage restores a packed artifact into a consumer project representing each archetype.

## Desired outcome

Every package declares an archetype, and CI proves on every build that its packed restore graph contains nothing the archetype forbids.

## Affected scope

Primary owner: **Atya.Roadmap**. Package: `ecosystem-wide`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

ecosystem-wide. Every package declares an archetype, and CI proves on every build that its packed restore graph contains nothing the archetype forbids.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-001
- ATYA-030
- ATYA-032
- ATYA-132

## Advisory prerequisites

- ATYA-039

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-132
- ATYA-076
- ATYA-079

## Implementation sequence

1. Declare an archetype axis in the ecosystem manifest (ATYA-001): each package is framework-neutral, aspnetcore-server, hosting, or analyzer/tooling.
2. Add a conformance fixture per archetype that restores the PACKED .nupkg (not a ProjectReference) from a local feed into a project built with the matching SDK — Microsoft.NET.Sdk and net8.0 for framework-neutral packages.
3. Fail the fixture when the restore graph contains a FrameworkReference or package the archetype forbids.
4. Wire it into the Atya.Build.Sdk conformance fixtures (ATYA-030) so it runs on every package build, and into the CLI fleet audit (ATYA-039) so drift is detected across repos.
5. Include a Blazor WebAssembly and a net8.0 worker fixture for the client-facing archetype specifically.

## Architecture guidance

This is the enforcement half of the layering policy: the manifest states the archetype, the gate proves it. It extends the packed-artifact verification pattern already applied to templates (ATYA-076) and analyzers (ATYA-062) to the dependency graph.

## Compatibility and migration

No runtime impact. May fail existing builds until ATYA-132 lands — sequence it after that fix or introduce it in warn-only mode first.

## Security and privacy considerations

Restricts the transitive surface each package can pull into a consumer, reducing unintended attack surface in non-web hosts.

## Testing strategy

Fixture-level: each archetype has a passing and a deliberately failing fixture proving the gate detects a violation.

## Documentation work

Document the archetype of every package and the rules each archetype enforces.

## Measurable acceptance criteria

- Every package in the manifest declares an archetype.
- A deliberately introduced FrameworkReference in a framework-neutral package fails CI.
- Framework-neutral packages restore into Microsoft.NET.Sdk net8.0, Blazor WebAssembly and worker fixtures.
- The gate runs in the Build.Sdk conformance suite and in the CLI fleet audit.

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
# Task-specific proof: Negative-control fixture proving the gate fails on an introduced FrameworkReference.
pwsh ./scripts/Test-ArchetypeConformance.ps1
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-147 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Add a non-web consumer conformance gate to the fleet audit. Every package declares an archetype, and CI proves on every build that its packed restore graph contains nothing the archetype forbids.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: `ecosystem-wide` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

ATYA-132 exists because nothing in the fleet verifies which packages a non-web project can consume. Atya.Http.Client acquired a transitive `FrameworkReference Microsoft.AspNetCore.App` and shipped to NuGet without any check catching it, because every test and sample project in the ecosystem is either a web project or references the package by ProjectReference — which does not exercise the packed dependency graph. The same class of leak can recur in any package: Errors.Validation and Errors.Exceptions are framework-neutral today, but nothing enforces that, and the roadmap adds Atya.Errors.ProblemDetails.Abstractions, OpenAPI, EF Core and OpenFeature packages whose layering assumptions are equally unenforced.

Root cause: The ecosystem manifest has no archetype axis, and no CI stage restores a packed artifact into a consumer project representing each archetype.

Required outcome

Every package declares an archetype, and CI proves on every build that its packed restore graph contains nothing the archetype forbids.

Blockers and dependencies

Blocked until these complete: ATYA-001, ATYA-030, ATYA-032, ATYA-132.

Advisory prerequisites

Advisory only, nonblocking: ATYA-039.

Detailed implementation steps

1. Declare an archetype axis in the ecosystem manifest (ATYA-001): each package is framework-neutral, aspnetcore-server, hosting, or analyzer/tooling.
2. Add a conformance fixture per archetype that restores the PACKED .nupkg (not a ProjectReference) from a local feed into a project built with the matching SDK — Microsoft.NET.Sdk and net8.0 for framework-neutral packages.
3. Fail the fixture when the restore graph contains a FrameworkReference or package the archetype forbids.
4. Wire it into the Atya.Build.Sdk conformance fixtures (ATYA-030) so it runs on every package build, and into the CLI fleet audit (ATYA-039) so drift is detected across repos.
5. Include a Blazor WebAssembly and a net8.0 worker fixture for the client-facing archetype specifically.

Architecture constraints

This is the enforcement half of the layering policy: the manifest states the archetype, the gate proves it. It extends the packed-artifact verification pattern already applied to templates (ATYA-076) and analyzers (ATYA-062) to the dependency graph.

Compatibility and migration requirements

No runtime impact. May fail existing builds until ATYA-132 lands — sequence it after that fix or introduce it in warn-only mode first.

Security and privacy requirements

Restricts the transitive surface each package can pull into a consumer, reducing unintended attack surface in non-web hosts.

Tests

Fixture-level: each archetype has a passing and a deliberately failing fixture proving the gate detects a violation.

Documentation

Document the archetype of every package and the rules each archetype enforces.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Negative-control fixture proving the gate fails on an introduced FrameworkReference.
pwsh ./scripts/Test-ArchetypeConformance.ps1
```

Acceptance criteria

- Every package in the manifest declares an archetype.
- A deliberately introduced FrameworkReference in a framework-neutral package fails CI.
- Framework-neutral packages restore into Microsoft.NET.Sdk net8.0, Blazor WebAssembly and worker fixtures.
- The gate runs in the Build.Sdk conformance suite and in the CLI fleet audit.

Working rules

Use a focused branch linked to ATYA-147; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

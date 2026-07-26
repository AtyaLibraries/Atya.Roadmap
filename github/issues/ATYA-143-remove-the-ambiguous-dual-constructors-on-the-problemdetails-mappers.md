# ATYA-143 — Remove the ambiguous dual constructors on the ProblemDetails mappers

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-143 |
| Owning repository | ProblemDetails |
| Priority | P3 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-053; ATYA-025 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-12) |
| Confidence | High |
| Risk | Low |
| Effort | S |

## Problem description

DefaultExceptionToProblemDetailsMapper and DefaultResultToProblemDetailsMapper each expose two public single-parameter constructors: one taking AtyaProblemDetailsOptions and one taking IOptions<AtyaProblemDetailsOptions>. Today only IOptions<> is registered, so ServiceProvider picks it. The moment a consumer also registers the concrete options type — `services.AddSingleton(sp => sp.GetRequiredService<IOptions<AtyaProblemDetailsOptions>>().Value)`, a natural thing to do for direct injection into an endpoint — both constructors become satisfiable and neither parameter set is a superset of the other, so Microsoft.Extensions.DependencyInjection throws at resolve time: "Multiple constructors accepting all given argument types have been found… There should only be one applicable constructor." The failure surfaces on first request, not at startup, and points at the Atya type rather than at the consumer's registration.

## Root cause

A test-convenience constructor was made public alongside the DI constructor, creating an ambiguous activation set.

## Desired outcome

Each mapper has exactly one public constructor, and registering the concrete options type alongside IOptions<> resolves cleanly.

## Affected scope

Primary owner: **ProblemDetails**. Package: `Atya.Errors.ProblemDetails`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Errors.ProblemDetails. Each mapper has exactly one public constructor, and registering the concrete options type alongside IOptions<> resolves cleanly.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-053
- ATYA-025

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-144

## Implementation sequence

1. Keep only the IOptions<AtyaProblemDetailsOptions> constructor public.
2. Expose the direct-options path as a public static factory (for example `DefaultExceptionToProblemDetailsMapper.Create(AtyaProblemDetailsOptions options)`) for tests and manual composition.
3. Add a DI test registering both AtyaProblemDetailsOptions and IOptions<AtyaProblemDetailsOptions> and asserting both mappers resolve.
4. Add a one-public-constructor rule for injectable types to the Governance.CodeQuality charter and, where practical, an analyzer.

## Architecture guidance

Injectable types have exactly one public constructor. Alternate construction paths are static factories, not overloads.

## Compatibility and migration

Technically breaking (removes a public constructor). Bundle with the ATYA-053 compatibility train rather than shipping alone.

## Security and privacy considerations

None directly; removes a startup-configuration failure mode that could be mistaken for a library defect during incident response.

## Testing strategy

DI resolution test with both registrations present; construction test through the new static factory.

## Documentation work

Document the supported construction paths in the ProblemDetails README.

## Measurable acceptance criteria

- Each mapper exposes exactly one public constructor.
- Registering both AtyaProblemDetailsOptions and IOptions<AtyaProblemDetailsOptions> resolves both mappers without throwing.
- A static factory covers the direct-options construction path used by tests.
- The one-public-constructor rule is recorded in the CodeQuality charter.

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
# Task-specific proof: DI resolution test with both options registrations present.
dotnet test -c Release --filter FullyQualifiedName~MapperActivation
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-143 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Remove the ambiguous dual constructors on the ProblemDetails mappers. Each mapper has exactly one public constructor, and registering the concrete options type alongside IOptions<> resolves cleanly.

Exact repository/package scope

Owning repository: ProblemDetails. In scope: `Atya.Errors.ProblemDetails` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

DefaultExceptionToProblemDetailsMapper and DefaultResultToProblemDetailsMapper each expose two public single-parameter constructors: one taking AtyaProblemDetailsOptions and one taking IOptions<AtyaProblemDetailsOptions>. Today only IOptions<> is registered, so ServiceProvider picks it. The moment a consumer also registers the concrete options type — `services.AddSingleton(sp => sp.GetRequiredService<IOptions<AtyaProblemDetailsOptions>>().Value)`, a natural thing to do for direct injection into an endpoint — both constructors become satisfiable and neither parameter set is a superset of the other, so Microsoft.Extensions.DependencyInjection throws at resolve time: "Multiple constructors accepting all given argument types have been found… There should only be one applicable constructor." The failure surfaces on first request, not at startup, and points at the Atya type rather than at the consumer's registration.

Root cause: A test-convenience constructor was made public alongside the DI constructor, creating an ambiguous activation set.

Required outcome

Each mapper has exactly one public constructor, and registering the concrete options type alongside IOptions<> resolves cleanly.

Blockers and dependencies

Blocked until these complete: ATYA-053, ATYA-025.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Keep only the IOptions<AtyaProblemDetailsOptions> constructor public.
2. Expose the direct-options path as a public static factory (for example `DefaultExceptionToProblemDetailsMapper.Create(AtyaProblemDetailsOptions options)`) for tests and manual composition.
3. Add a DI test registering both AtyaProblemDetailsOptions and IOptions<AtyaProblemDetailsOptions> and asserting both mappers resolve.
4. Add a one-public-constructor rule for injectable types to the Governance.CodeQuality charter and, where practical, an analyzer.

Architecture constraints

Injectable types have exactly one public constructor. Alternate construction paths are static factories, not overloads.

Compatibility and migration requirements

Technically breaking (removes a public constructor). Bundle with the ATYA-053 compatibility train rather than shipping alone.

Security and privacy requirements

None directly; removes a startup-configuration failure mode that could be mistaken for a library defect during incident response.

Tests

DI resolution test with both registrations present; construction test through the new static factory.

Documentation

Document the supported construction paths in the ProblemDetails README.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: DI resolution test with both options registrations present.
dotnet test -c Release --filter FullyQualifiedName~MapperActivation
```

Acceptance criteria

- Each mapper exposes exactly one public constructor.
- Registering both AtyaProblemDetailsOptions and IOptions<AtyaProblemDetailsOptions> resolves both mappers without throwing.
- A static factory covers the direct-options construction path used by tests.
- The one-public-constructor rule is recorded in the CodeQuality charter.

Working rules

Use a focused branch linked to ATYA-143; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

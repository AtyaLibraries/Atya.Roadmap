# ATYA-148 — Add the cross-package validation-schema contract test and golden fixture

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-148 |
| Owning repository | Testing |
| Priority | P2 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-052; ATYA-051 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-17); supporting evidence for ATYA-052 |
| Confidence | High |
| Risk | Medium |
| Effort | S |

## Problem description

ATYA-052 ("Migrate Validation, ProblemDetails and Client to one validation schema") is scoped from the observation that Http.Client parses only the property-keyed validation object. The sharper evidence is that the incompatible producer ships in the same package: `DefaultExceptionToProblemDetailsMapper.CreateValidationErrors` returns `Dictionary<string, object?>[]` — a JSON ARRAY — while `DefaultResultToProblemDetailsMapper.CreateValidationErrors` returns `Dictionary<string, ValidationProblemError[]>` — a JSON OBJECT MAP — and both write it under the same `errors` extension key. `ProblemDetailsErrorMapper.ReadValidationErrors` in Http.Client returns an empty dictionary for anything that is not a JSON object. So an Atya client calling an Atya server that threw a ValidationException receives a failure with ZERO validation details and no error, while the same client calling the same server returning Result.Failure with validation errors receives them correctly. No task asserts this end to end.

## Root cause

Two producers of the same wire field were implemented independently in one package, and no test observes both through a real client.

## Desired outcome

One executable, shared definition of the validation wire shape that all three packages assert against, and which fails if any producer or consumer diverges.

## Affected scope

Primary owner: **Testing**. Package: `Atya.Governance.Testing`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Governance.Testing. One executable, shared definition of the validation wire shape that all three packages assert against, and which fails if any producer or consumer diverges.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-052
- ATYA-051

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-052
- ATYA-079
- ATYA-080

## Implementation sequence

1. Add a cross-repository contract test: a TestServer host with AddAtyaWebMiddleware, one endpoint throwing ValidationException and one returning a validation-kind Result.Failure, consumed by a real AtyaHttpClient.
2. Assert both paths yield an Error with identical Details shape, count, targets and codes.
3. Freeze the agreed shape as a golden JSON fixture checked into Governance.Testing so all three packages assert against the same file.
4. Expose the fixture publicly so adopters can assert their own conformance.
5. Attach the test to ATYA-052's acceptance criteria rather than filing separate remediation work.

## Architecture guidance

The golden fixture belongs in Governance.Testing so it is consumable by adopters and gives ATYA-051's "fakes implement real contracts" work a concrete artifact to bind to. This task adds no production code.

## Compatibility and migration

Pure test work; no public API change beyond publishing the fixture as content in the Testing package.

## Security and privacy considerations

The fixture must contain no real data; use synthetic field names and values only.

## Testing strategy

The task is the test. Include a negative control proving the test fails when either producer diverges.

## Documentation work

Document the validation wire shape alongside the fixture and reference it from the ProblemDetails and Client READMEs.

## Measurable acceptance criteria

- A ValidationException path and a Result.Failure validation path produce identical Error.Details shape, count, targets and codes through a real AtyaHttpClient.
- A golden JSON fixture defines the shape and is consumed by ProblemDetails, Client and Testing.
- A negative control proves the test fails when a producer diverges.
- The fixture ships as content in the Governance.Testing package.

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
# Task-specific proof: End-to-end TestServer contract test with a negative control.
dotnet test -c Release --filter FullyQualifiedName~ValidationWireContract
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-148 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Add the cross-package validation-schema contract test and golden fixture. One executable, shared definition of the validation wire shape that all three packages assert against, and which fails if any producer or consumer diverges.

Exact repository/package scope

Owning repository: Testing. In scope: `Atya.Governance.Testing` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

ATYA-052 ("Migrate Validation, ProblemDetails and Client to one validation schema") is scoped from the observation that Http.Client parses only the property-keyed validation object. The sharper evidence is that the incompatible producer ships in the same package: `DefaultExceptionToProblemDetailsMapper.CreateValidationErrors` returns `Dictionary<string, object?>[]` — a JSON ARRAY — while `DefaultResultToProblemDetailsMapper.CreateValidationErrors` returns `Dictionary<string, ValidationProblemError[]>` — a JSON OBJECT MAP — and both write it under the same `errors` extension key. `ProblemDetailsErrorMapper.ReadValidationErrors` in Http.Client returns an empty dictionary for anything that is not a JSON object. So an Atya client calling an Atya server that threw a ValidationException receives a failure with ZERO validation details and no error, while the same client calling the same server returning Result.Failure with validation errors receives them correctly. No task asserts this end to end.

Root cause: Two producers of the same wire field were implemented independently in one package, and no test observes both through a real client.

Required outcome

One executable, shared definition of the validation wire shape that all three packages assert against, and which fails if any producer or consumer diverges.

Blockers and dependencies

Blocked until these complete: ATYA-052, ATYA-051.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Add a cross-repository contract test: a TestServer host with AddAtyaWebMiddleware, one endpoint throwing ValidationException and one returning a validation-kind Result.Failure, consumed by a real AtyaHttpClient.
2. Assert both paths yield an Error with identical Details shape, count, targets and codes.
3. Freeze the agreed shape as a golden JSON fixture checked into Governance.Testing so all three packages assert against the same file.
4. Expose the fixture publicly so adopters can assert their own conformance.
5. Attach the test to ATYA-052's acceptance criteria rather than filing separate remediation work.

Architecture constraints

The golden fixture belongs in Governance.Testing so it is consumable by adopters and gives ATYA-051's "fakes implement real contracts" work a concrete artifact to bind to. This task adds no production code.

Compatibility and migration requirements

Pure test work; no public API change beyond publishing the fixture as content in the Testing package.

Security and privacy requirements

The fixture must contain no real data; use synthetic field names and values only.

Tests

The task is the test. Include a negative control proving the test fails when either producer diverges.

Documentation

Document the validation wire shape alongside the fixture and reference it from the ProblemDetails and Client READMEs.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: End-to-end TestServer contract test with a negative control.
dotnet test -c Release --filter FullyQualifiedName~ValidationWireContract
```

Acceptance criteria

- A ValidationException path and a Result.Failure validation path produce identical Error.Details shape, count, targets and codes through a real AtyaHttpClient.
- A golden JSON fixture defines the shape and is consumed by ProblemDetails, Client and Testing.
- A negative control proves the test fails when a producer diverges.
- The fixture ships as content in the Governance.Testing package.

Working rules

Use a focused branch linked to ATYA-148; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

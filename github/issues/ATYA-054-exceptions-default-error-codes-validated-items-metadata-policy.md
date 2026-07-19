# ATYA-054 — Exceptions: default error codes, validated items, metadata policy

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-054 |
| Owning repository | Exceptions |
| Priority | P2 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-052; ATYA-026 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0031 + S-0045) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

NotFound/Conflict/etc. default ErrorCode to null, breaking the org's own atya.{area}.{name}.{error} convention (Fable); ValidationExceptionItem accepts blank/null fields and shallow-copied metadata can reach serializers (GPT); repo baselines lag.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. NotFound/Conflict/etc. default ErrorCode to null, breaking the org's own atya.{area}.{name}.{error} convention (Fable); ValidationExceptionItem accepts blank/null fields and shallow-copied metadata can reach serializers (GPT); repo baselines lag.

## Desired outcome

Per-type default codes (additive; explicit overrides preserved) with the code table documented as API; compatible validated factory for items now, constructor cleanup at next major; metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries; invalid-item/mutation/wire tests.

## In-scope work

Errors.Exceptions. Per-type default codes (additive; explicit overrides preserved) with the code table documented as API; compatible validated factory for items now, constructor cleanup at next major; metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries; invalid-item/mutation/wire tests.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-052
- ATYA-026

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-043
- ATYA-044
- ATYA-045

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Per-type default codes (additive
3. explicit overrides preserved
4. with the code table documented as API
5. compatible validated factory for items now, constructor cleanup at next major
6. metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Exceptions's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Default-from-null-to-value is observable — release-note; ctor cleanup rides 2.0.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Wire tests through ProblemDetails..

## Documentation work

Update Exceptions README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Every taxonomy exception carries a stable default code; blank item fields rejected via factory; metadata never serialized unbounded.

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
# Task-specific proof: Wire tests through ProblemDetails.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-054 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Exceptions: default error codes, validated items, metadata policy. Per-type default codes (additive; explicit overrides preserved) with the code table documented as API; compatible validated factory for items now, constructor cleanup at next major; metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries; invalid-item/mutation/wire tests.

Exact repository/package scope

Owning repository: Exceptions. In scope: Errors.Exceptions. Per-type default codes (additive; explicit overrides preserved) with the code table documented as API; compatible validated factory for items now, constructor cleanup at next major; metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries; invalid-item/mutation/wire tests.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

NotFound/Conflict/etc. default ErrorCode to null, breaking the org's own atya.{area}.{name}.{error} convention (Fable); ValidationExceptionItem accepts blank/null fields and shallow-copied metadata can reach serializers (GPT); repo baselines lag.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. NotFound/Conflict/etc. default ErrorCode to null, breaking the org's own atya.{area}.{name}.{error} convention (Fable); ValidationExceptionItem accepts blank/null fields and shallow-copied metadata can reach serializers (GPT); repo baselines lag.

Required outcome

Per-type default codes (additive; explicit overrides preserved) with the code table documented as API; compatible validated factory for items now, constructor cleanup at next major; metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries; invalid-item/mutation/wire tests.

In scope

Errors.Exceptions. Per-type default codes (additive; explicit overrides preserved) with the code table documented as API; compatible validated factory for items now, constructor cleanup at next major; metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries; invalid-item/mutation/wire tests.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-052, ATYA-026.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Per-type default codes (additive
3. explicit overrides preserved
4. with the code table documented as API
5. compatible validated factory for items now, constructor cleanup at next major
6. metadata defined as bounded diagnostic data with allowlist/size/depth rules at serialization boundaries
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Exceptions's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Default-from-null-to-value is observable — release-note; ctor cleanup rides 2.0.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Wire tests through ProblemDetails..

Documentation

Update Exceptions README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Wire tests through ProblemDetails.
```

Acceptance criteria

- Every taxonomy exception carries a stable default code; blank item fields rejected via factory; metadata never serialized unbounded.

Working rules

Use a focused branch linked to ATYA-054; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

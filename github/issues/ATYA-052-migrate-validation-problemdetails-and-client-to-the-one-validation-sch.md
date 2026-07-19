# ATYA-052 — Migrate Validation, ProblemDetails, and Client to the one validation schema

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-052 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Migration |
| Initial status | Blocked |
| Hard dependencies | ATYA-009; ATYA-014 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0041) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Exception conversion reportedly emits validation.failed + item array; Result conversion emits atya.errors.validation.failed + child errors; Client parses only the latter; attempted values vanish on one path.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Exception conversion reportedly emits validation.failed + item array; Result conversion emits atya.errors.validation.failed + child errors; Client parses only the latter; attempted values vanish on one path.

## Desired outcome

Implement the ECO-009 contract in both server paths; one canonical code with documented aliases; tolerant Client readers for both legacy shapes during a stated window; attempted values sensitive-by-default behind an explicit policy field; golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.

## In-scope work

Errors.Validation, Errors.ProblemDetails, Http.Client. Implement the ECO-009 contract in both server paths; one canonical code with documented aliases; tolerant Client readers for both legacy shapes during a stated window; attempted values sensitive-by-default behind an explicit policy field; golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-009
- ATYA-014

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Implement the ECO-009 contract in both server paths
3. one canonical code with documented aliases
4. tolerant Client readers for both legacy shapes during a stated window
5. attempted values sensitive-by-default behind an explicit policy field
6. golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Likely major-version; migration window with tolerant readers; SemVer/baselines via ECO-029.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Golden fixtures both directions..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Exception route and Result route produce schema-identical validation payloads; Client reads both legacy shapes plus canonical.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Golden fixtures both directions.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-052 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Migrate Validation, ProblemDetails, and Client to the one validation schema. Implement the ECO-009 contract in both server paths; one canonical code with documented aliases; tolerant Client readers for both legacy shapes during a stated window; attempted values sensitive-by-default behind an explicit policy field; golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Errors.Validation, Errors.ProblemDetails, Http.Client. Implement the ECO-009 contract in both server paths; one canonical code with documented aliases; tolerant Client readers for both legacy shapes during a stated window; attempted values sensitive-by-default behind an explicit policy field; golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Exception conversion reportedly emits validation.failed + item array; Result conversion emits atya.errors.validation.failed + child errors; Client parses only the latter; attempted values vanish on one path.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Exception conversion reportedly emits validation.failed + item array; Result conversion emits atya.errors.validation.failed + child errors; Client parses only the latter; attempted values vanish on one path.

Required outcome

Implement the ECO-009 contract in both server paths; one canonical code with documented aliases; tolerant Client readers for both legacy shapes during a stated window; attempted values sensitive-by-default behind an explicit policy field; golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.

In scope

Errors.Validation, Errors.ProblemDetails, Http.Client. Implement the ECO-009 contract in both server paths; one canonical code with documented aliases; tolerant Client readers for both legacy shapes during a stated window; attempted values sensitive-by-default behind an explicit policy field; golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-009, ATYA-014.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Implement the ECO-009 contract in both server paths
3. one canonical code with documented aliases
4. tolerant Client readers for both legacy shapes during a stated window
5. attempted values sensitive-by-default behind an explicit policy field
6. golden JSON + end-to-end TestServer tests proving both routes preserve code/property/message.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Likely major-version; migration window with tolerant readers; SemVer/baselines via ECO-029.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Golden fixtures both directions..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Golden fixtures both directions.
```

Acceptance criteria

- Exception route and Result route produce schema-identical validation payloads; Client reads both legacy shapes plus canonical.

Working rules

Use a focused branch linked to ATYA-052; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

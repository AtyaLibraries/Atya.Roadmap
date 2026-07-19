# ATYA-041 — Add site schema, component, accessibility, and link tests

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-041 |
| Owning repository | AtyaLibraries.github.io |
| Priority | P2 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-040 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0022) |
| Confidence | High |
| Risk | Medium |
| Effort | S |

## Problem description

No unit/component/schema/a11y/link/lint/bundle checks; tab UI lacks proper keyboard semantics.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. No unit/component/schema/a11y/link/lint/bundle checks; tab UI lacks proper keyboard semantics.

## Desired outcome

Catalog-schema tests incl. unpublished/prerelease/empty/failure states; component/search/filter/theme tests; proper tabs or pressed-button semantics; automated a11y + broken-link checks; lint/type-check; bundle budget; preview smoke before production.

## In-scope work

AtyaLibraries.github.io. Catalog-schema tests incl. unpublished/prerelease/empty/failure states; component/search/filter/theme tests; proper tabs or pressed-button semantics; automated a11y + broken-link checks; lint/type-check; bundle budget; preview smoke before production.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-040

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-027

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Catalog-schema tests incl
3. unpublished/prerelease/empty/failure states
4. component/search/filter/theme tests
5. proper tabs or pressed-button semantics
6. automated a11y + broken-link checks
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside AtyaLibraries.github.io's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

None.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-bad-data fixture..

## Documentation work

Update AtyaLibraries.github.io README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- CI fails on schema drift, broken links, or a11y regressions.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
npm ci
npm test
npm run build
# Task-specific proof: Seeded-bad-data fixture.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-041 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Add site schema, component, accessibility, and link tests. Catalog-schema tests incl. unpublished/prerelease/empty/failure states; component/search/filter/theme tests; proper tabs or pressed-button semantics; automated a11y + broken-link checks; lint/type-check; bundle budget; preview smoke before production.

Exact repository/package scope

Owning repository: AtyaLibraries.github.io. In scope: AtyaLibraries.github.io. Catalog-schema tests incl. unpublished/prerelease/empty/failure states; component/search/filter/theme tests; proper tabs or pressed-button semantics; automated a11y + broken-link checks; lint/type-check; bundle budget; preview smoke before production.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

No unit/component/schema/a11y/link/lint/bundle checks; tab UI lacks proper keyboard semantics.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. No unit/component/schema/a11y/link/lint/bundle checks; tab UI lacks proper keyboard semantics.

Required outcome

Catalog-schema tests incl. unpublished/prerelease/empty/failure states; component/search/filter/theme tests; proper tabs or pressed-button semantics; automated a11y + broken-link checks; lint/type-check; bundle budget; preview smoke before production.

In scope

AtyaLibraries.github.io. Catalog-schema tests incl. unpublished/prerelease/empty/failure states; component/search/filter/theme tests; proper tabs or pressed-button semantics; automated a11y + broken-link checks; lint/type-check; bundle budget; preview smoke before production.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-040.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Catalog-schema tests incl
3. unpublished/prerelease/empty/failure states
4. component/search/filter/theme tests
5. proper tabs or pressed-button semantics
6. automated a11y + broken-link checks
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside AtyaLibraries.github.io's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

None.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-bad-data fixture..

Documentation

Update AtyaLibraries.github.io README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
npm ci
npm test
npm run build
# Task-specific proof: Seeded-bad-data fixture.
```

Acceptance criteria

- CI fails on schema drift, broken links, or a11y regressions.

Working rules

Use a focused branch linked to ATYA-041; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

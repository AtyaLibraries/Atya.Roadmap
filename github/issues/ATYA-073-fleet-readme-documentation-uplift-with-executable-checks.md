# ATYA-073 — Fleet README/documentation uplift with executable checks

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-073 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-004; ATYA-029 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0030 + S-0062) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Ten foundation-era repos have maintainer-style READMEs missing every mandated consumer section (no quick start, error codes, or why-these-dependencies — including on the heaviest-dependency package); other repos describe obsolete flows, nonexistent files, manual version edits; CodeQuality/Testing carry string-length "benchmarks".

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Ten foundation-era repos have maintainer-style READMEs missing every mandated consumer section (no quick start, error codes, or why-these-dependencies — including on the heaviest-dependency package); other repos describe obsolete flows, nonexistent files, manual version edits; CodeQuality/Testing carry string-length "benchmarks".

## Desired outcome

Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links; root + packed README); compile/execute documented snippets in CI; remove or replace credibility-only benchmarks; fold into each repo's next release train to avoid doc-only version churn.

## In-scope work

Fleet-wide; priority order per GPT: Primitives, Time, Logging, Metrics, OpenTelemetry, Governance.*, Build.Sdk, publisher, platform, both templates; gold template per Fable: Guards/Pagination standard. Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links; root + packed README); compile/execute documented snippets in CI; remove or replace credibility-only benchmarks; fold into each repo's next release train to avoid doc-only version churn.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-004
- ATYA-029

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links
3. root + packed README)
4. compile/execute documented snippets in CI
5. remove or replace credibility-only benchmarks
6. fold into each repo's next release train to avoid doc-only version churn.
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

None.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: README-section check + snippet compilation..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- All mandated sections present fleet-wide (ECO-039 checks); snippet CI green; no fake benchmarks remain.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: README-section check + snippet compilation.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-073 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Fleet README/documentation uplift with executable checks. Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links; root + packed README); compile/execute documented snippets in CI; remove or replace credibility-only benchmarks; fold into each repo's next release train to avoid doc-only version churn.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Fleet-wide; priority order per GPT: Primitives, Time, Logging, Metrics, OpenTelemetry, Governance.*, Build.Sdk, publisher, platform, both templates; gold template per Fable: Guards/Pagination standard. Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links; root + packed README); compile/execute documented snippets in CI; remove or replace credibility-only benchmarks; fold into each repo's next release train to avoid doc-only version churn.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Ten foundation-era repos have maintainer-style READMEs missing every mandated consumer section (no quick start, error codes, or why-these-dependencies — including on the heaviest-dependency package); other repos describe obsolete flows, nonexistent files, manual version edits; CodeQuality/Testing carry string-length "benchmarks".

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Ten foundation-era repos have maintainer-style READMEs missing every mandated consumer section (no quick start, error codes, or why-these-dependencies — including on the heaviest-dependency package); other repos describe obsolete flows, nonexistent files, manual version edits; CodeQuality/Testing carry string-length "benchmarks".

Required outcome

Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links; root + packed README); compile/execute documented snippets in CI; remove or replace credibility-only benchmarks; fold into each repo's next release train to avoid doc-only version churn.

In scope

Fleet-wide; priority order per GPT: Primitives, Time, Logging, Metrics, OpenTelemetry, Governance.*, Build.Sdk, publisher, platform, both templates; gold template per Fable: Guards/Pagination standard. Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links; root + packed README); compile/execute documented snippets in CI; remove or replace credibility-only benchmarks; fold into each repo's next release train to avoid doc-only version churn.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-004, ATYA-029.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Apply the gold template (tagline, badges, install, quick start compiling against Samples, feature tour, error codes, why-dependencies, links
3. root + packed README)
4. compile/execute documented snippets in CI
5. remove or replace credibility-only benchmarks
6. fold into each repo's next release train to avoid doc-only version churn.
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

None.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: README-section check + snippet compilation..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: README-section check + snippet compilation.
```

Acceptance criteria

- All mandated sections present fleet-wide (ECO-039 checks); snippet CI green; no fake benchmarks remain.

Working rules

Use a focused branch linked to ATYA-073; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 6 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

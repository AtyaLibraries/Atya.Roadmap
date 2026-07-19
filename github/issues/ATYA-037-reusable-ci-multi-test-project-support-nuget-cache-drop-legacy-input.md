# ATYA-037 — Reusable CI: multi-test-project support, NuGet cache, drop legacy input

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-037 |
| Owning repository | github-workflows |
| Priority | P2 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-026; ATYA-027 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0010) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

dotnet-package-ci.yml accepts one test project (test templates need unit+integration); no NuGet caching; vestigial coverage-min input.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. dotnet-package-ci.yml accepts one test project (test templates need unit+integration); no NuGet caching; vestigial coverage-min input.

## Desired outcome

test-project accepts an array/glob with merged coverage (ReportGenerator); actions/cache keyed on packages.lock.json hashes; remove coverage-min.

## In-scope work

github-workflows. test-project accepts an array/glob with merged coverage (ReportGenerator); actions/cache keyed on packages.lock.json hashes; remove coverage-min.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-026
- ATYA-027

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-027

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. test-project accepts an array/glob with merged coverage (ReportGenerator)
3. actions/cache keyed on packages.lock.json hashes
4. remove coverage-min.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside github-workflows's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Input removal is a breaking workflow change — same roll as ECO-026.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fixture repo with two test projects..

## Documentation work

Update github-workflows README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- A two-test-project repo gates on merged coverage; cache hit rate visible; no callers pass coverage-min.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -NoProfile -File ./scripts/Validate.ps1
gh workflow view --all
# Task-specific proof: Fixture repo with two test projects.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-037 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Reusable CI: multi-test-project support, NuGet cache, drop legacy input. test-project accepts an array/glob with merged coverage (ReportGenerator); actions/cache keyed on packages.lock.json hashes; remove coverage-min.

Exact repository/package scope

Owning repository: github-workflows. In scope: github-workflows. test-project accepts an array/glob with merged coverage (ReportGenerator); actions/cache keyed on packages.lock.json hashes; remove coverage-min.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

dotnet-package-ci.yml accepts one test project (test templates need unit+integration); no NuGet caching; vestigial coverage-min input.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. dotnet-package-ci.yml accepts one test project (test templates need unit+integration); no NuGet caching; vestigial coverage-min input.

Required outcome

test-project accepts an array/glob with merged coverage (ReportGenerator); actions/cache keyed on packages.lock.json hashes; remove coverage-min.

In scope

github-workflows. test-project accepts an array/glob with merged coverage (ReportGenerator); actions/cache keyed on packages.lock.json hashes; remove coverage-min.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-026, ATYA-027.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. test-project accepts an array/glob with merged coverage (ReportGenerator)
3. actions/cache keyed on packages.lock.json hashes
4. remove coverage-min.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside github-workflows's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Input removal is a breaking workflow change — same roll as ECO-026.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fixture repo with two test projects..

Documentation

Update github-workflows README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -NoProfile -File ./scripts/Validate.ps1
gh workflow view --all
# Task-specific proof: Fixture repo with two test projects.
```

Acceptance criteria

- A two-test-project repo gates on merged coverage; cache hit rate visible; no callers pass coverage-min.

Working rules

Use a focused branch linked to ATYA-037; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

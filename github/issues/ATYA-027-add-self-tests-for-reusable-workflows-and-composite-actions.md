# ATYA-027 — Add self-tests for reusable workflows and composite actions

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-027 |
| Owning repository | github-workflows |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Documentation |
| Initial status | Blocked |
| Hard dependencies | ATYA-019 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0011) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

github-workflows has no self-CI/actionlint; unused security-sensitive actions decay; the release path uses the weaker build-pack-nuget contract while the stricter validate-nuget sits unused; central failures surface only downstream.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. github-workflows has no self-CI/actionlint; unused security-sensitive actions decay; the release path uses the weaker build-pack-nuget contract while the stricter validate-nuget sits unused; central failures surface only downstream.

## Desired outcome

actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes; delete unsupported actions or move them onto tested paths; add concurrency cancellation; require these checks in branch rules.

## In-scope work

github-workflows. actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes; delete unsupported actions or move them onto tested paths; add concurrency cancellation; require these checks in branch rules.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-019

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-028

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes
3. delete unsupported actions or move them onto tested paths
4. add concurrency cancellation
5. require these checks in branch rules.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside github-workflows's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

None.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Induced-failure fixtures..

## Documentation work

Update github-workflows README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- A deliberately broken workflow change fails the repo's own CI before any consumer sees it.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -NoProfile -File ./scripts/Validate.ps1
gh workflow view --all
# Task-specific proof: Induced-failure fixtures.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-027 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Add self-tests for reusable workflows and composite actions. actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes; delete unsupported actions or move them onto tested paths; add concurrency cancellation; require these checks in branch rules.

Exact repository/package scope

Owning repository: github-workflows. In scope: github-workflows. actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes; delete unsupported actions or move them onto tested paths; add concurrency cancellation; require these checks in branch rules.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

github-workflows has no self-CI/actionlint; unused security-sensitive actions decay; the release path uses the weaker build-pack-nuget contract while the stricter validate-nuget sits unused; central failures surface only downstream.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. github-workflows has no self-CI/actionlint; unused security-sensitive actions decay; the release path uses the weaker build-pack-nuget contract while the stricter validate-nuget sits unused; central failures surface only downstream.

Required outcome

actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes; delete unsupported actions or move them onto tested paths; add concurrency cancellation; require these checks in branch rules.

In scope

github-workflows. actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes; delete unsupported actions or move them onto tested paths; add concurrency cancellation; require these checks in branch rules.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-019.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. actionlint + fixture repos/jobs exercising CI, coverage, build-pack, version determination, package validation, release-source, and failure paths on both OSes
3. delete unsupported actions or move them onto tested paths
4. add concurrency cancellation
5. require these checks in branch rules.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside github-workflows's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

None.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Induced-failure fixtures..

Documentation

Update github-workflows README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -NoProfile -File ./scripts/Validate.ps1
gh workflow view --all
# Task-specific proof: Induced-failure fixtures.
```

Acceptance criteria

- A deliberately broken workflow change fails the repo's own CI before any consumer sees it.

Working rules

Use a focused branch linked to ATYA-027; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-082 — CLI atya new + automated repo onboarding

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-082 |
| Owning repository | Cli |
| Priority | P2 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-013; ATYA-038; ATYA-039; ATYA-024; ATYA-079; ATYA-080 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0041 + S-0066) |
| Confidence | High |
| Risk | Medium |
| Effort | L |

## Problem description

Repo onboarding is a manual runbook with documented failure history (dispatch grants, propagation lag, broken-Actions state, custom properties, branch protection); creation/upgrade workflows are the maintainer-side half of one-click; premature CLI mutation would create a second generation-truth source.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Repo onboarding is a manual runbook with documented failure history (dispatch grants, propagation lag, broken-Actions state, custom properties, branch protection); creation/upgrade workflows are the maintainer-side half of one-click; premature CLI mutation would create a second generation-truth source.

## Desired outcome

Thin commands invoking versioned packed templates (never reimplementing generation); atya new package|template <name>: create repo, set properties, App-based dispatch wiring with verification poll, Actions trigger registration, first-run verification, catalog-amendment PR stub — each step idempotent + resumable; dry-run + explicit confirmation; doctor as the postcondition gate; upgrades later, never silently overwriting user files.

## Affected scope

Primary owner: **Cli**. Audit-affected repositories or coordination scopes: Cli, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Tooling.Cli. Thin commands invoking versioned packed templates (never reimplementing generation); atya new package|template <name>: create repo, set properties, App-based dispatch wiring with verification poll, Actions trigger registration, first-run verification, catalog-amendment PR stub — each step idempotent + resumable; dry-run + explicit confirmation; doctor as the postcondition gate; upgrades later, never silently overwriting user files.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-013
- ATYA-038
- ATYA-039
- ATYA-024
- ATYA-079
- ATYA-080

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-038
- ATYA-073
- ATYA-074

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Thin commands invoking versioned packed templates (never reimplementing generation)
3. atya new package|template <name>: create repo, set properties, App-based dispatch wiring with verification poll, Actions trigger registration, first-run verification, catalog-amendment PR stub — each step idempotent + resumable
4. dry-run + explicit confirmation
5. doctor as the postcondition gate
6. upgrades later, never silently overwriting user files.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Cli's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state. Repository creation behavior and its tests must conform to the topology accepted by ATYA-013.

## Compatibility and migration

N/A (tooling).

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Scratch-org rehearsal..

## Documentation work

Update Cli README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- A fresh package repo goes zero-to-first-green-publish via one command with no manual org-settings steps; interrupted runs resume cleanly.

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
# Task-specific proof: Scratch-org rehearsal.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-082 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

CLI atya new + automated repo onboarding. Thin commands invoking versioned packed templates (never reimplementing generation); atya new package|template <name>: create repo, set properties, App-based dispatch wiring with verification poll, Actions trigger registration, first-run verification, catalog-amendment PR stub — each step idempotent + resumable; dry-run + explicit confirmation; doctor as the postcondition gate; upgrades later, never silently overwriting user files.

Exact repository/package scope

Owning repository: Cli. Primary owner: **Cli**. Audit-affected repositories or coordination scopes: Cli, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Repo onboarding is a manual runbook with documented failure history (dispatch grants, propagation lag, broken-Actions state, custom properties, branch protection); creation/upgrade workflows are the maintainer-side half of one-click; premature CLI mutation would create a second generation-truth source.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Repo onboarding is a manual runbook with documented failure history (dispatch grants, propagation lag, broken-Actions state, custom properties, branch protection); creation/upgrade workflows are the maintainer-side half of one-click; premature CLI mutation would create a second generation-truth source.

Required outcome

Thin commands invoking versioned packed templates (never reimplementing generation); atya new package|template <name>: create repo, set properties, App-based dispatch wiring with verification poll, Actions trigger registration, first-run verification, catalog-amendment PR stub — each step idempotent + resumable; dry-run + explicit confirmation; doctor as the postcondition gate; upgrades later, never silently overwriting user files.

In scope

Atya.Tooling.Cli. Thin commands invoking versioned packed templates (never reimplementing generation); atya new package|template <name>: create repo, set properties, App-based dispatch wiring with verification poll, Actions trigger registration, first-run verification, catalog-amendment PR stub — each step idempotent + resumable; dry-run + explicit confirmation; doctor as the postcondition gate; upgrades later, never silently overwriting user files.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-013, ATYA-038, ATYA-039, ATYA-024, ATYA-079, ATYA-080.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Thin commands invoking versioned packed templates (never reimplementing generation)
3. atya new package|template <name>: create repo, set properties, App-based dispatch wiring with verification poll, Actions trigger registration, first-run verification, catalog-amendment PR stub — each step idempotent + resumable
4. dry-run + explicit confirmation
5. doctor as the postcondition gate
6. upgrades later, never silently overwriting user files.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Cli's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state. Repository creation behavior and its tests must conform to the topology accepted by ATYA-013.

Compatibility and migration requirements

N/A (tooling).

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Scratch-org rehearsal..

Documentation

Update Cli README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

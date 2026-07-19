# ATYA-079 — Deliver atya-api and atya-microservice templates from the golden compositions

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-079 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-013; ATYA-075; ATYA-036; ATYA-037; ATYA-076; ATYA-010; ATYA-011 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0037 + F-0038 + S-0064) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

The flagship one-click deliverables don't exist; their prerequisites are the point of Phases 0–5.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. The flagship one-click deliverables don't exist; their prerequisites are the point of Phases 0–5.

## Desired outcome

Extract dotnet new atya-api (minimal-API + HTTP starter stack + ServiceDefaults + Governance.Testing test project) and atya-microservice (worker stack + outbox relay recipe + idempotent consumer + InMemory dev transport) from the golden apps; contract tests keep generated output equivalent to the reference (GPT's mechanism); follow the UiAutomation build learnings (template.json, sourceName safety, permutation smokes, locked restore); exact SDK pins; SHA-pinned generated workflows; pack-install-generate-test every variant cross-platform; api first, then microservice — no bundled untestable symbol matrix.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Two new template repos/packages. Extract dotnet new atya-api (minimal-API + HTTP starter stack + ServiceDefaults + Governance.Testing test project) and atya-microservice (worker stack + outbox relay recipe + idempotent consumer + InMemory dev transport) from the golden apps; contract tests keep generated output equivalent to the reference (GPT's mechanism); follow the UiAutomation build learnings (template.json, sourceName safety, permutation smokes, locked restore); exact SDK pins; SHA-pinned generated workflows; pack-install-generate-test every variant cross-platform; api first, then microservice — no bundled untestable symbol matrix.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-013
- ATYA-075
- ATYA-036
- ATYA-037
- ATYA-076
- ATYA-010
- ATYA-011

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Extract dotnet new atya-api (minimal-API + HTTP starter stack + ServiceDefaults + Governance.Testing test project
3. and atya-microservice (worker stack + outbox relay recipe + idempotent consumer + InMemory dev transport
4. from the golden apps
5. contract tests keep generated output equivalent to the reference (GPT's mechanism)
6. follow the UiAutomation build learnings (template.json, sourceName safety, permutation smokes, locked restore)
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies. This task creates durable template repositories and must implement the topology accepted by ATYA-013.

## Compatibility and migration

Template upgrade story documented from v1 (generated-code ownership, conflict reporting).

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Generated-project E2E in CI; a real dogfood service generated and run (Fable's bar)..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- dotnet new atya-api yields a service that builds, tests, runs, passes the golden-app contract tests, and publishes through the central chain on first try.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Generated-project E2E in CI; a real dogfood service generated and run (Fable's bar).
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-079 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Deliver atya-api and atya-microservice templates from the golden compositions. Extract dotnet new atya-api (minimal-API + HTTP starter stack + ServiceDefaults + Governance.Testing test project) and atya-microservice (worker stack + outbox relay recipe + idempotent consumer + InMemory dev transport) from the golden apps; contract tests keep generated output equivalent to the reference (GPT's mechanism); follow the UiAutomation build learnings (template.json, sourceName safety, permutation smokes, locked restore); exact SDK pins; SHA-pinned generated workflows; pack-install-generate-test every variant cross-platform; api first, then microservice — no bundled untestable symbol matrix.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

The flagship one-click deliverables don't exist; their prerequisites are the point of Phases 0–5.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. The flagship one-click deliverables don't exist; their prerequisites are the point of Phases 0–5.

Required outcome

Extract dotnet new atya-api (minimal-API + HTTP starter stack + ServiceDefaults + Governance.Testing test project) and atya-microservice (worker stack + outbox relay recipe + idempotent consumer + InMemory dev transport) from the golden apps; contract tests keep generated output equivalent to the reference (GPT's mechanism); follow the UiAutomation build learnings (template.json, sourceName safety, permutation smokes, locked restore); exact SDK pins; SHA-pinned generated workflows; pack-install-generate-test every variant cross-platform; api first, then microservice — no bundled untestable symbol matrix.

In scope

Two new template repos/packages. Extract dotnet new atya-api (minimal-API + HTTP starter stack + ServiceDefaults + Governance.Testing test project) and atya-microservice (worker stack + outbox relay recipe + idempotent consumer + InMemory dev transport) from the golden apps; contract tests keep generated output equivalent to the reference (GPT's mechanism); follow the UiAutomation build learnings (template.json, sourceName safety, permutation smokes, locked restore); exact SDK pins; SHA-pinned generated workflows; pack-install-generate-test every variant cross-platform; api first, then microservice — no bundled untestable symbol matrix.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-013, ATYA-075, ATYA-036, ATYA-037, ATYA-076, ATYA-010, ATYA-011.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Extract dotnet new atya-api (minimal-API + HTTP starter stack + ServiceDefaults + Governance.Testing test project
3. and atya-microservice (worker stack + outbox relay recipe + idempotent consumer + InMemory dev transport
4. from the golden apps
5. contract tests keep generated output equivalent to the reference (GPT's mechanism)
6. follow the UiAutomation build learnings (template.json, sourceName safety, permutation smokes, locked restore)
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies. This task creates durable template repositories and must implement the topology accepted by ATYA-013.

Compatibility and migration requirements

Template upgrade story documented from v1 (generated-code ownership, conflict reporting).

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Generated-project E2E in CI; a real dogfood service generated and run (Fable's bar)..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

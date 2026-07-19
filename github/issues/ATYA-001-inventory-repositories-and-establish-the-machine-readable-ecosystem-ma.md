# ATYA-001 — Inventory repositories and establish the machine-readable ecosystem manifest

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-001 |
| Owning repository | Atya.Roadmap |
| Priority | P0 |
| Phase | 0 — Authoritative inventory and evidence |
| Type | Implementation |
| Initial status | Ready |
| Hard dependencies | None |
| Advisory prerequisites | None |
| Implementation state | Partially satisfied |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0001) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

Package identity, repo archetype, lifecycle state, dependency edges, policy version, pins, and publication status are duplicated across the constitution, CLI, drift workflow, templates, and site, and the copies already disagree.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Package identity, repo archetype, lifecycle state, dependency edges, policy version, pins, and publication status are duplicated across the constitution, CLI, drift workflow, templates, and site, and the copies already disagree.

## Desired outcome

Schema-validated ecosystem.json/YAML in platform: repo slug → PackageId, archetype, lifecycle, allowed dependency edges, default branch, fleet SHA pins, SDK/Build.Sdk versions, policy version. CI validates uniqueness, edge direction, and schema. Generators emit constitution tables, CLI policy, template refs, site data, publisher allowlist.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

platform (home of the manifest); consumers: CLI, drift audit, templates, site, publisher allowlist. Schema-validated ecosystem.json/YAML in platform: repo slug → PackageId, archetype, lifecycle, allowed dependency edges, default branch, fleet SHA pins, SDK/Build.Sdk versions, policy version. CI validates uniqueness, edge direction, and schema. Generators emit constitution tables, CLI policy, template refs, site data, publisher allowlist.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

None. This is a root prerequisite and is Ready when no live audit blocker invalidates the captured evidence.

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-002
- ATYA-003
- ATYA-004

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Schema-validated ecosystem.json/YAML in platform: repo slug → PackageId, archetype, lifecycle, allowed dependency edges, default branch, fleet SHA pins, SDK/Build.Sdk versions, policy version
3. CI validates uniqueness, edge direction, and schema
4. Generators emit constitution tables, CLI policy, template refs, site data, publisher allowlist.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

None (new artifact). Seed from live development/main metadata, not stale local HEADs.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Introduce a duplicate PackageId and a reversed edge in a test branch; both must fail validation..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Manifest exists, schema-validated in platform CI.
- At least three consumers (publisher allowlist, CLI policy, site data) generate from it with no hand-copied duplicates remaining.
- A deliberate manifest error fails CI.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Introduce a duplicate PackageId and a reversed edge in a test branch; both must fail validation.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-001 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Inventory repositories and establish the machine-readable ecosystem manifest. Schema-validated ecosystem.json/YAML in platform: repo slug → PackageId, archetype, lifecycle, allowed dependency edges, default branch, fleet SHA pins, SDK/Build.Sdk versions, policy version. CI validates uniqueness, edge direction, and schema. Generators emit constitution tables, CLI policy, template refs, site data, publisher allowlist.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, AtyaLibraries, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Package identity, repo archetype, lifecycle state, dependency edges, policy version, pins, and publication status are duplicated across the constitution, CLI, drift workflow, templates, and site, and the copies already disagree.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Package identity, repo archetype, lifecycle state, dependency edges, policy version, pins, and publication status are duplicated across the constitution, CLI, drift workflow, templates, and site, and the copies already disagree.

Required outcome

Schema-validated ecosystem.json/YAML in platform: repo slug → PackageId, archetype, lifecycle, allowed dependency edges, default branch, fleet SHA pins, SDK/Build.Sdk versions, policy version. CI validates uniqueness, edge direction, and schema. Generators emit constitution tables, CLI policy, template refs, site data, publisher allowlist.

In scope

platform (home of the manifest); consumers: CLI, drift audit, templates, site, publisher allowlist. Schema-validated ecosystem.json/YAML in platform: repo slug → PackageId, archetype, lifecycle, allowed dependency edges, default branch, fleet SHA pins, SDK/Build.Sdk versions, policy version. CI validates uniqueness, edge direction, and schema. Generators emit constitution tables, CLI policy, template refs, site data, publisher allowlist.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

This task has no hard dependencies, but recheck live evidence before mutation.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Schema-validated ecosystem.json/YAML in platform: repo slug → PackageId, archetype, lifecycle, allowed dependency edges, default branch, fleet SHA pins, SDK/Build.Sdk versions, policy version
3. CI validates uniqueness, edge direction, and schema
4. Generators emit constitution tables, CLI policy, template refs, site data, publisher allowlist.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

None (new artifact). Seed from live development/main metadata, not stale local HEADs.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Introduce a duplicate PackageId and a reversed edge in a test branch; both must fail validation..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

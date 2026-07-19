# ATYA-028 — Test and harden the Renovate preset; verify fleet realization

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-028 |
| Owning repository | renovate-config |
| Primary contract owner | renovate-config |
| Downstream repositories | managed fleet repositories |
| Child migration requirement | required-on-confirmed-gap |
| Child migration tasks | None |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-002; ATYA-019 |
| Advisory prerequisites | None |
| Implementation state | Implemented inconsistently |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0010) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Preset claims digest pinning but the fleet reportedly remains tag-pinned and update PRs appear only in the template repo; digest automerge has no minimum release age; the moving preset has no fixtures or rollback contract.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Preset claims digest pinning but the fleet reportedly remains tag-pinned and update PRs appear only in the template repo; digest automerge has no minimum release age; the moving preset has no fixtures or rollback contract.

## Desired outcome

Preset fixtures; minimum release age + trusted-source requirements for automerge; immutable preset versioning + rollback doc; verify per-repo extension config fleet-wide; prove mutable-ref and internal-dependency updates produce PRs without auto-merged majors. Preserve the FA ceiling (CC-35).

## Affected scope

Primary owner: **renovate-config**. Audit-affected repositories or coordination scopes: renovate-config, AtyaLibraries, Atya.Templates.NuGetPackage, Cli, Client, Guards, Mediator, Middleware. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

renovate-config preset, its fixtures/versioning/rollback documentation, and read-only fleet realization evidence. Consumer repositories are inspected but not mutated in this issue.

## Out-of-scope work

Silently editing nonconforming consumer repositories. Every confirmed gap must create a separate child issue in the owning repository with evidence and a link back to ATYA-028.

## Hard dependencies

- ATYA-002
- ATYA-019

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-027

## Ownership and downstream migrations

- Primary contract owner: renovate-config
- Final owning repository: renovate-config
- Downstream repositories: managed fleet repositories
- Child migration requirement: required-on-confirmed-gap
- Child migration tasks: None
- Rationale: The preset and its fixtures belong to renovate-config. Any verified nonconforming consumer must receive a separate child in that repository; unknown gaps are not pre-invented.

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. minimum release age + trusted-source requirements for automerge
3. immutable preset versioning + rollback doc
4. verify per-repo extension config fleet-wide
5. prove mutable-ref and internal-dependency updates produce PRs without auto-merged majors
6. Preserve the FA ceiling (CC-35).
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside renovate-config's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

None.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-drift canary repo..

## Documentation work

Update renovate-config README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Preset fixtures prove minimum release age, trusted sources, immutable versioning, and no auto-merged major updates.
- A read-only fleet inventory classifies every managed repository as conforming or links a separate owning-repository child for its confirmed gap.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -NoProfile -File ./scripts/Validate.ps1
gh workflow view --all
# Task-specific proof: Seeded-drift canary repo.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-028 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Test and harden the Renovate preset; verify fleet realization. Preset fixtures; minimum release age + trusted-source requirements for automerge; immutable preset versioning + rollback doc; verify per-repo extension config fleet-wide; prove mutable-ref and internal-dependency updates produce PRs without auto-merged majors. Preserve the FA ceiling (CC-35).

Exact repository/package scope

Owning repository: renovate-config. Primary owner: **renovate-config**. Audit-affected repositories or coordination scopes: renovate-config, AtyaLibraries, Atya.Templates.NuGetPackage, Cli, Client, Guards, Mediator, Middleware. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Preset claims digest pinning but the fleet reportedly remains tag-pinned and update PRs appear only in the template repo; digest automerge has no minimum release age; the moving preset has no fixtures or rollback contract.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Preset claims digest pinning but the fleet reportedly remains tag-pinned and update PRs appear only in the template repo; digest automerge has no minimum release age; the moving preset has no fixtures or rollback contract.

Required outcome

Preset fixtures; minimum release age + trusted-source requirements for automerge; immutable preset versioning + rollback doc; verify per-repo extension config fleet-wide; prove mutable-ref and internal-dependency updates produce PRs without auto-merged majors. Preserve the FA ceiling (CC-35).

In scope

renovate-config preset, its fixtures/versioning/rollback documentation, and read-only fleet realization evidence. Consumer repositories are inspected but not mutated in this issue.

Out of scope

Silently editing nonconforming consumer repositories. Every confirmed gap must create a separate child issue in the owning repository with evidence and a link back to ATYA-028.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002, ATYA-019.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. minimum release age + trusted-source requirements for automerge
3. immutable preset versioning + rollback doc
4. verify per-repo extension config fleet-wide
5. prove mutable-ref and internal-dependency updates produce PRs without auto-merged majors
6. Preserve the FA ceiling (CC-35).
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside renovate-config's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

None.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Seeded-drift canary repo..

Documentation

Update renovate-config README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

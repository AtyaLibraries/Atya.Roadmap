# ATYA-013 — Repository-topology ADR (repo-per-package vs grouped repos)

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-013 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-026; ATYA-035 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | New finding (BM-03) |
| Confidence | Medium |
| Risk | Low |
| Effort | M |

## Problem description

36 repos multiply every governance change ×36 for one maintainer; neither review questioned the topology despite the prompt inviting merge/split analysis.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. 36 repos multiply every governance change ×36 for one maintainer; neither review questioned the topology despite the prompt inviting merge/split analysis.

## Desired outcome

ADR-11 weighing release granularity, blast radius, and discoverability against per-repo overhead; decide keep/consolidate-by-family; no action without the ADR.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Org structure; no default change. ADR-11 weighing release granularity, blast radius, and discoverability against per-repo overhead; decide keep/consolidate-by-family; no action without the ADR.

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

- ATYA-026
- ATYA-035

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-11 weighing release granularity, blast radius, and discoverability against per-repo overhead
3. decide keep/consolidate-by-family
4. no action without the ADR.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

If consolidating: preserve PackageIds, redirect repos, update manifest/RepositoryUrl metadata.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A (decision)..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR recorded with measured per-repo roll cost as input.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: N/A (decision).
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-013 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Repository-topology ADR (repo-per-package vs grouped repos). ADR-11 weighing release granularity, blast radius, and discoverability against per-repo overhead; decide keep/consolidate-by-family; no action without the ADR.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

36 repos multiply every governance change ×36 for one maintainer; neither review questioned the topology despite the prompt inviting merge/split analysis.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. 36 repos multiply every governance change ×36 for one maintainer; neither review questioned the topology despite the prompt inviting merge/split analysis.

Required outcome

ADR-11 weighing release granularity, blast radius, and discoverability against per-repo overhead; decide keep/consolidate-by-family; no action without the ADR.

In scope

Org structure; no default change. ADR-11 weighing release granularity, blast radius, and discoverability against per-repo overhead; decide keep/consolidate-by-family; no action without the ADR.

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-026, ATYA-035.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-11 weighing release granularity, blast radius, and discoverability against per-repo overhead
3. decide keep/consolidate-by-family
4. no action without the ADR.
5. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

If consolidating: preserve PackageIds, redirect repos, update manifest/RepositoryUrl metadata.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A (decision)..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

# ATYA-008 — Canonicalize Result/Error/paging; retire the orphan Primitives system

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-008 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-003; ATYA-007; ATYA-042 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0011 + S-0024 + S-0026 (paging half)) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Atya.Foundation.Primitives.{Results,Errors,Paging} is a shipped, dead, second Result/Error/paging system competing with canonical Foundation.Results and Data.Pagination; org documentation presents both as first-class.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Atya.Foundation.Primitives.{Results,Errors,Paging} is a shipped, dead, second Result/Error/paging system competing with canonical Foundation.Results and Data.Pagination; org documentation presents both as first-class.

## Desired outcome

1.x: [Obsolete] on all three namespaces + README migration map covering every legacy factory/property (GPT's migration-map rigor). 2.0: delete the namespaces, drop the now-unneeded Abstractions reference, amend matrix. Apply nuget.org deprecation markers to superseded versions (BM-04, new). Update org profile/site to present one model. Keep StronglyTypedIds/ValueObjects (hardening in ECO-046).

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Primitives (major), catalog/site/profile copy, Testing helpers, dependency matrix. 1.x: [Obsolete] on all three namespaces + README migration map covering every legacy factory/property (GPT's migration-map rigor). 2.0: delete the namespaces, drop the now-unneeded Abstractions reference, amend matrix. Apply nuget.org deprecation markers to superseded versions (BM-04, new). Update org profile/site to present one model. Keep StronglyTypedIds/ValueObjects (hardening in ECO-046).

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

- ATYA-003
- ATYA-007
- ATYA-042

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. x: [Obsolete] on all three namespaces + README migration map covering every legacy factory/property (GPT's migration-map rigor)
3. 0: delete the namespaces, drop the now-unneeded Abstractions reference, amend matrix
4. Apply nuget.org deprecation markers to superseded versions (BM-04, new)
5. Update org profile/site to present one model
6. Keep StronglyTypedIds/ValueObjects (hardening in ECO-046).
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

Major per policy; no third bridge package (GPT's rule).

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fleet + template compile against 2.0; no legacy references remain..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- 1.x obsoletes published; 2.0 removes; migration map covers 100% of legacy public surface; catalog/profile show one Result model; NuGet deprecation markers set.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Fleet + template compile against 2.0; no legacy references remain.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-008 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Canonicalize Result/Error/paging; retire the orphan Primitives system. 1.x: [Obsolete] on all three namespaces + README migration map covering every legacy factory/property (GPT's migration-map rigor). 2.0: delete the namespaces, drop the now-unneeded Abstractions reference, amend matrix. Apply nuget.org deprecation markers to superseded versions (BM-04, new). Update org profile/site to present one model. Keep StronglyTypedIds/ValueObjects (hardening in ECO-046).

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Atya.Foundation.Primitives.{Results,Errors,Paging} is a shipped, dead, second Result/Error/paging system competing with canonical Foundation.Results and Data.Pagination; org documentation presents both as first-class.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Atya.Foundation.Primitives.{Results,Errors,Paging} is a shipped, dead, second Result/Error/paging system competing with canonical Foundation.Results and Data.Pagination; org documentation presents both as first-class.

Required outcome

1.x: [Obsolete] on all three namespaces + README migration map covering every legacy factory/property (GPT's migration-map rigor). 2.0: delete the namespaces, drop the now-unneeded Abstractions reference, amend matrix. Apply nuget.org deprecation markers to superseded versions (BM-04, new). Update org profile/site to present one model. Keep StronglyTypedIds/ValueObjects (hardening in ECO-046).

In scope

Primitives (major), catalog/site/profile copy, Testing helpers, dependency matrix. 1.x: [Obsolete] on all three namespaces + README migration map covering every legacy factory/property (GPT's migration-map rigor). 2.0: delete the namespaces, drop the now-unneeded Abstractions reference, amend matrix. Apply nuget.org deprecation markers to superseded versions (BM-04, new). Update org profile/site to present one model. Keep StronglyTypedIds/ValueObjects (hardening in ECO-046).

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-003, ATYA-007, ATYA-042.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. x: [Obsolete] on all three namespaces + README migration map covering every legacy factory/property (GPT's migration-map rigor)
3. 0: delete the namespaces, drop the now-unneeded Abstractions reference, amend matrix
4. Apply nuget.org deprecation markers to superseded versions (BM-04, new)
5. Update org profile/site to present one model
6. Keep StronglyTypedIds/ValueObjects (hardening in ECO-046).
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

Major per policy; no third bridge package (GPT's rule).

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fleet + template compile against 2.0; no legacy references remain..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

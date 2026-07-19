# ATYA-081 — atya-api-gateway: decision, then (maybe) template

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-081 |
| Owning repository | Atya.Roadmap |
| Priority | P3 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-004; ATYA-079 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0040; S-0064's gateway clause concurs) |
| Confidence | High |
| Risk | Low |
| Effort | M |

## Problem description

Gateway is on the roadmap; as a package it's CUT territory (YARP is Microsoft's); no spec, no demand evidence.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Gateway is on the roadmap; as a package it's CUT territory (YARP is Microsoft's); no spec, no demand evidence.

## Desired outcome

Record an accepted admission decision for an opinionated YARP-based gateway template, including demand evidence, non-goals, trigger, and support boundary. This task creates no template repository; a ratified implementation requires a separate task hard-dependent on ATYA-081 and ATYA-013.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Roadmap ADR/admission evidence only. Evaluate the template proposition and record accept/reject/defer with a measurable trigger.

## Out-of-scope work

Creating or modifying a gateway template/package/repository. Any admitted implementation is a separate owning-repository task with hard dependencies on ATYA-081 and ATYA-013.

## Hard dependencies

- ATYA-004
- ATYA-079

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure alternatives and representative consumer demand.
2. Record the gateway template decision, scope, non-goals, and trigger.
3. If admitted, create a separate implementation task gated by ATYA-013; do not create a repository here.
4. Publish the ADR and evidence.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

N/A until admitted.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- An accepted ADR records accept/reject/defer, evidence, trigger, support boundary, and rejected alternatives.
- No package or repository is created by ATYA-081; any admitted implementation is a separate ATYA-013-gated task.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: N/A.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-081 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

atya-api-gateway: decision, then (maybe) template. Record an accepted admission decision for an opinionated YARP-based gateway template, including demand evidence, non-goals, trigger, and support boundary. This task creates no template repository; a ratified implementation requires a separate task hard-dependent on ATYA-081 and ATYA-013.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Gateway is on the roadmap; as a package it's CUT territory (YARP is Microsoft's); no spec, no demand evidence.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. Gateway is on the roadmap; as a package it's CUT territory (YARP is Microsoft's); no spec, no demand evidence.

Required outcome

Record an accepted admission decision for an opinionated YARP-based gateway template, including demand evidence, non-goals, trigger, and support boundary. This task creates no template repository; a ratified implementation requires a separate task hard-dependent on ATYA-081 and ATYA-013.

In scope

Atya.Roadmap ADR/admission evidence only. Evaluate the template proposition and record accept/reject/defer with a measurable trigger.

Out of scope

Creating or modifying a gateway template/package/repository. Any admitted implementation is a separate owning-repository task with hard dependencies on ATYA-081 and ATYA-013.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-004, ATYA-079.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure alternatives and representative consumer demand.
2. Record the gateway template decision, scope, non-goals, and trigger.
3. If admitted, create a separate implementation task gated by ATYA-013; do not create a repository here.
4. Publish the ADR and evidence.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

N/A until admitted.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: N/A..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

# ATYA-075 — Composition readiness gate + golden reference applications + admission gates

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-075 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-013; ATYA-008; ATYA-009; ATYA-052; ATYA-014; ATYA-015; ATYA-017; ATYA-021; ATYA-022; ATYA-025; ATYA-051; ATYA-063 |
| Advisory prerequisites | ATYA-057; ATYA-058; ATYA-069; ATYA-070; ATYA-065 |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0036 + S-0063), trimmed per [Review DIS-020] |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Templates freeze current-state defects into every generated service; both models gate templates, with different (and jointly excessive) prerequisite lists; new-package admission needs standing rules.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Templates freeze current-state defects into every generated service; both models gate templates, with different (and jointly excessive) prerequisite lists; new-package admission needs standing rules.

## Desired outcome

Build one golden API + one golden worker from *packed* packages only; verify restore/build/test/pack, 5xx secrecy, validation round trips, cancellation, health behavior, telemetry, release provenance end-to-end; write platform/specs/ATYA-API-TEMPLATE.md (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter-stack composition) from the golden apps; define the named-adopter/ADR admission gate + evidence intake (BM-02) for every new PackageId.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

platform (specs), reference apps repo(s). Build one golden API + one golden worker from *packed* packages only; verify restore/build/test/pack, 5xx secrecy, validation round trips, cancellation, health behavior, telemetry, release provenance end-to-end; write platform/specs/ATYA-API-TEMPLATE.md (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter-stack composition) from the golden apps; define the named-adopter/ADR admission gate + evidence intake (BM-02) for every new PackageId.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-013
- ATYA-008
- ATYA-009
- ATYA-052
- ATYA-014
- ATYA-015
- ATYA-017
- ATYA-021
- ATYA-022
- ATYA-025
- ATYA-051
- ATYA-063

## Advisory prerequisites

- ATYA-057
- ATYA-058
- ATYA-069
- ATYA-070
- ATYA-065

These inputs are nonblocking, do not affect Ready/Blocked status, and may be bypassed only with a documented caveat accepted in the issue.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Build one golden API + one golden worker from *packed* packages only
3. verify restore/build/test/pack, 5xx secrecy, validation round trips, cancellation, health behavior, telemetry, release provenance end-to-end
4. write platform/specs/ATYA-API-TEMPLATE.md (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter-stack composition
5. from the golden apps
6. define the named-adopter/ADR admission gate + evidence intake (BM-02
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies. ATYA-013 is a hard topology gate because this task may create durable reference-application repositories. The five advisory inputs improve composition evidence but may be bypassed only through a documented, accepted issue caveat.

## Compatibility and migration

None.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Golden-app CI is the standing validation..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Both golden apps green end-to-end on packed packages; hard-gate checklist machine-verified (ECO-039 where possible); admission-gate process documented with its intake mechanism.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Golden-app CI is the standing validation.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-075 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Composition readiness gate + golden reference applications + admission gates. Build one golden API + one golden worker from *packed* packages only; verify restore/build/test/pack, 5xx secrecy, validation round trips, cancellation, health behavior, telemetry, release provenance end-to-end; write platform/specs/ATYA-API-TEMPLATE.md (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter-stack composition) from the golden apps; define the named-adopter/ADR admission gate + evidence intake (BM-02) for every new PackageId.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Templates freeze current-state defects into every generated service; both models gate templates, with different (and jointly excessive) prerequisite lists; new-package admission needs standing rules.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Templates freeze current-state defects into every generated service; both models gate templates, with different (and jointly excessive) prerequisite lists; new-package admission needs standing rules.

Required outcome

Build one golden API + one golden worker from *packed* packages only; verify restore/build/test/pack, 5xx secrecy, validation round trips, cancellation, health behavior, telemetry, release provenance end-to-end; write platform/specs/ATYA-API-TEMPLATE.md (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter-stack composition) from the golden apps; define the named-adopter/ADR admission gate + evidence intake (BM-02) for every new PackageId.

In scope

platform (specs), reference apps repo(s). Build one golden API + one golden worker from *packed* packages only; verify restore/build/test/pack, 5xx secrecy, validation round trips, cancellation, health behavior, telemetry, release provenance end-to-end; write platform/specs/ATYA-API-TEMPLATE.md (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter-stack composition) from the golden apps; define the named-adopter/ADR admission gate + evidence intake (BM-02) for every new PackageId.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-013, ATYA-008, ATYA-009, ATYA-052, ATYA-014, ATYA-015, ATYA-017, ATYA-021, ATYA-022, ATYA-025, ATYA-051, ATYA-063.

Advisory prerequisites

ATYA-057, ATYA-058, ATYA-069, ATYA-070, ATYA-065. These are nonblocking and may be bypassed only with a documented caveat accepted in the issue.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Build one golden API + one golden worker from *packed* packages only
3. verify restore/build/test/pack, 5xx secrecy, validation round trips, cancellation, health behavior, telemetry, release provenance end-to-end
4. write platform/specs/ATYA-API-TEMPLATE.md (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter-stack composition
5. from the golden apps
6. define the named-adopter/ADR admission gate + evidence intake (BM-02
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies. ATYA-013 is a hard topology gate because this task may create durable reference-application repositories. The five advisory inputs improve composition evidence but may be bypassed only through a documented, accepted issue caveat.

Compatibility and migration requirements

None.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Golden-app CI is the standing validation..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

# ATYA-004 — Reconcile the constitution with the live portfolio and roadmap

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-004 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 0 — Authoritative inventory and evidence |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-001 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0034 + S-0002) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

The constitution contains stale/contradictory sections, and the stated roadmap (OpenAPI, SignalR, OpenFeature, Multitenancy, EF Core, exception/audit middleware) conflicts with its CUT/PARK decisions; exception middleware already shipped.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. The constitution contains stale/contradictory sections, and the stated roadmap (OpenAPI, SignalR, OpenFeature, Multitenancy, EF Core, exception/audit middleware) conflicts with its CUT/PARK decisions; exception middleware already shipped.

## Desired outcome

One amendment session producing: (a) reaffirm/revise each CUT/PARK with restated triggers (Fable's per-item dispositions, incl. classifying OpenAPI/SignalR/OpenFeature as *template content* by default); (b) record the template roster as catalog rows requiring specs; (c) ADR per accepted capability (GPT's machinery); (d) generated catalog/order/dependency tables + a consistency test failing on prose/data conflicts; (e) a sanitized public roadmap.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

platform; roadmap items ECO-083…ECO-088; templates. One amendment session producing: (a) reaffirm/revise each CUT/PARK with restated triggers (Fable's per-item dispositions, incl. classifying OpenAPI/SignalR/OpenFeature as *template content* by default); (b) record the template roster as catalog rows requiring specs; (c) ADR per accepted capability (GPT's machinery); (d) generated catalog/order/dependency tables + a consistency test failing on prose/data conflicts; (e) a sanitized public roadmap.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-001

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. One amendment session producing: (a
3. reaffirm/revise each CUT/PARK with restated triggers (Fable's per-item dispositions, incl
4. classifying OpenAPI/SignalR/OpenFeature as *template content* by default)
5. record the template roster as catalog rows requiring specs
6. ADR per accepted capability (GPT's machinery)
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

None (governance).

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Attempt to add an uncataloged package in a test PR; the consistency test must fail it..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Every roadmap capability has exactly one recorded disposition (accept/defer/merge/reject) with trigger.
- Constitution tables generate from the manifest; consistency test green.
- Sanitized public roadmap published.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Attempt to add an uncataloged package in a test PR; the consistency test must fail it.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-004 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Reconcile the constitution with the live portfolio and roadmap. One amendment session producing: (a) reaffirm/revise each CUT/PARK with restated triggers (Fable's per-item dispositions, incl. classifying OpenAPI/SignalR/OpenFeature as *template content* by default); (b) record the template roster as catalog rows requiring specs; (c) ADR per accepted capability (GPT's machinery); (d) generated catalog/order/dependency tables + a consistency test failing on prose/data conflicts; (e) a sanitized public roadmap.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

The constitution contains stale/contradictory sections, and the stated roadmap (OpenAPI, SignalR, OpenFeature, Multitenancy, EF Core, exception/audit middleware) conflicts with its CUT/PARK decisions; exception middleware already shipped.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. The constitution contains stale/contradictory sections, and the stated roadmap (OpenAPI, SignalR, OpenFeature, Multitenancy, EF Core, exception/audit middleware) conflicts with its CUT/PARK decisions; exception middleware already shipped.

Required outcome

One amendment session producing: (a) reaffirm/revise each CUT/PARK with restated triggers (Fable's per-item dispositions, incl. classifying OpenAPI/SignalR/OpenFeature as *template content* by default); (b) record the template roster as catalog rows requiring specs; (c) ADR per accepted capability (GPT's machinery); (d) generated catalog/order/dependency tables + a consistency test failing on prose/data conflicts; (e) a sanitized public roadmap.

In scope

platform; roadmap items ECO-083…ECO-088; templates. One amendment session producing: (a) reaffirm/revise each CUT/PARK with restated triggers (Fable's per-item dispositions, incl. classifying OpenAPI/SignalR/OpenFeature as *template content* by default); (b) record the template roster as catalog rows requiring specs; (c) ADR per accepted capability (GPT's machinery); (d) generated catalog/order/dependency tables + a consistency test failing on prose/data conflicts; (e) a sanitized public roadmap.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-001.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. One amendment session producing: (a
3. reaffirm/revise each CUT/PARK with restated triggers (Fable's per-item dispositions, incl
4. classifying OpenAPI/SignalR/OpenFeature as *template content* by default)
5. record the template roster as catalog rows requiring specs
6. ADR per accepted capability (GPT's machinery)
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

None (governance).

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Attempt to add an uncataloged package in a test PR; the consistency test must fail it..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

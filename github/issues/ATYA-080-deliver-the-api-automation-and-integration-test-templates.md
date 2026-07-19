# ATYA-080 — Deliver the API-automation and integration-test templates

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-080 |
| Owning repository | Atya.Roadmap |
| Priority | P2 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-013; ATYA-079; ATYA-078; ATYA-010; ATYA-011; ATYA-037 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0039 + S-0065) |
| Confidence | High |
| Risk | Medium |
| Effort | L |

## Problem description

No spec for either test template; test-environment contract (host, data isolation, auth, cleanup, diagnostics, CI) unsettled; blind UiAutomation reuse would import browser lifecycle assumptions.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. No spec for either test template; test-environment contract (host, data isolation, auth, cleanup, diagnostics, CI) unsettled; blind UiAutomation reuse would import browser lifecycle assumptions.

## Desired outcome

Spec first; shared test-environment contract from the golden apps; atya-integration-test = WebApplicationFactory + Governance.Testing harness against an atya-api service; atya-api-automation = black-box HTTP suite (UiAutomation pattern minus browsers); deterministic provisioning, unique data, bounded retries, correlation capture, failure artifacts, parallel safety; pack-install-generate-test cross-platform.

## Affected scope

Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Two new template repos. Spec first; shared test-environment contract from the golden apps; atya-integration-test = WebApplicationFactory + Governance.Testing harness against an atya-api service; atya-api-automation = black-box HTTP suite (UiAutomation pattern minus browsers); deterministic provisioning, unique data, bounded retries, correlation capture, failure artifacts, parallel safety; pack-install-generate-test cross-platform.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-013
- ATYA-079
- ATYA-078
- ATYA-010
- ATYA-011
- ATYA-037

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. shared test-environment contract from the golden apps
3. atya-integration-test = WebApplicationFactory + Governance.Testing harness against an atya-api service
4. atya-api-automation = black-box HTTP suite (UiAutomation pattern minus browsers)
5. deterministic provisioning, unique data, bounded retries, correlation capture, failure artifacts, parallel safety
6. pack-install-generate-test cross-platform.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies. This task creates durable template repositories and must implement the topology accepted by ATYA-013.

## Compatibility and migration

None.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Combined-template E2E..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Generated test projects run green against a generated atya-api; parallel-safety proven.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Combined-template E2E.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-080 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Deliver the API-automation and integration-test templates. Spec first; shared test-environment contract from the golden apps; atya-integration-test = WebApplicationFactory + Governance.Testing harness against an atya-api service; atya-api-automation = black-box HTTP suite (UiAutomation pattern minus browsers); deterministic provisioning, unique data, bounded retries, correlation capture, failure artifacts, parallel safety; pack-install-generate-test cross-platform.

Exact repository/package scope

Owning repository: Atya.Roadmap. Primary owner: **Atya.Roadmap**. Audit-affected repositories or coordination scopes: Atya.Roadmap, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

No spec for either test template; test-environment contract (host, data isolation, auth, cleanup, diagnostics, CI) unsettled; blind UiAutomation reuse would import browser lifecycle assumptions.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. No spec for either test template; test-environment contract (host, data isolation, auth, cleanup, diagnostics, CI) unsettled; blind UiAutomation reuse would import browser lifecycle assumptions.

Required outcome

Spec first; shared test-environment contract from the golden apps; atya-integration-test = WebApplicationFactory + Governance.Testing harness against an atya-api service; atya-api-automation = black-box HTTP suite (UiAutomation pattern minus browsers); deterministic provisioning, unique data, bounded retries, correlation capture, failure artifacts, parallel safety; pack-install-generate-test cross-platform.

In scope

Two new template repos. Spec first; shared test-environment contract from the golden apps; atya-integration-test = WebApplicationFactory + Governance.Testing harness against an atya-api service; atya-api-automation = black-box HTTP suite (UiAutomation pattern minus browsers); deterministic provisioning, unique data, bounded retries, correlation capture, failure artifacts, parallel safety; pack-install-generate-test cross-platform.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-013, ATYA-079, ATYA-078, ATYA-010, ATYA-011, ATYA-037.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. shared test-environment contract from the golden apps
3. atya-integration-test = WebApplicationFactory + Governance.Testing harness against an atya-api service
4. atya-api-automation = black-box HTTP suite (UiAutomation pattern minus browsers)
5. deterministic provisioning, unique data, bounded retries, correlation capture, failure artifacts, parallel safety
6. pack-install-generate-test cross-platform.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies. This task creates durable template repositories and must implement the topology accepted by ATYA-013.

Compatibility and migration requirements

None.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Combined-template E2E..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

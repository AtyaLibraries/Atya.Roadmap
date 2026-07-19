# ATYA-066 — Normalize Observation and OpenTelemetry options exactly once

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-066 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-002 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0043) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Both composition packages reportedly run user configure callbacks eagerly *and* via Options registration; child/provider graphs freeze the eager copy while later options may expose another — non-pure callbacks produce divergent identities; partial registration precedes missing-name validation.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Both composition packages reportedly run user configure callbacks eagerly *and* via Options registration; child/provider graphs freeze the eager copy while later options may expose another — non-pure callbacks produce divergent identities; partial registration precedes missing-name validation.

## Desired outcome

Build one immutable validated snapshot from callback plus bound host configuration and use it for every child registration. The application host supplies raw identity values; Diagnostics.Observation exclusively normalizes, validates, and owns the immutable ObservationIdentity (service name/version plus ActivitySource and Meter names). Diagnostics.OpenTelemetry may only consume and project that identity into ResourceBuilder/providers while owning OpenTelemetry-only resource enrichment (namespace, instance ID, deployment environment, and additional attributes); it must not override service name/version or recompute identity. Remove partial-registration early returns; add callback-count, non-pure-callback, late-configure, and host integration tests. Create no synonymous package (CC-27).

## In-scope work

Diagnostics.Observation, Diagnostics.OpenTelemetry. Build one immutable validated snapshot from callback plus bound host configuration and use it for every child registration. The application host supplies raw identity values; Diagnostics.Observation exclusively normalizes, validates, and owns the immutable ObservationIdentity (service name/version plus ActivitySource and Meter names). Diagnostics.OpenTelemetry may only consume and project that identity into ResourceBuilder/providers while owning OpenTelemetry-only resource enrichment (namespace, instance ID, deployment environment, and additional attributes); it must not override service name/version or recompute identity. Remove partial-registration early returns; add callback-count, non-pure-callback, late-configure, and host integration tests. Create no synonymous package (CC-27).

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-002

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. One immutable validated snapshot from callback + bound configuration
3. all child registrations built from it
4. Make Diagnostics.Observation the exclusive owner of normalized ObservationIdentity; make Diagnostics.OpenTelemetry a consumer/projector that owns only OpenTelemetry-specific resource enrichment and cannot override service name/version
5. remove partial-registration early returns
6. callback-count, non-pure-callback, late-configure, and host integration tests
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Behavior-correcting; release-note the exactly-once callback change and the ownership boundary. Existing OpenTelemetry configuration that overrides or recomputes service identity must migrate to host-supplied values normalized once by Diagnostics.Observation; OpenTelemetry-specific enrichment remains in Diagnostics.OpenTelemetry.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-05 probe post-fix..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- The callback executes exactly once per registration; every child receives the same immutable ObservationIdentity; service name/version are normalized only by Diagnostics.Observation; OpenTelemetry projects that snapshot and can add namespace/instance/environment/custom resource attributes without overriding identity.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: SP-05 probe post-fix.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-066 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Normalize Observation and OpenTelemetry options exactly once. Build one immutable validated snapshot from callback plus bound host configuration and use it for every child registration. The application host supplies raw identity values; Diagnostics.Observation exclusively normalizes, validates, and owns the immutable ObservationIdentity (service name/version plus ActivitySource and Meter names). Diagnostics.OpenTelemetry may only consume and project that identity into ResourceBuilder/providers while owning OpenTelemetry-only resource enrichment (namespace, instance ID, deployment environment, and additional attributes); it must not override service name/version or recompute identity. Remove partial-registration early returns; add callback-count, non-pure-callback, late-configure, and host integration tests. Create no synonymous package (CC-27).

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Diagnostics.Observation, Diagnostics.OpenTelemetry. Build one immutable validated snapshot from callback plus bound host configuration and use it for every child registration. The application host supplies raw identity values; Diagnostics.Observation exclusively normalizes, validates, and owns the immutable ObservationIdentity (service name/version plus ActivitySource and Meter names). Diagnostics.OpenTelemetry may only consume and project that identity into ResourceBuilder/providers while owning OpenTelemetry-only resource enrichment (namespace, instance ID, deployment environment, and additional attributes); it must not override service name/version or recompute identity. Remove partial-registration early returns; add callback-count, non-pure-callback, late-configure, and host integration tests. Create no synonymous package (CC-27).

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Both composition packages reportedly run user configure callbacks eagerly *and* via Options registration; child/provider graphs freeze the eager copy while later options may expose another — non-pure callbacks produce divergent identities; partial registration precedes missing-name validation.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Both composition packages reportedly run user configure callbacks eagerly *and* via Options registration; child/provider graphs freeze the eager copy while later options may expose another — non-pure callbacks produce divergent identities; partial registration precedes missing-name validation.

Required outcome

Build one immutable validated snapshot from callback plus bound host configuration and use it for every child registration. The application host supplies raw identity values; Diagnostics.Observation exclusively normalizes, validates, and owns the immutable ObservationIdentity (service name/version plus ActivitySource and Meter names). Diagnostics.OpenTelemetry may only consume and project that identity into ResourceBuilder/providers while owning OpenTelemetry-only resource enrichment (namespace, instance ID, deployment environment, and additional attributes); it must not override service name/version or recompute identity. Remove partial-registration early returns; add callback-count, non-pure-callback, late-configure, and host integration tests. Create no synonymous package (CC-27).

In scope

Diagnostics.Observation, Diagnostics.OpenTelemetry. Build one immutable validated snapshot from callback plus bound host configuration and use it for every child registration. The application host supplies raw identity values; Diagnostics.Observation exclusively normalizes, validates, and owns the immutable ObservationIdentity (service name/version plus ActivitySource and Meter names). Diagnostics.OpenTelemetry may only consume and project that identity into ResourceBuilder/providers while owning OpenTelemetry-only resource enrichment (namespace, instance ID, deployment environment, and additional attributes); it must not override service name/version or recompute identity. Remove partial-registration early returns; add callback-count, non-pure-callback, late-configure, and host integration tests. Create no synonymous package (CC-27).

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. One immutable validated snapshot from callback + bound configuration
3. all child registrations built from it
4. Make Diagnostics.Observation the exclusive owner of normalized ObservationIdentity; make Diagnostics.OpenTelemetry a consumer/projector that owns only OpenTelemetry-specific resource enrichment and cannot override service name/version
5. remove partial-registration early returns
6. callback-count, non-pure-callback, late-configure, and host integration tests
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Behavior-correcting; release-note the exactly-once callback change and the ownership boundary. Existing OpenTelemetry configuration that overrides or recomputes service identity must migrate to host-supplied values normalized once by Diagnostics.Observation; OpenTelemetry-specific enrichment remains in Diagnostics.OpenTelemetry.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-05 probe post-fix..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: SP-05 probe post-fix.
```

Acceptance criteria

- The callback executes exactly once per registration; every child receives the same immutable ObservationIdentity; service name/version are normalized only by Diagnostics.Observation; OpenTelemetry projects that snapshot and can add namespace/instance/environment/custom resource attributes without overriding identity.

Working rules

Use a focused branch linked to ATYA-066; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

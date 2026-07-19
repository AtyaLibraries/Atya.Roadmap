# ATYA-068 — Define the shared telemetry semantic and cardinality policy

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-068 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-066 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0054) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Custom/legacy names; default tenant/user/entity tags invite unbounded cardinality; service identity duplicated between per-signal data and OTel resources; no event-ID or tag-budget policy.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Custom/legacy names; default tenant/user/entity tags invite unbounded cardinality; service identity duplicated between per-signal data and OTel resources; no event-ID or tag-budget policy.

## Desired outcome

Approved resource/span/metric/log-scope/event-ID/messaging conventions; forbidden/high-cardinality dimension classification with opt-in hashing/bucketing; align to current OTel semantic conventions; tests/lints rejecting resource attributes on spans and unsafe metric labels.

## In-scope work

Diagnostics.Logging/Metrics/Tracing/Observation/OpenTelemetry (documented inside existing packages — no constants package, CC-27). Approved resource/span/metric/log-scope/event-ID/messaging conventions; forbidden/high-cardinality dimension classification with opt-in hashing/bucketing; align to current OTel semantic conventions; tests/lints rejecting resource attributes on spans and unsafe metric labels.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-066

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Approved resource/span/metric/log-scope/event-ID/messaging conventions
3. forbidden/high-cardinality dimension classification with opt-in hashing/bucketing
4. align to current OTel semantic conventions
5. tests/lints rejecting resource attributes on spans and unsafe metric labels.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Name migrations documented; aliases where cheap.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Lint fixtures..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Policy doc merged; lint rejects a seeded high-cardinality label; identity lives only at the resource layer.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Lint fixtures.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-068 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Define the shared telemetry semantic and cardinality policy. Approved resource/span/metric/log-scope/event-ID/messaging conventions; forbidden/high-cardinality dimension classification with opt-in hashing/bucketing; align to current OTel semantic conventions; tests/lints rejecting resource attributes on spans and unsafe metric labels.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Diagnostics.Logging/Metrics/Tracing/Observation/OpenTelemetry (documented inside existing packages — no constants package, CC-27). Approved resource/span/metric/log-scope/event-ID/messaging conventions; forbidden/high-cardinality dimension classification with opt-in hashing/bucketing; align to current OTel semantic conventions; tests/lints rejecting resource attributes on spans and unsafe metric labels.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Custom/legacy names; default tenant/user/entity tags invite unbounded cardinality; service identity duplicated between per-signal data and OTel resources; no event-ID or tag-budget policy.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Custom/legacy names; default tenant/user/entity tags invite unbounded cardinality; service identity duplicated between per-signal data and OTel resources; no event-ID or tag-budget policy.

Required outcome

Approved resource/span/metric/log-scope/event-ID/messaging conventions; forbidden/high-cardinality dimension classification with opt-in hashing/bucketing; align to current OTel semantic conventions; tests/lints rejecting resource attributes on spans and unsafe metric labels.

In scope

Diagnostics.Logging/Metrics/Tracing/Observation/OpenTelemetry (documented inside existing packages — no constants package, CC-27). Approved resource/span/metric/log-scope/event-ID/messaging conventions; forbidden/high-cardinality dimension classification with opt-in hashing/bucketing; align to current OTel semantic conventions; tests/lints rejecting resource attributes on spans and unsafe metric labels.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-066.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Approved resource/span/metric/log-scope/event-ID/messaging conventions
3. forbidden/high-cardinality dimension classification with opt-in hashing/bucketing
4. align to current OTel semantic conventions
5. tests/lints rejecting resource attributes on spans and unsafe metric labels.
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Name migrations documented; aliases where cheap.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Lint fixtures..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Lint fixtures.
```

Acceptance criteria

- Policy doc merged; lint rejects a seeded high-cardinality label; identity lives only at the resource layer.

Working rules

Use a focused branch linked to ATYA-068; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

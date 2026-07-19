# ATYA-061 — Deepen Outbox/Messaging/Idempotency scenario tests

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-061 |
| Owning repository | Atya.Roadmap |
| Priority | P2 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-057; ATYA-058 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0042) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

Coverage gates pass while scenario depth lags on the most safety-critical packages: MarkPublished-failure-after-publish, relay cancellation mid-batch, serializer round-trip edges, store concurrency, backoff schedules.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Coverage gates pass while scenario depth lags on the most safety-critical packages: MarkPublished-failure-after-publish, relay cancellation mid-batch, serializer round-trip edges, store concurrency, backoff schedules.

## Desired outcome

Scenario tests per documented failure mode + cancellation path; property-style round-trip tests for the outbox serializer; interleaved concurrency tests on both in-memory stores.

## In-scope work

Messaging.Outbox, Messaging.InMemory, Application.Idempotency. Scenario tests per documented failure mode + cancellation path; property-style round-trip tests for the outbox serializer; interleaved concurrency tests on both in-memory stores.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-057
- ATYA-058

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Scenario tests per documented failure mode + cancellation path
3. property-style round-trip tests for the outbox serializer
4. interleaved concurrency tests on both in-memory stores.
5. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

None.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Coverage-of-scenarios checklist review..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Every failure mode documented in ECO-058/059's specs has a named test; duplicate-delivery path exercised.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Coverage-of-scenarios checklist review.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-061 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Deepen Outbox/Messaging/Idempotency scenario tests. Scenario tests per documented failure mode + cancellation path; property-style round-trip tests for the outbox serializer; interleaved concurrency tests on both in-memory stores.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Messaging.Outbox, Messaging.InMemory, Application.Idempotency. Scenario tests per documented failure mode + cancellation path; property-style round-trip tests for the outbox serializer; interleaved concurrency tests on both in-memory stores.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Coverage gates pass while scenario depth lags on the most safety-critical packages: MarkPublished-failure-after-publish, relay cancellation mid-batch, serializer round-trip edges, store concurrency, backoff schedules.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Coverage gates pass while scenario depth lags on the most safety-critical packages: MarkPublished-failure-after-publish, relay cancellation mid-batch, serializer round-trip edges, store concurrency, backoff schedules.

Required outcome

Scenario tests per documented failure mode + cancellation path; property-style round-trip tests for the outbox serializer; interleaved concurrency tests on both in-memory stores.

In scope

Messaging.Outbox, Messaging.InMemory, Application.Idempotency. Scenario tests per documented failure mode + cancellation path; property-style round-trip tests for the outbox serializer; interleaved concurrency tests on both in-memory stores.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-057, ATYA-058.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Scenario tests per documented failure mode + cancellation path
3. property-style round-trip tests for the outbox serializer
4. interleaved concurrency tests on both in-memory stores.
5. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

None.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Coverage-of-scenarios checklist review..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Coverage-of-scenarios checklist review.
```

Acceptance criteria

- Every failure mode documented in ECO-058/059's specs has a named test; duplicate-delivery path exercised.

Working rules

Use a focused branch linked to ATYA-061; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

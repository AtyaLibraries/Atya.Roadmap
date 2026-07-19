# ATYA-051 — Make Governance.Testing fakes implement real contracts

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-051 |
| Owning repository | Testing |
| Primary contract owner | Testing |
| Downstream repositories | Idempotency |
| Child migration requirement | required-existing |
| Child migration tasks | ATYA-057 |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-006; ATYA-008; ATYA-022 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0020 + S-0030) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

FakeClock doesn't implement IClock (Idempotency's tests roll their own — the dogfood failure); FakeCurrentUser fakes a contract that exists nowhere; FakeCorrelationIdAccessor shadows Middleware's internal shape; Result assertions use name-based reflection.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. FakeClock doesn't implement IClock (Idempotency's tests roll their own — the dogfood failure); FakeCurrentUser fakes a contract that exists nowhere; FakeCorrelationIdAccessor shadows Middleware's internal shape; Result assertions use name-based reflection.

## Desired outcome

Make Governance.Testing fakes and typed Result assertions compile directly against accepted production contracts through explicit test-time package dependencies; obsolete ownerless FakeCurrentUser in the final 1.x line and remove it in 2.0 without inventing a Security contract; align correlation access; improve JSONPath diagnostics; publish a stable migration contract for ATYA-057.

## In-scope work

Governance.Testing package source, package dependency matrix, reusable fakes/assertions, package-local contract fixtures, public API baseline, and migration documentation.

## Out-of-scope work

Replacing Idempotency's private fake or editing other consumers; ATYA-057 owns that independently executable migration proof.

## Ownership and downstream migrations

- Primary contract owner: Testing
- Final owning repository: Testing
- Downstream repositories: Idempotency
- Child migration requirement: required-existing
- Child migration tasks: ATYA-057
- Rationale: Testing owns reusable fakes and assertions; Idempotency owns replacement of its private fake after the shared contract is released.

## Hard dependencies

- ATYA-006
- ATYA-008
- ATYA-022

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-043
- ATYA-044
- ATYA-045

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Amend the dependency matrix to allow Governance.Testing direct test-time dependencies on the accepted production-contract packages; do not create a typed-adapter layer
3. Make the clock fake implement the contract accepted by ATYA-006; when that contract is TimeProvider-backed, wrap FakeTimeProvider
4. typed Result assertions (drop reflection)
5. Mark ownerless FakeCurrentUser obsolete in the final 1.x line and remove it in 2.0; do not invent a Security contract in this task
6. align the correlation fake with ECO-022's public accessor
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Testing's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Add direct test-time production-contract dependencies in the next compatible release. Mark FakeCurrentUser obsolete in the final 1.x line and remove it in 2.0; publish a migration note that no replacement exists until an admitted Security contract owns one.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fleet grep for private clock fakes returns empty..

## Documentation work

Update Testing README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Every public fake implements a real accepted production contract and package-local fixtures compile against packed artifacts.
- Typed Result assertions use no reflection; ownerless FakeCurrentUser is obsolete in the final 1.x line and absent in 2.0; no unowned replacement contract is introduced.
- ATYA-057 has a documented migration path for replacing Idempotency's private fake.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Fleet grep for private clock fakes returns empty.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-051 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make Governance.Testing fakes implement real contracts. Make Governance.Testing fakes and typed Result assertions compile directly against accepted production contracts through explicit test-time package dependencies; obsolete ownerless FakeCurrentUser in the final 1.x line and remove it in 2.0 without inventing a Security contract; align correlation access; improve JSONPath diagnostics; publish a stable migration contract for ATYA-057.

Exact repository/package scope

Owning repository: Testing. In scope: Governance.Testing package source, package dependency matrix, reusable fakes/assertions, package-local contract fixtures, public API baseline, and migration documentation.

Ownership and migration split

- Primary contract owner: Testing
- Final owning repository: Testing
- Downstream repositories: Idempotency
- Child migration requirement: required-existing
- Child migration tasks: ATYA-057
- Rationale: Testing owns reusable fakes and assertions; Idempotency owns replacement of its private fake after the shared contract is released.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

FakeClock doesn't implement IClock (Idempotency's tests roll their own — the dogfood failure); FakeCurrentUser fakes a contract that exists nowhere; FakeCorrelationIdAccessor shadows Middleware's internal shape; Result assertions use name-based reflection.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. FakeClock doesn't implement IClock (Idempotency's tests roll their own — the dogfood failure); FakeCurrentUser fakes a contract that exists nowhere; FakeCorrelationIdAccessor shadows Middleware's internal shape; Result assertions use name-based reflection.

Required outcome

Make Governance.Testing fakes and typed Result assertions compile directly against accepted production contracts through explicit test-time package dependencies; obsolete ownerless FakeCurrentUser in the final 1.x line and remove it in 2.0 without inventing a Security contract; align correlation access; improve JSONPath diagnostics; publish a stable migration contract for ATYA-057.

In scope

Governance.Testing package source, package dependency matrix, reusable fakes/assertions, package-local contract fixtures, public API baseline, and migration documentation.

Out of scope

Replacing Idempotency's private fake or editing other consumers; ATYA-057 owns that independently executable migration proof.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-006, ATYA-008, ATYA-022.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Amend the dependency matrix to allow Governance.Testing direct test-time dependencies on the accepted production-contract packages; do not create a typed-adapter layer
3. Make the clock fake implement the contract accepted by ATYA-006; when that contract is TimeProvider-backed, wrap FakeTimeProvider
4. typed Result assertions (drop reflection)
5. Mark ownerless FakeCurrentUser obsolete in the final 1.x line and remove it in 2.0; do not invent a Security contract in this task
6. align the correlation fake with ECO-022's public accessor
7. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Testing's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Add direct test-time production-contract dependencies in the next compatible release. Mark FakeCurrentUser obsolete in the final 1.x line and remove it in 2.0; publish a migration note that no replacement exists until an admitted Security contract owns one.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fleet grep for private clock fakes returns empty..

Documentation

Update Testing README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Fleet grep for private clock fakes returns empty.
```

Acceptance criteria

- Every public fake implements a real accepted production contract and package-local fixtures compile against packed artifacts.
- Typed Result assertions use no reflection; ownerless FakeCurrentUser is obsolete in the final 1.x line and absent in 2.0; no unowned replacement contract is introduced.
- ATYA-057 has a documented migration path for replacing Idempotency's private fake.

Working rules

Use a focused branch linked to ATYA-051; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

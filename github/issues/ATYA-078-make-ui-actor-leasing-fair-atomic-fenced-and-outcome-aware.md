# ATYA-078 — Make UI actor leasing fair, atomic, fenced, and outcome-aware

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-078 |
| Owning repository | Atya.Templates.UiAutomation |
| Priority | P1 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-077 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0061) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

Lease waiting reportedly single-candidate (starvation/deadlock); set acquisition sequential without rollback; fencing tokens decorative; failed cleanup still returns actors Healthy; multi-actor plans share one browser context.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Lease waiting reportedly single-candidate (starvation/deadlock); set acquisition sequential without rollback; fencing tokens decorative; failed cleanup still returns actors Healthy; multi-actor plans share one browser context.

## Desired outcome

Fair multi-candidate waiting; atomic ordered set planning with rollback; validated fencing on release; quarantine on cleanup/context failure; hide multi-actor APIs until isolated authenticated contexts exist; concurrency/fairness/deadlock/expiry tests; preserve the strong LIFO cleanup.

## Affected scope

Primary owner: **Atya.Templates.UiAutomation**. Audit-affected repositories or coordination scopes: Atya.Templates.UiAutomation. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Templates.UiAutomation framework. Fair multi-candidate waiting; atomic ordered set planning with rollback; validated fencing on release; quarantine on cleanup/context failure; hide multi-actor APIs until isolated authenticated contexts exist; concurrency/fairness/deadlock/expiry tests; preserve the strong LIFO cleanup.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-077

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-073
- ATYA-074
- ATYA-075

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Fair multi-candidate waiting
3. atomic ordered set planning with rollback
4. validated fencing on release
5. quarantine on cleanup/context failure
6. hide multi-actor APIs until isolated authenticated contexts exist
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Atya.Templates.UiAutomation's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Template-only; breaking within the template framework acceptable pre-1.1.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Concurrency test suite..

## Documentation work

Update Atya.Templates.UiAutomation README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Deadlock scenario test passes; failed cleanup quarantines; fencing violation rejected.

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
# Task-specific proof: Concurrency test suite.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-078 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Make UI actor leasing fair, atomic, fenced, and outcome-aware. Fair multi-candidate waiting; atomic ordered set planning with rollback; validated fencing on release; quarantine on cleanup/context failure; hide multi-actor APIs until isolated authenticated contexts exist; concurrency/fairness/deadlock/expiry tests; preserve the strong LIFO cleanup.

Exact repository/package scope

Owning repository: Atya.Templates.UiAutomation. Primary owner: **Atya.Templates.UiAutomation**. Audit-affected repositories or coordination scopes: Atya.Templates.UiAutomation. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Lease waiting reportedly single-candidate (starvation/deadlock); set acquisition sequential without rollback; fencing tokens decorative; failed cleanup still returns actors Healthy; multi-actor plans share one browser context.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Lease waiting reportedly single-candidate (starvation/deadlock); set acquisition sequential without rollback; fencing tokens decorative; failed cleanup still returns actors Healthy; multi-actor plans share one browser context.

Required outcome

Fair multi-candidate waiting; atomic ordered set planning with rollback; validated fencing on release; quarantine on cleanup/context failure; hide multi-actor APIs until isolated authenticated contexts exist; concurrency/fairness/deadlock/expiry tests; preserve the strong LIFO cleanup.

In scope

Atya.Templates.UiAutomation framework. Fair multi-candidate waiting; atomic ordered set planning with rollback; validated fencing on release; quarantine on cleanup/context failure; hide multi-actor APIs until isolated authenticated contexts exist; concurrency/fairness/deadlock/expiry tests; preserve the strong LIFO cleanup.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-077.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Fair multi-candidate waiting
3. atomic ordered set planning with rollback
4. validated fencing on release
5. quarantine on cleanup/context failure
6. hide multi-actor APIs until isolated authenticated contexts exist
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Atya.Templates.UiAutomation's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Template-only; breaking within the template framework acceptable pre-1.1.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Concurrency test suite..

Documentation

Update Atya.Templates.UiAutomation README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

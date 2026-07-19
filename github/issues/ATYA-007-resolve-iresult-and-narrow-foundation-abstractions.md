# ATYA-007 — Resolve IResult and narrow Foundation.Abstractions

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-007 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 1 — Source-of-truth policy and architecture decisions |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-004 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0012 + S-0023) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

IResult is implemented only by the legacy Primitives Result and collides conceptually with ASP.NET's IResult; IAuditable/IEntity/IHasId/ISoftDeletable/IPagedQuery have zero implementations and encode mutable persistence assumptions; the package's one declared consumer doesn't use it.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. IResult is implemented only by the legacy Primitives Result and collides conceptually with ASP.NET's IResult; IAuditable/IEntity/IHasId/ISoftDeletable/IPagedQuery have zero implementations and encode mutable persistence assumptions; the package's one declared consumer doesn't use it.

## Desired outcome

ADR-03 deciding per contract. Default lean outcome (both models converge): retire IResult (do not retrofit Results); delete or PARK the persistence contracts; either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).

## In-scope work

Foundation.Abstractions, Primitives, Messaging.Abstractions (dep removal), dependency matrix. ADR-03 deciding per contract. Default lean outcome (both models converge): retire IResult (do not retrofit Results); delete or PARK the persistence contracts; either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

- ATYA-004

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-03 deciding per contract
3. Default lean outcome (both models converge): retire IResult (do not retrofit Results)
4. delete or PARK the persistence contracts
5. either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

Breaking; 2.0 train with migration notes; matrix amended (ECO-034).

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fleet grep for the removed symbols returns empty..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR merged; no shipped Atya package references a removed contract; matrix and manifest agree.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Fleet grep for the removed symbols returns empty.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-007 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Resolve IResult and narrow Foundation.Abstractions. ADR-03 deciding per contract. Default lean outcome (both models converge): retire IResult (do not retrofit Results); delete or PARK the persistence contracts; either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Foundation.Abstractions, Primitives, Messaging.Abstractions (dep removal), dependency matrix. ADR-03 deciding per contract. Default lean outcome (both models converge): retire IResult (do not retrofit Results); delete or PARK the persistence contracts; either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

IResult is implemented only by the legacy Primitives Result and collides conceptually with ASP.NET's IResult; IAuditable/IEntity/IHasId/ISoftDeletable/IPagedQuery have zero implementations and encode mutable persistence assumptions; the package's one declared consumer doesn't use it.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. IResult is implemented only by the legacy Primitives Result and collides conceptually with ASP.NET's IResult; IAuditable/IEntity/IHasId/ISoftDeletable/IPagedQuery have zero implementations and encode mutable persistence assumptions; the package's one declared consumer doesn't use it.

Required outcome

ADR-03 deciding per contract. Default lean outcome (both models converge): retire IResult (do not retrofit Results); delete or PARK the persistence contracts; either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).

In scope

Foundation.Abstractions, Primitives, Messaging.Abstractions (dep removal), dependency matrix. ADR-03 deciding per contract. Default lean outcome (both models converge): retire IResult (do not retrofit Results); delete or PARK the persistence contracts; either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-004.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. ADR-03 deciding per contract
3. Default lean outcome (both models converge): retire IResult (do not retrofit Results)
4. delete or PARK the persistence contracts
5. either near-empty the package with honest documentation or DEPRECATE it (Fable's option b — deferred to this ADR per §6).
6. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

Breaking; 2.0 train with migration notes; matrix amended (ECO-034).

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fleet grep for the removed symbols returns empty..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Fleet grep for the removed symbols returns empty.
```

Acceptance criteria

- ADR merged; no shipped Atya package references a removed contract; matrix and manifest agree.

Working rules

Use a focused branch linked to ATYA-007; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 1 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

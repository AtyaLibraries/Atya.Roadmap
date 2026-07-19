# ATYA-084 — Decide admission and scope for Entity Framework Core adapters

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-084 |
| Owning repository | Atya.Roadmap |
| Priority | P2 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-058; ATYA-065; ATYA-075 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0068) |
| Confidence | High |
| Risk | Medium |
| Effort | L |

## Problem description

The roadmap names EF Core while the constitution rejects broad data packages; no accepted admission decision identifies a stable capability owner, adopter, provider support, or implementation boundary.

## Root cause

Package/repository admission, generic EF convenience proposals, provider conformance, and code delivery were embedded in one implementation task before stable Outbox/Pagination evidence existed.

## Desired outcome

Accept an ADR that rejects generic EF convenience packages by default and decides whether a capability-specific Outbox EF Core adapter is admitted for a named adopter. Define capability scope, provider support, public-contract owner, conformance matrix, at-least-once claims, lifecycle, and the handoff to ATYA-123. Repository placement is not chosen or created here; ATYA-123 follows ATYA-013.

## In-scope work

Atya.Roadmap ADR/admission evidence using accepted ATYA-058, ATYA-065, and ATYA-075 outcomes. Decide accept/reject/defer and, if accepted, specify the implementation contract for ATYA-123.

## Out-of-scope work

Package code, migrations, provider fixtures, publication, or repository creation. No repository is created by ATYA-084. ATYA-123 is the separately owned implementation and is hard-gated by ATYA-013.

## Hard dependencies

- ATYA-058
- ATYA-065
- ATYA-075

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-123
- ATYA-058
- ATYA-065
- ATYA-087

## Implementation sequence

1. Confirm stable Outbox/Pagination contracts and named-adopter evidence.
2. Compare no package, existing-repository adapter, and capability-specific package options.
3. Record accept/reject/defer, provider/support scope, contract ownership, conformance requirements, and honest at-least-once semantics.
4. Link the decision to ATYA-123 and do not implement or create a repository here.

## Architecture guidance

This is organization-wide package admission and belongs to Atya.Roadmap. It must not pre-empt ATYA-013 repository topology; the implementation task follows both accepted decisions.

## Compatibility and migration

The ADR must name migration ownership and supported providers from v1; it changes no code or package by itself.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Validate the ADR against ATYA-058 conformance requirements, at least one named adopter scenario, and failure modes for transactions, atomic claim/CAS, lease expiry, migrations, and cancellation.

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- One accepted accept/reject/defer decision names the adopter, capability owner, provider/support matrix, conformance gates, and at-least-once semantics.
- No implementation or repository is created by ATYA-084.
- ATYA-123 can execute the accepted outcome without making an architecture or admission decision.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: accepted admission ADR with named adopter, provider matrix, and ATYA-123 handoff.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-084 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Decide admission and scope for Entity Framework Core adapters. Accept an ADR that rejects generic EF convenience packages by default and decides whether a capability-specific Outbox EF Core adapter is admitted for a named adopter. Define capability scope, provider support, public-contract owner, conformance matrix, at-least-once claims, lifecycle, and the handoff to ATYA-123. Repository placement is not chosen or created here; ATYA-123 follows ATYA-013.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Atya.Roadmap ADR/admission evidence using accepted ATYA-058, ATYA-065, and ATYA-075 outcomes. Decide accept/reject/defer and, if accepted, specify the implementation contract for ATYA-123.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

The roadmap names EF Core while the constitution rejects broad data packages; no accepted admission decision identifies a stable capability owner, adopter, provider support, or implementation boundary.

Root cause: Package/repository admission, generic EF convenience proposals, provider conformance, and code delivery were embedded in one implementation task before stable Outbox/Pagination evidence existed.

Required outcome

Accept an ADR that rejects generic EF convenience packages by default and decides whether a capability-specific Outbox EF Core adapter is admitted for a named adopter. Define capability scope, provider support, public-contract owner, conformance matrix, at-least-once claims, lifecycle, and the handoff to ATYA-123. Repository placement is not chosen or created here; ATYA-123 follows ATYA-013.

In scope

Atya.Roadmap ADR/admission evidence using accepted ATYA-058, ATYA-065, and ATYA-075 outcomes. Decide accept/reject/defer and, if accepted, specify the implementation contract for ATYA-123.

Out of scope

Package code, migrations, provider fixtures, publication, or repository creation. No repository is created by ATYA-084. ATYA-123 is the separately owned implementation and is hard-gated by ATYA-013.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-058, ATYA-065, ATYA-075.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Confirm stable Outbox/Pagination contracts and named-adopter evidence.
2. Compare no package, existing-repository adapter, and capability-specific package options.
3. Record accept/reject/defer, provider/support scope, contract ownership, conformance requirements, and honest at-least-once semantics.
4. Link the decision to ATYA-123 and do not implement or create a repository here.

Architecture constraints

This is organization-wide package admission and belongs to Atya.Roadmap. It must not pre-empt ATYA-013 repository topology; the implementation task follows both accepted decisions.

Compatibility and migration requirements

The ADR must name migration ownership and supported providers from v1; it changes no code or package by itself.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Validate the ADR against ATYA-058 conformance requirements, at least one named adopter scenario, and failure modes for transactions, atomic claim/CAS, lease expiry, migrations, and cancellation.

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: accepted admission ADR with named adopter, provider matrix, and ATYA-123 handoff.
```

Acceptance criteria

- One accepted accept/reject/defer decision names the adopter, capability owner, provider/support matrix, conformance gates, and at-least-once semantics.
- No implementation or repository is created by ATYA-084.
- ATYA-123 can execute the accepted outcome without making an architecture or admission decision.

Working rules

Use a focused branch linked to ATYA-084; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 6 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

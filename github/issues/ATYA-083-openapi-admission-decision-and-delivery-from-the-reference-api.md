# ATYA-083 — OpenAPI: admission decision and delivery from the reference API

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-083 |
| Owning repository | Atya.Roadmap |
| Priority | P2 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-004; ATYA-009; ATYA-052; ATYA-075; ATYA-079 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0067); decision layer shared with ECO-004 (Fable's disposition) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

OpenAPI is roadmap-requested but constitution-CUT; no owned policy for documents, auth schemes, versioning, ProblemDetails schemas, or build-time verification.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. OpenAPI is roadmap-requested but constitution-CUT; no owned policy for documents, auth schemes, versioning, ProblemDetails schemas, or build-time verification.

## Desired outcome

Decide the OpenAPI delivery model, prove the canonical error/validation schemas in the existing golden API, and deliver template content only in the existing reference/template repositories. If a new PackageId or repository is admitted, create a separate implementation task depending on ATYA-083 and ATYA-013.

## In-scope work

Existing golden reference API and atya-api template repositories: ADR, generated canonical schemas, representative endpoint snapshots, and template content.

## Out-of-scope work

Creating a new PackageId or repository. Any admitted package implementation is a separate owning-repository task hard-dependent on ATYA-083 and ATYA-013.

## Hard dependencies

- ATYA-004
- ATYA-009
- ATYA-052
- ATYA-075
- ATYA-079

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. Default disposition: template content (both models converge)
3. prove in the golden API
4. generate the canonical error/validation schemas into documents
5. snapshot-test representative endpoints
6. publish a package only if it owns stable cross-service policy (ADR through the admission gate).
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

Document changes treated as reviewed API changes.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Snapshot tests..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- The existing golden API serves a snapshot-tested document embedding the canonical error schema.
- The ADR records template/package disposition. No new repository is created; an admitted package is represented by a separate ATYA-013-gated implementation task.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Snapshot tests.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-083 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

OpenAPI: admission decision and delivery from the reference API. Decide the OpenAPI delivery model, prove the canonical error/validation schemas in the existing golden API, and deliver template content only in the existing reference/template repositories. If a new PackageId or repository is admitted, create a separate implementation task depending on ATYA-083 and ATYA-013.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Existing golden reference API and atya-api template repositories: ADR, generated canonical schemas, representative endpoint snapshots, and template content.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

OpenAPI is roadmap-requested but constitution-CUT; no owned policy for documents, auth schemes, versioning, ProblemDetails schemas, or build-time verification.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. OpenAPI is roadmap-requested but constitution-CUT; no owned policy for documents, auth schemes, versioning, ProblemDetails schemas, or build-time verification.

Required outcome

Decide the OpenAPI delivery model, prove the canonical error/validation schemas in the existing golden API, and deliver template content only in the existing reference/template repositories. If a new PackageId or repository is admitted, create a separate implementation task depending on ATYA-083 and ATYA-013.

In scope

Existing golden reference API and atya-api template repositories: ADR, generated canonical schemas, representative endpoint snapshots, and template content.

Out of scope

Creating a new PackageId or repository. Any admitted package implementation is a separate owning-repository task hard-dependent on ATYA-083 and ATYA-013.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-004, ATYA-009, ATYA-052, ATYA-075, ATYA-079.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. Default disposition: template content (both models converge)
3. prove in the golden API
4. generate the canonical error/validation schemas into documents
5. snapshot-test representative endpoints
6. publish a package only if it owns stable cross-service policy (ADR through the admission gate).
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

Document changes treated as reviewed API changes.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Snapshot tests..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Snapshot tests.
```

Acceptance criteria

- The existing golden API serves a snapshot-tested document embedding the canonical error schema.
- The ADR records template/package disposition. No new repository is created; an admitted package is represented by a separate ATYA-013-gated implementation task.

Working rules

Use a focused branch linked to ATYA-083; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 6 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

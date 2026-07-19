# ATYA-114 — Enforce dependency-license compliance in release evidence

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-114 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-018; ATYA-032 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Cross-review omission and final architectural synthesis |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

SBOM and vulnerability checks do not by themselves establish transitive license compatibility, notice obligations, or an exception process.

## Root cause

Fleet work accumulated across independent repositories without one stable ATYA identity and evidence-controlled retirement process. SBOM and vulnerability checks do not by themselves establish transitive license compatibility, notice obligations, or an exception process.

## Desired outcome

Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.

## In-scope work

Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.

## Out-of-scope work

Any destructive action before its audit dependency is approved; deletion of unique work; force-push/tag rewriting; unrelated package design changes.

## Hard dependencies

- ATYA-018
- ATYA-032

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.
3. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
4. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Preserve commit history, issue/PR attribution, published tags/packages, consumer compatibility, and recoverability. Migrate before close/delete; use forward fixes for immutable releases.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Use dry-run inventories and fixture data first. Re-run the exact audit after action and compare counts/SHAs/URLs; require zero unexplained deltas and independent spot checks for destructive batches.

## Documentation work

Update the Atya.Roadmap ledger with URLs, SHAs, decisions, approver, timestamps, exceptions, recovery notes, and links from every retired artifact.

## Measurable acceptance criteria

- Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.
- Every scoped repository or artifact has exactly one recorded disposition and owner.
- Evidence is reproducible; destructive actions, if any, depend on approved audit output and have recovery notes.

## Definition of done

- All acceptance criteria pass and the audit/action ledger is complete.
- No useful work, attribution, or immutable release evidence was lost.
- Follow-up issues use stable ATYA IDs and project metadata; remaining exceptions have owners and dates.

## Validation commands

```powershell
gh auth status
gh api orgs/AtyaLibraries --method GET
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.
```

## Rollback strategy

Revert only the scoped configuration/content change from its recorded commit and restore the prior ledger snapshot; retain audit history.

## Standalone implementation prompt

You are implementing ATYA-114 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Enforce dependency-license compliance in release evidence. Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

SBOM and vulnerability checks do not by themselves establish transitive license compatibility, notice obligations, or an exception process.

Root cause: Fleet work accumulated across independent repositories without one stable ATYA identity and evidence-controlled retirement process. SBOM and vulnerability checks do not by themselves establish transitive license compatibility, notice obligations, or an exception process.

Required outcome

Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.

In scope

Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.

Out of scope

Any destructive action before its audit dependency is approved; deletion of unique work; force-push/tag rewriting; unrelated package design changes.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-018, ATYA-032.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.
3. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
4. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Preserve commit history, issue/PR attribution, published tags/packages, consumer compatibility, and recoverability. Migrate before close/delete; use forward fixes for immutable releases.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Use dry-run inventories and fixture data first. Re-run the exact audit after action and compare counts/SHAs/URLs; require zero unexplained deltas and independent spot checks for destructive batches.

Documentation

Update the Atya.Roadmap ledger with URLs, SHAs, decisions, approver, timestamps, exceptions, recovery notes, and links from every retired artifact.

Validation commands

```powershell
gh auth status
gh api orgs/AtyaLibraries --method GET
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.
```

Acceptance criteria

- Generate a transitive license inventory from packed artifacts/SBOMs, define allow/deny/review policy and notices, fixture-test unknown/conflicting licenses, and block publication only according to the accepted exception workflow.
- Every scoped repository or artifact has exactly one recorded disposition and owner.
- Evidence is reproducible; destructive actions, if any, depend on approved audit output and have recovery notes.

Working rules

Use a focused branch linked to ATYA-114; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 3 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

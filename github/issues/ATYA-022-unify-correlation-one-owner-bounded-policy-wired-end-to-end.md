# ATYA-022 — Unify correlation: one owner, bounded policy, wired end-to-end

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-022 |
| Owning repository | Atya.Roadmap |
| Priority | P1 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-019; ATYA-034 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0021 + F-0022 + S-0046) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

Header constant in Client + Middleware + hard-coded in ProblemDetails; log/tag names in Logging/Tracing; no edges connect them; inbound values unvalidated (length/charset); IDs never reach scopes, Activity, or outbound calls.

## Root cause

Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Header constant in Client + Middleware + hard-coded in ProblemDetails; log/tag names in Logging/Tracing; no edges connect them; inbound values unvalidated (length/charset); IDs never reach scopes, Activity, or outbound calls.

## Desired outcome

(1) Middleware owns the concept: public header constant + accessor. (2) Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults. (3) ProblemDetails reads from options/accessor, not a literal. (4) Middleware pushes the ID into log scope (Logging's property name) and Activity tag/baggage (Tracing's). (5) Client ships a CorrelationPropagationHandler registered by AddAtyaHttpClient. (6) One matrix/constitution amendment for the new edges; adversarial tests (oversized/malformed/duplicate).

## In-scope work

Web.Middleware (owner), Errors.ProblemDetails, Http.Client, Diagnostics.Logging/Tracing; dependency matrix. (1) Middleware owns the concept: public header constant + accessor. (2) Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults. (3) ProblemDetails reads from options/accessor, not a literal. (4) Middleware pushes the ID into log scope (Logging's property name) and Activity tag/baggage (Tracing's). (5) Client ships a CorrelationPropagationHandler registered by AddAtyaHttpClient. (6) One matrix/constitution amendment for the new edges; adversarial tests (oversized/malformed/duplicate).

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-019
- ATYA-034

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-001
- ATYA-002
- ATYA-003

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Middleware owns the concept: public header constant + accessor
3. Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults
4. ProblemDetails reads from options/accessor, not a literal
5. Middleware pushes the ID into log scope (Logging's property name
6. and Activity tag/baggage (Tracing's)
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

## Compatibility and migration

Behavioral (junk inbound IDs now replaced) — release-note; new edges documented deliberately.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Integration test across a two-service sample..

## Documentation work

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- End-to-end test: inbound header → response header + log scope + Activity + outbound request, with invalid input regenerated; renaming the header in options breaks nothing.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Integration test across a two-service sample.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-022 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Unify correlation: one owner, bounded policy, wired end-to-end. (1) Middleware owns the concept: public header constant + accessor. (2) Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults. (3) ProblemDetails reads from options/accessor, not a literal. (4) Middleware pushes the ID into log scope (Logging's property name) and Activity tag/baggage (Tracing's). (5) Client ships a CorrelationPropagationHandler registered by AddAtyaHttpClient. (6) One matrix/constitution amendment for the new edges; adversarial tests (oversized/malformed/duplicate).

Exact repository/package scope

Owning repository: Atya.Roadmap. In scope: Web.Middleware (owner), Errors.ProblemDetails, Http.Client, Diagnostics.Logging/Tracing; dependency matrix. (1) Middleware owns the concept: public header constant + accessor. (2) Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults. (3) ProblemDetails reads from options/accessor, not a literal. (4) Middleware pushes the ID into log scope (Logging's property name) and Activity tag/baggage (Tracing's). (5) Client ships a CorrelationPropagationHandler registered by AddAtyaHttpClient. (6) One matrix/constitution amendment for the new edges; adversarial tests (oversized/malformed/duplicate).

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Header constant in Client + Middleware + hard-coded in ProblemDetails; log/tag names in Logging/Tracing; no edges connect them; inbound values unvalidated (length/charset); IDs never reach scopes, Activity, or outbound calls.

Root cause: Fleet policy and implementation evolved in separate repositories without one enforced source of truth or evidence gate. Header constant in Client + Middleware + hard-coded in ProblemDetails; log/tag names in Logging/Tracing; no edges connect them; inbound values unvalidated (length/charset); IDs never reach scopes, Activity, or outbound calls.

Required outcome

(1) Middleware owns the concept: public header constant + accessor. (2) Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults. (3) ProblemDetails reads from options/accessor, not a literal. (4) Middleware pushes the ID into log scope (Logging's property name) and Activity tag/baggage (Tracing's). (5) Client ships a CorrelationPropagationHandler registered by AddAtyaHttpClient. (6) One matrix/constitution amendment for the new edges; adversarial tests (oversized/malformed/duplicate).

In scope

Web.Middleware (owner), Errors.ProblemDetails, Http.Client, Diagnostics.Logging/Tracing; dependency matrix. (1) Middleware owns the concept: public header constant + accessor. (2) Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults. (3) ProblemDetails reads from options/accessor, not a literal. (4) Middleware pushes the ID into log scope (Logging's property name) and Activity tag/baggage (Tracing's). (5) Client ships a CorrelationPropagationHandler registered by AddAtyaHttpClient. (6) One matrix/constitution amendment for the new edges; adversarial tests (oversized/malformed/duplicate).

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-019, ATYA-034.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Middleware owns the concept: public header constant + accessor
3. Bounded policy: max length (~128), charset allowlist, multi-value/trusted-proxy rules, regenerate-on-invalid — configurable, safe defaults
4. ProblemDetails reads from options/accessor, not a literal
5. Middleware pushes the ID into log scope (Logging's property name
6. and Activity tag/baggage (Tracing's)
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep cross-repository policy and generated inventory in Atya.Roadmap/platform authority; package repositories consume generated artifacts and must not fork policy copies.

Compatibility and migration requirements

Behavioral (junk inbound IDs now replaced) — release-note; new edges documented deliberately.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Integration test across a two-service sample..

Documentation

Update Atya.Roadmap README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
pwsh -File ./github/scripts/Validate-Atya-Implementation-Plan.ps1 -PlanRoot .
# Task-specific proof: Integration test across a two-service sample.
```

Acceptance criteria

- End-to-end test: inbound header → response header + log scope + Activity + outbound request, with invalid input regenerated; renaming the header in options breaks nothing.

Working rules

Use a focused branch linked to ATYA-022; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 2 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

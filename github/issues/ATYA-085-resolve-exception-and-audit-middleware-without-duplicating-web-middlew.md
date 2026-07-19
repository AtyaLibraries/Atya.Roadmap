# ATYA-085 — Resolve exception and audit middleware without duplicating Web.Middleware

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-085 |
| Owning repository | Middleware |
| Priority | P2 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-052; ATYA-053; ATYA-022; ATYA-075 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0069); decision layer shared with ECO-004 |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

Roadmap's "Exception middleware" overlaps shipped Web.Middleware + ProblemDetails; "Audit middleware" (request/response logging) risks credential/PII/body disclosure and latency if built as generic capture.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Roadmap's "Exception middleware" overlaps shipped Web.Middleware + ProblemDetails; "Audit middleware" (request/response logging) risks credential/PII/body disclosure and latency if built as generic capture.

## Desired outcome

Overlap ADR: extend existing packages for genuine exception gaps — no synonym package. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation; metadata-only default; disclosure/backpressure/performance tests.

## In-scope work

Web.Middleware extensions; potential Web.Audit under its PARK trigger. Overlap ADR: extend existing packages for genuine exception gaps — no synonym package. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation; metadata-only default; disclosure/backpressure/performance tests.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-052
- ATYA-053
- ATYA-022
- ATYA-075

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-055
- ATYA-073
- ATYA-074

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Overlap ADR: extend existing packages for genuine exception gaps — no synonym package
3. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation
4. metadata-only default
5. disclosure/backpressure/performance tests.
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Middleware's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

None until admitted.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Disclosure test suite..

## Documentation work

Update Middleware README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- ADR recorded; any audit implementation passes disclosure tests with seeded secrets.

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
# Task-specific proof: Disclosure test suite.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-085 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Resolve exception and audit middleware without duplicating Web.Middleware. Overlap ADR: extend existing packages for genuine exception gaps — no synonym package. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation; metadata-only default; disclosure/backpressure/performance tests.

Exact repository/package scope

Owning repository: Middleware. In scope: Web.Middleware extensions; potential Web.Audit under its PARK trigger. Overlap ADR: extend existing packages for genuine exception gaps — no synonym package. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation; metadata-only default; disclosure/backpressure/performance tests.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Roadmap's "Exception middleware" overlaps shipped Web.Middleware + ProblemDetails; "Audit middleware" (request/response logging) risks credential/PII/body disclosure and latency if built as generic capture.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Roadmap's "Exception middleware" overlaps shipped Web.Middleware + ProblemDetails; "Audit middleware" (request/response logging) risks credential/PII/body disclosure and latency if built as generic capture.

Required outcome

Overlap ADR: extend existing packages for genuine exception gaps — no synonym package. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation; metadata-only default; disclosure/backpressure/performance tests.

In scope

Web.Middleware extensions; potential Web.Audit under its PARK trigger. Overlap ADR: extend existing packages for genuine exception gaps — no synonym package. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation; metadata-only default; disclosure/backpressure/performance tests.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-052, ATYA-053, ATYA-022, ATYA-075.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Overlap ADR: extend existing packages for genuine exception gaps — no synonym package
3. Audit only for a named adopter: opt-in policy with content-type allowlists, field/header/query redaction, strict byte/time limits, streaming-safe behavior, sampling, authorization boundaries, failure isolation
4. metadata-only default
5. disclosure/backpressure/performance tests.
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Middleware's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

None until admitted.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Disclosure test suite..

Documentation

Update Middleware README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Disclosure test suite.
```

Acceptance criteria

- ADR recorded; any audit implementation passes disclosure tests with seeded secrets.

Working rules

Use a focused branch linked to ATYA-085; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 6 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

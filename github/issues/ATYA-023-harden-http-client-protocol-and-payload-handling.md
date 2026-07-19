# ATYA-023 — Harden Http.Client protocol and payload handling

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-023 |
| Owning repository | Client |
| Priority | P1 |
| Phase | 2 — Security, compatibility, and release blockers |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-002; ATYA-022; ATYA-009; ATYA-052 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0048) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Reportedly trusts body status over transport status; unbounded JSON reads with static options; query strings retained in Error.Target; unvalidated correlation headers; ambiguous exception-vs-Result boundary.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Reportedly trusts body status over transport status; unbounded JSON reads with static options; query strings retained in Error.Target; unvalidated correlation headers; ambiguous exception-vs-Result boundary.

## Desired outcome

Make transport status authoritative (body disagreement → diagnostics); add configurable size/depth bounds including chunked bodies; use configured serializers; redact query/credentials from targets. Convert DNS, socket, TLS, HttpRequestException, non-caller timeout, non-success status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only when the caller's token is canceled; throw argument/configuration errors before I/O; never leak a raw transport exception. Drop the server-oriented ProblemDetails dependency when ATYA-009's contract lands; add timeout, cancellation, malformed-success, and mismatch tests.

## In-scope work

Http.Client. Make transport status authoritative (body disagreement → diagnostics); add configurable size/depth bounds including chunked bodies; use configured serializers; redact query/credentials from targets. Convert DNS, socket, TLS, HttpRequestException, non-caller timeout, non-success status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only when the caller's token is canceled; throw argument/configuration errors before I/O; never leak a raw transport exception. Drop the server-oriented ProblemDetails dependency when ATYA-009's contract lands; add timeout, cancellation, malformed-success, and mismatch tests.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-002
- ATYA-022
- ATYA-009
- ATYA-052

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-014
- ATYA-015
- ATYA-016

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Transport status authoritative (body disagreement → diagnostics)
3. configurable size/depth bounds incl
4. configured serializers
5. redact query/credentials from targets
6. Convert transport, non-caller timeout, protocol-status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only for caller cancellation; throw argument/configuration errors before I/O; never expose a raw transport exception
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Client's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Release-note the binding exception boundary: operational HTTP failures become typed Result errors, caller cancellation alone propagates OperationCanceledException, and pre-I/O argument/configuration defects throw. The dependency swap rides the ATYA-009 wire-contract train.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-09 probes post-fix..

## Documentation work

Update Client README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- A 502 response with body "status":200 yields a transport-status Result plus diagnostic; DNS/socket/TLS/HttpRequestException and non-caller timeout probes yield typed Result errors with no raw exception; caller cancellation propagates OperationCanceledException; oversized bodies are bounded; no query string appears in any Error.Target.

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
# Task-specific proof: SP-09 probes post-fix.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-023 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Harden Http.Client protocol and payload handling. Make transport status authoritative (body disagreement → diagnostics); add configurable size/depth bounds including chunked bodies; use configured serializers; redact query/credentials from targets. Convert DNS, socket, TLS, HttpRequestException, non-caller timeout, non-success status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only when the caller's token is canceled; throw argument/configuration errors before I/O; never leak a raw transport exception. Drop the server-oriented ProblemDetails dependency when ATYA-009's contract lands; add timeout, cancellation, malformed-success, and mismatch tests.

Exact repository/package scope

Owning repository: Client. In scope: Http.Client. Make transport status authoritative (body disagreement → diagnostics); add configurable size/depth bounds including chunked bodies; use configured serializers; redact query/credentials from targets. Convert DNS, socket, TLS, HttpRequestException, non-caller timeout, non-success status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only when the caller's token is canceled; throw argument/configuration errors before I/O; never leak a raw transport exception. Drop the server-oriented ProblemDetails dependency when ATYA-009's contract lands; add timeout, cancellation, malformed-success, and mismatch tests.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Reportedly trusts body status over transport status; unbounded JSON reads with static options; query strings retained in Error.Target; unvalidated correlation headers; ambiguous exception-vs-Result boundary.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Reportedly trusts body status over transport status; unbounded JSON reads with static options; query strings retained in Error.Target; unvalidated correlation headers; ambiguous exception-vs-Result boundary.

Required outcome

Make transport status authoritative (body disagreement → diagnostics); add configurable size/depth bounds including chunked bodies; use configured serializers; redact query/credentials from targets. Convert DNS, socket, TLS, HttpRequestException, non-caller timeout, non-success status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only when the caller's token is canceled; throw argument/configuration errors before I/O; never leak a raw transport exception. Drop the server-oriented ProblemDetails dependency when ATYA-009's contract lands; add timeout, cancellation, malformed-success, and mismatch tests.

In scope

Http.Client. Make transport status authoritative (body disagreement → diagnostics); add configurable size/depth bounds including chunked bodies; use configured serializers; redact query/credentials from targets. Convert DNS, socket, TLS, HttpRequestException, non-caller timeout, non-success status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only when the caller's token is canceled; throw argument/configuration errors before I/O; never leak a raw transport exception. Drop the server-oriented ProblemDetails dependency when ATYA-009's contract lands; add timeout, cancellation, malformed-success, and mismatch tests.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002, ATYA-022, ATYA-009, ATYA-052.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Transport status authoritative (body disagreement → diagnostics)
3. configurable size/depth bounds incl
4. configured serializers
5. redact query/credentials from targets
6. Convert transport, non-caller timeout, protocol-status, body-bound, and malformed-payload failures into typed Result errors; propagate OperationCanceledException only for caller cancellation; throw argument/configuration errors before I/O; never expose a raw transport exception
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Client's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Release-note the binding exception boundary: operational HTTP failures become typed Result errors, caller cancellation alone propagates OperationCanceledException, and pre-I/O argument/configuration defects throw. The dependency swap rides the ATYA-009 wire-contract train.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-09 probes post-fix..

Documentation

Update Client README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: SP-09 probes post-fix.
```

Acceptance criteria

- A 502 response with body "status":200 yields a transport-status Result plus diagnostic; DNS/socket/TLS/HttpRequestException and non-caller timeout probes yield typed Result errors with no raw exception; caller cancellation propagates OperationCanceledException; oversized bodies are bounded; no query string appears in any Error.Target.

Working rules

Use a focused branch linked to ATYA-023; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 2 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

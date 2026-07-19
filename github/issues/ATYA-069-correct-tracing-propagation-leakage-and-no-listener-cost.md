# ATYA-069 — Correct Tracing propagation, leakage, and no-listener cost

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-069 |
| Owning repository | Tracing |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-068; ATYA-022 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0055) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Reportedly: default tags allocated before listener checks; arbitrary Activity.Id treated as W3C traceparent; per-span service identity; record with mutation possible on snapshots; exception text copied into activity status/tags; no baggage bounds.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Reportedly: default tags allocated before listener checks; arbitrary Activity.Id treated as W3C traceparent; per-span service identity; record with mutation possible on snapshots; exception text copied into activity status/tags; no baggage bounds.

## Desired outcome

HasListeners fast path + allocation-conscious tag APIs; standard propagators with W3C validation + bounded allowlists; invariant-safe snapshots; redacted standardized exception recording; propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests; drop per-span service.name/version once ECO-068 sets resource identity.

## In-scope work

Diagnostics.Tracing. HasListeners fast path + allocation-conscious tag APIs; standard propagators with W3C validation + bounded allowlists; invariant-safe snapshots; redacted standardized exception recording; propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests; drop per-span service.name/version once ECO-068 sets resource identity.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-068
- ATYA-022

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. HasListeners fast path + allocation-conscious tag APIs
3. standard propagators with W3C validation + bounded allowlists
4. invariant-safe snapshots
5. redacted standardized exception recording
6. propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Tracing's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Behavior-correcting; benchmark gate added.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Allocation benchmarks + propagation tests..

## Documentation work

Update Tracing README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- No-listener path allocates within budget; malformed inbound trace context never propagates as valid; exception messages absent from tags by default.

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
# Task-specific proof: Allocation benchmarks + propagation tests.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-069 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Correct Tracing propagation, leakage, and no-listener cost. HasListeners fast path + allocation-conscious tag APIs; standard propagators with W3C validation + bounded allowlists; invariant-safe snapshots; redacted standardized exception recording; propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests; drop per-span service.name/version once ECO-068 sets resource identity.

Exact repository/package scope

Owning repository: Tracing. In scope: Diagnostics.Tracing. HasListeners fast path + allocation-conscious tag APIs; standard propagators with W3C validation + bounded allowlists; invariant-safe snapshots; redacted standardized exception recording; propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests; drop per-span service.name/version once ECO-068 sets resource identity.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Reportedly: default tags allocated before listener checks; arbitrary Activity.Id treated as W3C traceparent; per-span service identity; record with mutation possible on snapshots; exception text copied into activity status/tags; no baggage bounds.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Reportedly: default tags allocated before listener checks; arbitrary Activity.Id treated as W3C traceparent; per-span service identity; record with mutation possible on snapshots; exception text copied into activity status/tags; no baggage bounds.

Required outcome

HasListeners fast path + allocation-conscious tag APIs; standard propagators with W3C validation + bounded allowlists; invariant-safe snapshots; redacted standardized exception recording; propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests; drop per-span service.name/version once ECO-068 sets resource identity.

In scope

Diagnostics.Tracing. HasListeners fast path + allocation-conscious tag APIs; standard propagators with W3C validation + bounded allowlists; invariant-safe snapshots; redacted standardized exception recording; propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests; drop per-span service.name/version once ECO-068 sets resource identity.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-068, ATYA-022.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. HasListeners fast path + allocation-conscious tag APIs
3. standard propagators with W3C validation + bounded allowlists
4. invariant-safe snapshots
5. redacted standardized exception recording
6. propagator-interop, non-W3C, no-listener-allocation, and benchmark-threshold tests
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Tracing's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Behavior-correcting; benchmark gate added.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Allocation benchmarks + propagation tests..

Documentation

Update Tracing README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Allocation benchmarks + propagation tests.
```

Acceptance criteria

- No-listener path allocates within budget; malformed inbound trace context never propagates as valid; exception messages absent from tags by default.

Working rules

Use a focused branch linked to ATYA-069; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

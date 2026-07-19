# ATYA-059 — Evolve Messaging.Abstractions for stable, durable contracts

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-059 |
| Owning repository | Messaging.Abstractions |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-004; ATYA-033 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (S-0032 + F-0028 (semantics half)) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

The contract lacks delivery semantics (ordering, isolation, error propagation — InMemory's behavior is the accidental spec), stable contract/schema identity, occurred/causation metadata, and async-disposable subscriptions; type-erased publish doesn't enforce object/type agreement; the unused Foundation.Abstractions edge (removed via ECO-034).

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. The contract lacks delivery semantics (ordering, isolation, error propagation — InMemory's behavior is the accidental spec), stable contract/schema identity, occurred/causation metadata, and async-disposable subscriptions; type-erased publish doesn't enforce object/type agreement; the unused Foundation.Abstractions edge (removed via ECO-034).

## Desired outcome

Document guaranteed-vs-transport-defined semantics in XML docs and the README (Fable's behavioral spec); add IAsyncDisposable subscription lifecycle compatibly; add normalized message/contract identity and schema version plus occurred/causation metadata with header normalization. Define successful PublishAsync completion as the transport accepting responsibility according to its declared durability class, not handler completion or end-to-end delivery: type/payload mismatch and caller cancellation fail before acceptance, while cancellation after acceptance cannot revoke it. Ordering, retries, and delivery-failure reporting remain transport-defined but must be declared by every adapter. Publish a reusable transport contract-test kit before any broker adapter. Keep routing, partitioning, and TTL adopter-driven.

## In-scope work

Messaging.Abstractions. Document guaranteed-vs-transport-defined semantics in XML docs and the README (Fable's behavioral spec); add IAsyncDisposable subscription lifecycle compatibly; add normalized message/contract identity and schema version plus occurred/causation metadata with header normalization. Define successful PublishAsync completion as the transport accepting responsibility according to its declared durability class, not handler completion or end-to-end delivery: type/payload mismatch and caller cancellation fail before acceptance, while cancellation after acceptance cannot revoke it. Ordering, retries, and delivery-failure reporting remain transport-defined but must be declared by every adapter. Publish a reusable transport contract-test kit before any broker adapter. Keep routing, partitioning, and TTL adopter-driven.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-004
- ATYA-033

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-060

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Document guaranteed-vs-transport-defined semantics in XML docs + README (Fable's behavioral spec)
3. add IAsyncDisposable subscription lifecycle compatibly
4. normalized message/contract identity + schema version
5. occurred/causation metadata with header normalization
6. Encode the PublishAsync acceptance boundary: success means transport responsibility under its declared durability class, not handler completion; mismatch and pre-acceptance cancellation fail, and post-acceptance cancellation cannot revoke success
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Messaging.Abstractions's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Add identity, metadata, disposal, and conformance surfaces compatibly where possible. The PublishAsync acceptance definition is binding; adapters that currently equate success with handler completion or leave the acceptance boundary ambiguous migrate in the 2.0 wave.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Kit run against InMemory..

## Documentation work

Update Messaging.Abstractions README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- The contract-test kit distinguishes pre-acceptance failure from accepted publication, proves that post-acceptance cancellation cannot revoke acceptance, and requires every adapter to declare durability, ordering, retry, and delivery-failure behavior; InMemory passes it; the identity scheme is consumed by ECO-058.

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
# Task-specific proof: Kit run against InMemory.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-059 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Evolve Messaging.Abstractions for stable, durable contracts. Document guaranteed-vs-transport-defined semantics in XML docs and the README (Fable's behavioral spec); add IAsyncDisposable subscription lifecycle compatibly; add normalized message/contract identity and schema version plus occurred/causation metadata with header normalization. Define successful PublishAsync completion as the transport accepting responsibility according to its declared durability class, not handler completion or end-to-end delivery: type/payload mismatch and caller cancellation fail before acceptance, while cancellation after acceptance cannot revoke it. Ordering, retries, and delivery-failure reporting remain transport-defined but must be declared by every adapter. Publish a reusable transport contract-test kit before any broker adapter. Keep routing, partitioning, and TTL adopter-driven.

Exact repository/package scope

Owning repository: Messaging.Abstractions. In scope: Messaging.Abstractions. Document guaranteed-vs-transport-defined semantics in XML docs and the README (Fable's behavioral spec); add IAsyncDisposable subscription lifecycle compatibly; add normalized message/contract identity and schema version plus occurred/causation metadata with header normalization. Define successful PublishAsync completion as the transport accepting responsibility according to its declared durability class, not handler completion or end-to-end delivery: type/payload mismatch and caller cancellation fail before acceptance, while cancellation after acceptance cannot revoke it. Ordering, retries, and delivery-failure reporting remain transport-defined but must be declared by every adapter. Publish a reusable transport contract-test kit before any broker adapter. Keep routing, partitioning, and TTL adopter-driven.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

The contract lacks delivery semantics (ordering, isolation, error propagation — InMemory's behavior is the accidental spec), stable contract/schema identity, occurred/causation metadata, and async-disposable subscriptions; type-erased publish doesn't enforce object/type agreement; the unused Foundation.Abstractions edge (removed via ECO-034).

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. The contract lacks delivery semantics (ordering, isolation, error propagation — InMemory's behavior is the accidental spec), stable contract/schema identity, occurred/causation metadata, and async-disposable subscriptions; type-erased publish doesn't enforce object/type agreement; the unused Foundation.Abstractions edge (removed via ECO-034).

Required outcome

Document guaranteed-vs-transport-defined semantics in XML docs and the README (Fable's behavioral spec); add IAsyncDisposable subscription lifecycle compatibly; add normalized message/contract identity and schema version plus occurred/causation metadata with header normalization. Define successful PublishAsync completion as the transport accepting responsibility according to its declared durability class, not handler completion or end-to-end delivery: type/payload mismatch and caller cancellation fail before acceptance, while cancellation after acceptance cannot revoke it. Ordering, retries, and delivery-failure reporting remain transport-defined but must be declared by every adapter. Publish a reusable transport contract-test kit before any broker adapter. Keep routing, partitioning, and TTL adopter-driven.

In scope

Messaging.Abstractions. Document guaranteed-vs-transport-defined semantics in XML docs and the README (Fable's behavioral spec); add IAsyncDisposable subscription lifecycle compatibly; add normalized message/contract identity and schema version plus occurred/causation metadata with header normalization. Define successful PublishAsync completion as the transport accepting responsibility according to its declared durability class, not handler completion or end-to-end delivery: type/payload mismatch and caller cancellation fail before acceptance, while cancellation after acceptance cannot revoke it. Ordering, retries, and delivery-failure reporting remain transport-defined but must be declared by every adapter. Publish a reusable transport contract-test kit before any broker adapter. Keep routing, partitioning, and TTL adopter-driven.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-004, ATYA-033.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Document guaranteed-vs-transport-defined semantics in XML docs + README (Fable's behavioral spec)
3. add IAsyncDisposable subscription lifecycle compatibly
4. normalized message/contract identity + schema version
5. occurred/causation metadata with header normalization
6. Encode the PublishAsync acceptance boundary: success means transport responsibility under its declared durability class, not handler completion; mismatch and pre-acceptance cancellation fail, and post-acceptance cancellation cannot revoke success
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Messaging.Abstractions's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Add identity, metadata, disposal, and conformance surfaces compatibly where possible. The PublishAsync acceptance definition is binding; adapters that currently equate success with handler completion or leave the acceptance boundary ambiguous migrate in the 2.0 wave.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Kit run against InMemory..

Documentation

Update Messaging.Abstractions README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Kit run against InMemory.
```

Acceptance criteria

- The contract-test kit distinguishes pre-acceptance failure from accepted publication, proves that post-acceptance cancellation cannot revoke acceptance, and requires every adapter to declare durability, ordering, retry, and delivery-failure behavior; InMemory passes it; the identity scheme is consumed by ECO-058.

Working rules

Use a focused branch linked to ATYA-059; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-123 — Implement the admitted EF Core outbox adapter behind provider conformance tests

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-123 |
| Owning repository | Messaging.Outbox |
| Priority | P2 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-084; ATYA-013 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Implementation split from SOL S-0068 and consolidated ECO-067/ECO-084 |
| Confidence | High |
| Risk | Medium |
| Effort | L |

## Problem description

After ATYA-084 admits a capability-specific EF Core outbox adapter, the provider implementation, durable repository placement, conformance fixtures, migrations, and honest delivery semantics still need a package-owned execution task.

## Root cause

The original ATYA-084 combined admission and implementation, leaving repository creation and code delivery before their governing decisions.

## Desired outcome

Implement exactly the adapter admitted by ATYA-084 in the topology accepted by ATYA-013; provide real-database fixtures for transaction enlistment, atomic claim/CAS, lease expiry, migrations, cancellation, and failure recovery; publish only after conformance; document at-least-once delivery plus consumer idempotency.

## In-scope work

Messaging.Outbox-owned implementation contract and the implementation home selected by ATYA-013/ATYA-084. If the accepted topology requires a durable new repository, create and bootstrap it here under ATYA-013 before code publication.

## Out-of-scope work

Reopening package admission, selecting a repository topology, generic EF conveniences, unsupported providers, or exactly-once marketing claims.

## Hard dependencies

- ATYA-084
- ATYA-013

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-058
- ATYA-061
- ATYA-087

## Implementation sequence

1. Read accepted ATYA-084 and ATYA-013; close as not planned if admission is rejected.
2. Create/select and bootstrap the authorized implementation home without inventing a topology.
3. Implement the admitted provider contract and migrations.
4. Add real-database conformance for transactions, atomic claim/CAS, fencing/expiry, cancellation, migration, and recovery.
5. Publish documentation and only then release the adapter.

## Architecture guidance

Messaging.Outbox is the primary contract owner. Repository placement follows ATYA-013; no architecture or admission decision is made in this implementation task.

## Compatibility and migration

Follow the provider/version matrix and migration ownership accepted in ATYA-084. Treat schema and public contract breaks according to the accepted release policy.

## Security and privacy considerations

Use least-privilege database credentials, parameterized access, bounded diagnostics, safe migration handling, redacted connection data, and adversarial concurrency tests.

## Testing strategy

Run the shared Outbox provider suite against a real supported database, including concurrent claims, stale owners, transaction rollback, lease expiry, cancellation, migration up/down or forward-recovery, and restart scenarios.

## Documentation work

Document provider setup/support, migrations, transaction boundaries, at-least-once delivery, consumer idempotency, diagnostics, recovery, and the ATYA-084/013 decisions.

## Measurable acceptance criteria

- The accepted provider conformance suite passes against a real database before publish.
- Repository/project placement exactly matches ATYA-013 and ATYA-084.
- Documentation never claims exactly-once and includes migration and recovery evidence.

## Definition of done

- Every ATYA-084 conformance/adopter gate passes.
- Package, tests, documentation, migration, security, and release evidence are complete.
- No architecture or admission decision remains in the implementation.

## Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: real-database provider conformance suite.
```

## Rollback strategy

Disable publication before release or revert the isolated adapter. After publication, ship forward fixes and reversible/forward-safe schema migrations; never rewrite packages or tags.

## Standalone implementation prompt

You are implementing ATYA-123 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Implement the admitted EF Core outbox adapter behind provider conformance tests. Implement exactly the adapter admitted by ATYA-084 in the topology accepted by ATYA-013; provide real-database fixtures for transaction enlistment, atomic claim/CAS, lease expiry, migrations, cancellation, and failure recovery; publish only after conformance; document at-least-once delivery plus consumer idempotency.

Exact repository/package scope

Owning repository: Messaging.Outbox. In scope: Messaging.Outbox-owned implementation contract and the implementation home selected by ATYA-013/ATYA-084. If the accepted topology requires a durable new repository, create and bootstrap it here under ATYA-013 before code publication.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

After ATYA-084 admits a capability-specific EF Core outbox adapter, the provider implementation, durable repository placement, conformance fixtures, migrations, and honest delivery semantics still need a package-owned execution task.

Root cause: The original ATYA-084 combined admission and implementation, leaving repository creation and code delivery before their governing decisions.

Required outcome

Implement exactly the adapter admitted by ATYA-084 in the topology accepted by ATYA-013; provide real-database fixtures for transaction enlistment, atomic claim/CAS, lease expiry, migrations, cancellation, and failure recovery; publish only after conformance; document at-least-once delivery plus consumer idempotency.

In scope

Messaging.Outbox-owned implementation contract and the implementation home selected by ATYA-013/ATYA-084. If the accepted topology requires a durable new repository, create and bootstrap it here under ATYA-013 before code publication.

Out of scope

Reopening package admission, selecting a repository topology, generic EF conveniences, unsupported providers, or exactly-once marketing claims.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-084, ATYA-013.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Read accepted ATYA-084 and ATYA-013; close as not planned if admission is rejected.
2. Create/select and bootstrap the authorized implementation home without inventing a topology.
3. Implement the admitted provider contract and migrations.
4. Add real-database conformance for transactions, atomic claim/CAS, fencing/expiry, cancellation, migration, and recovery.
5. Publish documentation and only then release the adapter.

Architecture constraints

Messaging.Outbox is the primary contract owner. Repository placement follows ATYA-013; no architecture or admission decision is made in this implementation task.

Compatibility and migration requirements

Follow the provider/version matrix and migration ownership accepted in ATYA-084. Treat schema and public contract breaks according to the accepted release policy.

Security and privacy requirements

Use least-privilege database credentials, parameterized access, bounded diagnostics, safe migration handling, redacted connection data, and adversarial concurrency tests.

Tests

Run the shared Outbox provider suite against a real supported database, including concurrent claims, stale owners, transaction rollback, lease expiry, cancellation, migration up/down or forward-recovery, and restart scenarios.

Documentation

Document provider setup/support, migrations, transaction boundaries, at-least-once delivery, consumer idempotency, diagnostics, recovery, and the ATYA-084/013 decisions.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: real-database provider conformance suite.
```

Acceptance criteria

- The accepted provider conformance suite passes against a real database before publish.
- Repository/project placement exactly matches ATYA-013 and ATYA-084.
- Documentation never claims exactly-once and includes migration and recovery evidence.

Working rules

Use a focused branch linked to ATYA-123; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 6 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

# ATYA-146 — Redact upstream exception messages before persisting them in the outbox

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-146 |
| Owning repository | Messaging.Outbox |
| Priority | P2 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-058; ATYA-112 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Verified from repository source during the Opus 5 delta review (2026-07-26); cited file paths and line references are recorded in the task body. |
| Origin | Opus 5 delta review (O5-15) |
| Confidence | High |
| Risk | Medium |
| Effort | S |

## Problem description

`Messaging/Messaging.Outbox/src/Outbox/OutboxRelay.cs` PublishPendingAsync catches every non-cancellation exception and calls `_store.MarkFailedAsync(message.Id, …, ex.Message, terminal, …)`. `ex.Message` from a transport client is frequently a connection string, a broker URI with embedded credentials, a SQL fragment, or a broker response containing message content. That string is then written to a durable store — a database table an operator, a read-replica consumer, a backup, or an analytics pipeline can read — and `OutboxMessage.LastError` exposes it on a public API surface with no length bound. The ecosystem already applies a redaction policy to the HTTP error surface (ATYA-014 for 5xx ProblemDetails, ATYA-015 for health responses); the durable failure surface has none.

## Root cause

Third-party exception text was treated as a diagnostic string rather than as untrusted data entering durable storage.

## Desired outcome

Durable failure records carry a bounded, sanitized description; full exception detail stays in the log pipeline where redaction and retention policy already apply.

## Affected scope

Primary owner: **Messaging.Outbox**. Package: `Atya.Messaging.Outbox`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Messaging.Outbox. Durable failure records carry a bounded, sanitized description; full exception detail stays in the log pipeline where redaction and retention policy already apply.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-058
- ATYA-112

## Advisory prerequisites

None.

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-014
- ATYA-015

## Implementation sequence

1. Introduce a `Func<Exception, string>` failure-description policy on the relay, defaulting to a safe projection: exception type name plus a bounded (for example 512-character) sanitized message and a correlation handle for the full detail.
2. Log the full exception through ILogger rather than persisting it.
3. Bound OutboxMessage.LastError length at construction.
4. Add tests asserting a connection-string-bearing exception message never reaches LastError and that the length bound holds.
5. Reference the data-classification model from ATYA-112 for what must be redacted.

## Architecture guidance

Durable stores are a data-classification boundary. What crosses into them is an explicit policy decision, not an incidental string copy.

## Compatibility and migration

Non-breaking if the default policy is applied at write time and LastError keeps its type. ATYA-058's NextAttemptAt/backoff schema change touches the same records — perform one migration, not two.

## Security and privacy considerations

Removes durable, long-retention storage of unredacted third-party exception text containing credentials or message content, and bounds an unbounded externally-controlled field.

## Testing strategy

Hostile-exception corpus (connection string, SQL fragment, oversized message) asserting redaction and bounding.

## Documentation work

Document the default failure-description policy, how to override it, and where full detail is available.

## Measurable acceptance criteria

- An exception whose message contains a connection string produces a LastError with no credential material.
- LastError is bounded to the configured maximum length.
- The full exception is written to ILogger with its correlation handle.
- The policy is overridable and its default is documented.

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
# Task-specific proof: Hostile-exception corpus asserting no credential material reaches LastError.
dotnet test -c Release --filter FullyQualifiedName~FailureRedaction
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-146 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Redact upstream exception messages before persisting them in the outbox. Durable failure records carry a bounded, sanitized description; full exception detail stays in the log pipeline where redaction and retention policy already apply.

Exact repository/package scope

Owning repository: Messaging.Outbox. In scope: `Atya.Messaging.Outbox` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

`Messaging/Messaging.Outbox/src/Outbox/OutboxRelay.cs` PublishPendingAsync catches every non-cancellation exception and calls `_store.MarkFailedAsync(message.Id, …, ex.Message, terminal, …)`. `ex.Message` from a transport client is frequently a connection string, a broker URI with embedded credentials, a SQL fragment, or a broker response containing message content. That string is then written to a durable store — a database table an operator, a read-replica consumer, a backup, or an analytics pipeline can read — and `OutboxMessage.LastError` exposes it on a public API surface with no length bound. The ecosystem already applies a redaction policy to the HTTP error surface (ATYA-014 for 5xx ProblemDetails, ATYA-015 for health responses); the durable failure surface has none.

Root cause: Third-party exception text was treated as a diagnostic string rather than as untrusted data entering durable storage.

Required outcome

Durable failure records carry a bounded, sanitized description; full exception detail stays in the log pipeline where redaction and retention policy already apply.

Blockers and dependencies

Blocked until these complete: ATYA-058, ATYA-112.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Introduce a `Func<Exception, string>` failure-description policy on the relay, defaulting to a safe projection: exception type name plus a bounded (for example 512-character) sanitized message and a correlation handle for the full detail.
2. Log the full exception through ILogger rather than persisting it.
3. Bound OutboxMessage.LastError length at construction.
4. Add tests asserting a connection-string-bearing exception message never reaches LastError and that the length bound holds.
5. Reference the data-classification model from ATYA-112 for what must be redacted.

Architecture constraints

Durable stores are a data-classification boundary. What crosses into them is an explicit policy decision, not an incidental string copy.

Compatibility and migration requirements

Non-breaking if the default policy is applied at write time and LastError keeps its type. ATYA-058's NextAttemptAt/backoff schema change touches the same records — perform one migration, not two.

Security and privacy requirements

Removes durable, long-retention storage of unredacted third-party exception text containing credentials or message content, and bounds an unbounded externally-controlled field.

Tests

Hostile-exception corpus (connection string, SQL fragment, oversized message) asserting redaction and bounding.

Documentation

Document the default failure-description policy, how to override it, and where full detail is available.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Hostile-exception corpus asserting no credential material reaches LastError.
dotnet test -c Release --filter FullyQualifiedName~FailureRedaction
```

Acceptance criteria

- An exception whose message contains a connection string produces a LastError with no credential material.
- LastError is bounded to the configured maximum length.
- The full exception is written to ILogger with its correlation handle.
- The policy is overridable and its default is documented.

Working rules

Use a focused branch linked to ATYA-146; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

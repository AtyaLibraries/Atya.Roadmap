# ATYA-058 — Outbox: atomic claiming, stable identity, backoff, diagnostics, hosting recipe

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-058 |
| Owning repository | Messaging.Outbox |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-059; ATYA-057; ATYA-006 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0027 + S-0036 + S-0037) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

LoadPendingAsync reportedly just reads rows — concurrent relays duplicate sends (no claim/lease/fencing/CAS); stored identity is AssemblyQualifiedName resolved via Type.GetType (version-fragile, deserialization hazard); failed messages are immediately re-eligible (no NextAttemptAt/backoff — a poison message burns every cycle); only ex.Message persisted; no bridge to BackgroundServices (every consumer hand-writes the relay host); at-least-once window undocumented.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. LoadPendingAsync reportedly just reads rows — concurrent relays duplicate sends (no claim/lease/fencing/CAS); stored identity is AssemblyQualifiedName resolved via Type.GetType (version-fragile, deserialization hazard); failed messages are immediately re-eligible (no NextAttemptAt/backoff — a poison message burns every cycle); only ex.Message persisted; no bridge to BackgroundServices (every consumer hand-writes the relay host); at-least-once window undocumented.

## Desired outcome

Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions; contract-name/schema-version identity with resolver/upcaster registry (replace AQN); NextAttemptAt with bounded exponential backoff+jitter and terminal classification; sanitized richer failure diagnostics (type + truncated stack); crash-after-send specified as at-least-once with the Idempotency pairing guide; relay host shipped as a PeriodicBackgroundService-based sample + README recipe, not a package (CC-27); provider conformance suite (claim races, expiry, stale acks, cancellation, transaction enlistment).

## In-scope work

Messaging.Outbox (contract-breaking). Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions; contract-name/schema-version identity with resolver/upcaster registry (replace AQN); NextAttemptAt with bounded exponential backoff+jitter and terminal classification; sanitized richer failure diagnostics (type + truncated stack); crash-after-send specified as at-least-once with the Idempotency pairing guide; relay host shipped as a PeriodicBackgroundService-based sample + README recipe, not a package (CC-27); provider conformance suite (claim races, expiry, stale acks, cancellation, transaction enlistment).

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-059
- ATYA-057
- ATYA-006

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-059
- ATYA-060

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions
3. contract-name/schema-version identity with resolver/upcaster registry (replace AQN)
4. NextAttemptAt with bounded exponential backoff+jitter and terminal classification
5. sanitized richer failure diagnostics (type + truncated stack)
6. crash-after-send specified as at-least-once with the Idempotency pairing guide
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Messaging.Outbox's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Breaking; 2.0 wave; until a durable provider passes the suite, label the package "outbox contracts/relay with a test store" (GPT's honesty rule).

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Multi-relay concurrency suite..

## Documentation work

Update Messaging.Outbox README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Two concurrent relays never double-publish in the race test; poison message respects backoff schedule; no AQN appears in stored rows; recipe compiles and runs in the sample.

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
# Task-specific proof: Multi-relay concurrency suite.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-058 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Outbox: atomic claiming, stable identity, backoff, diagnostics, hosting recipe. Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions; contract-name/schema-version identity with resolver/upcaster registry (replace AQN); NextAttemptAt with bounded exponential backoff+jitter and terminal classification; sanitized richer failure diagnostics (type + truncated stack); crash-after-send specified as at-least-once with the Idempotency pairing guide; relay host shipped as a PeriodicBackgroundService-based sample + README recipe, not a package (CC-27); provider conformance suite (claim races, expiry, stale acks, cancellation, transaction enlistment).

Exact repository/package scope

Owning repository: Messaging.Outbox. In scope: Messaging.Outbox (contract-breaking). Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions; contract-name/schema-version identity with resolver/upcaster registry (replace AQN); NextAttemptAt with bounded exponential backoff+jitter and terminal classification; sanitized richer failure diagnostics (type + truncated stack); crash-after-send specified as at-least-once with the Idempotency pairing guide; relay host shipped as a PeriodicBackgroundService-based sample + README recipe, not a package (CC-27); provider conformance suite (claim races, expiry, stale acks, cancellation, transaction enlistment).

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

LoadPendingAsync reportedly just reads rows — concurrent relays duplicate sends (no claim/lease/fencing/CAS); stored identity is AssemblyQualifiedName resolved via Type.GetType (version-fragile, deserialization hazard); failed messages are immediately re-eligible (no NextAttemptAt/backoff — a poison message burns every cycle); only ex.Message persisted; no bridge to BackgroundServices (every consumer hand-writes the relay host); at-least-once window undocumented.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. LoadPendingAsync reportedly just reads rows — concurrent relays duplicate sends (no claim/lease/fencing/CAS); stored identity is AssemblyQualifiedName resolved via Type.GetType (version-fragile, deserialization hazard); failed messages are immediately re-eligible (no NextAttemptAt/backoff — a poison message burns every cycle); only ex.Message persisted; no bridge to BackgroundServices (every consumer hand-writes the relay host); at-least-once window undocumented.

Required outcome

Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions; contract-name/schema-version identity with resolver/upcaster registry (replace AQN); NextAttemptAt with bounded exponential backoff+jitter and terminal classification; sanitized richer failure diagnostics (type + truncated stack); crash-after-send specified as at-least-once with the Idempotency pairing guide; relay host shipped as a PeriodicBackgroundService-based sample + README recipe, not a package (CC-27); provider conformance suite (claim races, expiry, stale acks, cancellation, transaction enlistment).

In scope

Messaging.Outbox (contract-breaking). Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions; contract-name/schema-version identity with resolver/upcaster registry (replace AQN); NextAttemptAt with bounded exponential backoff+jitter and terminal classification; sanitized richer failure diagnostics (type + truncated stack); crash-after-send specified as at-least-once with the Idempotency pairing guide; relay host shipped as a PeriodicBackgroundService-based sample + README recipe, not a package (CC-27); provider conformance suite (claim races, expiry, stale acks, cancellation, transaction enlistment).

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-059, ATYA-057, ATYA-006.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Store contract redesigned around atomic batch claim with owner/token, visibility timeout, renewal, CAS published/failed transitions
3. contract-name/schema-version identity with resolver/upcaster registry (replace AQN)
4. NextAttemptAt with bounded exponential backoff+jitter and terminal classification
5. sanitized richer failure diagnostics (type + truncated stack)
6. crash-after-send specified as at-least-once with the Idempotency pairing guide
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Messaging.Outbox's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Breaking; 2.0 wave; until a durable provider passes the suite, label the package "outbox contracts/relay with a test store" (GPT's honesty rule).

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Multi-relay concurrency suite..

Documentation

Update Messaging.Outbox README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Multi-relay concurrency suite.
```

Acceptance criteria

- Two concurrent relays never double-publish in the race test; poison message respects backoff schedule; no AQN appears in stored rows; recipe compiles and runs in the sample.

Working rules

Use a focused branch linked to ATYA-058; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

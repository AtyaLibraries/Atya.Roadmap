# ATYA-064 — Mediator notifications: feature or ratified non-goal

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-064 |
| Owning repository | Mediator |
| Priority | P2 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | ADR |
| Initial status | Blocked |
| Hard dependencies | ATYA-063 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0025) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

No INotification/publish; MediatR migrators hit it immediately; the migration guide is silent.

## Root cause

The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. No INotification/publish; MediatR migrators hit it immediately; the migration guide is silent.

## Desired outcome

Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide; revisit on demand evidence (BM-02 intake).

## In-scope work

Application.Mediator docs (or feature). Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide; revisit on demand evidence (BM-02 intake).

## Out-of-scope work

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

## Hard dependencies

- ATYA-063

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Measure the current alternatives and capture representative consumer constraints.
2. Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide
3. revisit on demand evidence (BM-02 intake).
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

## Compatibility and migration

None (docs) unless the feature is later admitted.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Guide example compiles..

## Documentation work

Update Mediator README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Migration guide answers the notification question explicitly with a runnable pattern.

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
# Task-specific proof: Guide example compiles.
```

## Rollback strategy

Supersede the ADR with a new decision record; do not rewrite decision history. Revert generated policy consumers if adoption exposes an invalid premise.

## Standalone implementation prompt

You are implementing ATYA-064 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Mediator notifications: feature or ratified non-goal. Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide; revisit on demand evidence (BM-02 intake).

Exact repository/package scope

Owning repository: Mediator. In scope: Application.Mediator docs (or feature). Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide; revisit on demand evidence (BM-02 intake).

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

No INotification/publish; MediatR migrators hit it immediately; the migration guide is silent.

Root cause: The governing choice was never made explicit, so repositories and consumers evolved incompatible assumptions. No INotification/publish; MediatR migrators hit it immediately; the migration guide is silent.

Required outcome

Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide; revisit on demand evidence (BM-02 intake).

In scope

Application.Mediator docs (or feature). Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide; revisit on demand evidence (BM-02 intake).

Out of scope

Implementation before the decision is accepted; unrelated package redesign; unrecorded exceptions.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-063.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Measure the current alternatives and capture representative consumer constraints.
2. Recommend the documented non-goal first (Fable): official pattern = in-process fan-out via Messaging.InMemory consumers, worked example in the migration guide
3. revisit on demand evidence (BM-02 intake).
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Record options, decision drivers, rejected alternatives, compatibility impact, and a reversible adoption plan. The ADR is authoritative; dependent code must not pre-empt it.

Compatibility and migration requirements

None (docs) unless the feature is later admitted.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Guide example compiles..

Documentation

Update Mediator README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Guide example compiles.
```

Acceptance criteria

- Migration guide answers the notification question explicitly with a runnable pattern.

Working rules

Use a focused branch linked to ATYA-064; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

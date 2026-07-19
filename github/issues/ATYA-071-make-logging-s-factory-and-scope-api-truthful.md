# ATYA-071 — Make Logging's factory and scope API truthful

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-071 |
| Owning repository | Logging |
| Priority | P2 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-033; ATYA-068 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0057) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

Public scope extensions reportedly instantiate LogScopeState directly, so the registered ILogScopeStateFactory has no effect; whitespace keys silently discarded; convenience paths double-copy; event-ID ownership undocumented; stale doc links.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Public scope extensions reportedly instantiate LogScopeState directly, so the registered ILogScopeStateFactory has no effect; whitespace keys silently discarded; convenience paths double-copy; event-ID ownership undocumented; stale doc links.

## Desired outcome

Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction; reject malformed keys; add low-allocation fixed-arity paths and an event-ID range policy; add replacement-factory, malformed-key, and allocation tests; fix stale docs.

## In-scope work

Diagnostics.Logging. Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction; reject malformed keys; add low-allocation fixed-arity paths and an event-ID range policy; add replacement-factory, malformed-key, and allocation tests; fix stale docs.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-033
- ATYA-068

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction
3. reject malformed keys
4. low-allocation fixed-arity paths
5. event-ID range policy
6. replacement-factory/malformed-key/allocation tests
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Logging's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Retain the factory contract and treat routing through it as the corrective change; do not remove the abstraction in this task. Any future removal requires a separate accepted ADR and major-version migration task.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Provider integration test..

## Documentation work

Update Logging README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Replacing the registered factory observably changes every public scope-construction path; the factory abstraction remains public; malformed keys are rejected loudly.

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
# Task-specific proof: Provider integration test.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-071 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Make Logging's factory and scope API truthful. Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction; reject malformed keys; add low-allocation fixed-arity paths and an event-ID range policy; add replacement-factory, malformed-key, and allocation tests; fix stale docs.

Exact repository/package scope

Owning repository: Logging. In scope: Diagnostics.Logging. Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction; reject malformed keys; add low-allocation fixed-arity paths and an event-ID range policy; add replacement-factory, malformed-key, and allocation tests; fix stale docs.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Public scope extensions reportedly instantiate LogScopeState directly, so the registered ILogScopeStateFactory has no effect; whitespace keys silently discarded; convenience paths double-copy; event-ID ownership undocumented; stale doc links.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Public scope extensions reportedly instantiate LogScopeState directly, so the registered ILogScopeStateFactory has no effect; whitespace keys silently discarded; convenience paths double-copy; event-ID ownership undocumented; stale doc links.

Required outcome

Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction; reject malformed keys; add low-allocation fixed-arity paths and an event-ID range policy; add replacement-factory, malformed-key, and allocation tests; fix stale docs.

In scope

Diagnostics.Logging. Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction; reject malformed keys; add low-allocation fixed-arity paths and an event-ID range policy; add replacement-factory, malformed-key, and allocation tests; fix stale docs.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-033, ATYA-068.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Route every public scope-construction path through the registered ILogScopeStateFactory and retain the abstraction
3. reject malformed keys
4. low-allocation fixed-arity paths
5. event-ID range policy
6. replacement-factory/malformed-key/allocation tests
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Logging's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Retain the factory contract and treat routing through it as the corrective change; do not remove the abstraction in this task. Any future removal requires a separate accepted ADR and major-version migration task.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Provider integration test..

Documentation

Update Logging README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Provider integration test.
```

Acceptance criteria

- Replacing the registered factory observably changes every public scope-construction path; the factory abstraction remains public; malformed keys are rejected loudly.

Working rules

Use a focused branch linked to ATYA-071; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

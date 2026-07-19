# ATYA-062 — Fix Mediator generator discovery, lifetimes, and packed-analyzer verification

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-062 |
| Owning repository | Mediator |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-002; ATYA-033 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (S-0049 + S-0050) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

The generator reportedly considers only ClassDeclarationSyntax (record handlers silently omitted) and returns after the first handler interface (multi-request handlers get one interface-order-dependent registration); scoped mediator captures transient dispatchers; the sample project-references the generator instead of proving the packed nupkg.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. The generator reportedly considers only ClassDeclarationSyntax (record handlers silently omitted) and returns after the first handler interface (multi-request handlers get one interface-order-dependent registration); scoped mediator captures transient dispatchers; the sample project-references the generator instead of proving the packed nupkg.

## Desired outcome

Include record classes; emit one deterministic registration per closed handler interface; diagnose unsupported, open, and ambiguous shapes; resolve each handler once per Send from the current DI scope and leave disposal to that scope's container without creating a child scope; add compile-time tests for records, multiple interfaces, duplicates, nested/generic/accessibility cases, and deterministic output; add a pack→install→build smoke test consuming only the nupkg per supported TFM. Keep dispatcher plumbing and boxing compatibility unchanged; any future breaking internalization requires a separate benchmark-backed ADR.

## In-scope work

Application.Mediator (+SourceGeneration). Include record classes; emit one deterministic registration per closed handler interface; diagnose unsupported, open, and ambiguous shapes; resolve each handler once per Send from the current DI scope and leave disposal to that scope's container without creating a child scope; add compile-time tests for records, multiple interfaces, duplicates, nested/generic/accessibility cases, and deterministic output; add a pack→install→build smoke test consuming only the nupkg per supported TFM. Dispatcher plumbing and boxing compatibility remain unchanged in this task.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-002
- ATYA-033

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Include record classes
3. one deterministic registration per closed handler interface
4. diagnostics for unsupported/open/ambiguous shapes
5. Resolve each handler once per Send from the current DI scope; do not create a child scope or manually dispose handlers because the current scope's container owns disposal
6. Add compile-time fixtures and a pack→install→build smoke test per supported TFM; keep dispatcher plumbing and boxing compatibility unchanged
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Mediator's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Generator fixes are behavior-correcting because previously missing registrations appear; document them in release notes. Per-Send resolution uses the caller's current DI scope and preserves container-owned disposal. Dispatcher plumbing and boxing compatibility do not change in this task.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-04 fixtures post-fix..

## Documentation work

Update Mediator README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- A record handler and a two-interface handler both register; a packed-nupkg consumer builds and dispatches; each Send resolves its handler once from the current scope; no child scope or manual handler disposal occurs; the container disposes scoped handlers at scope end.

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
# Task-specific proof: SP-04 fixtures post-fix.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-062 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Fix Mediator generator discovery, lifetimes, and packed-analyzer verification. Include record classes; emit one deterministic registration per closed handler interface; diagnose unsupported, open, and ambiguous shapes; resolve each handler once per Send from the current DI scope and leave disposal to that scope's container without creating a child scope; add compile-time tests for records, multiple interfaces, duplicates, nested/generic/accessibility cases, and deterministic output; add a pack→install→build smoke test consuming only the nupkg per supported TFM. Keep dispatcher plumbing and boxing compatibility unchanged; any future breaking internalization requires a separate benchmark-backed ADR.

Exact repository/package scope

Owning repository: Mediator. In scope: Application.Mediator (+SourceGeneration). Include record classes; emit one deterministic registration per closed handler interface; diagnose unsupported, open, and ambiguous shapes; resolve each handler once per Send from the current DI scope and leave disposal to that scope's container without creating a child scope; add compile-time tests for records, multiple interfaces, duplicates, nested/generic/accessibility cases, and deterministic output; add a pack→install→build smoke test consuming only the nupkg per supported TFM. Dispatcher plumbing and boxing compatibility remain unchanged in this task.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

The generator reportedly considers only ClassDeclarationSyntax (record handlers silently omitted) and returns after the first handler interface (multi-request handlers get one interface-order-dependent registration); scoped mediator captures transient dispatchers; the sample project-references the generator instead of proving the packed nupkg.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. The generator reportedly considers only ClassDeclarationSyntax (record handlers silently omitted) and returns after the first handler interface (multi-request handlers get one interface-order-dependent registration); scoped mediator captures transient dispatchers; the sample project-references the generator instead of proving the packed nupkg.

Required outcome

Include record classes; emit one deterministic registration per closed handler interface; diagnose unsupported, open, and ambiguous shapes; resolve each handler once per Send from the current DI scope and leave disposal to that scope's container without creating a child scope; add compile-time tests for records, multiple interfaces, duplicates, nested/generic/accessibility cases, and deterministic output; add a pack→install→build smoke test consuming only the nupkg per supported TFM. Keep dispatcher plumbing and boxing compatibility unchanged; any future breaking internalization requires a separate benchmark-backed ADR.

In scope

Application.Mediator (+SourceGeneration). Include record classes; emit one deterministic registration per closed handler interface; diagnose unsupported, open, and ambiguous shapes; resolve each handler once per Send from the current DI scope and leave disposal to that scope's container without creating a child scope; add compile-time tests for records, multiple interfaces, duplicates, nested/generic/accessibility cases, and deterministic output; add a pack→install→build smoke test consuming only the nupkg per supported TFM. Dispatcher plumbing and boxing compatibility remain unchanged in this task.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-002, ATYA-033.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Include record classes
3. one deterministic registration per closed handler interface
4. diagnostics for unsupported/open/ambiguous shapes
5. Resolve each handler once per Send from the current DI scope; do not create a child scope or manually dispose handlers because the current scope's container owns disposal
6. Add compile-time fixtures and a pack→install→build smoke test per supported TFM; keep dispatcher plumbing and boxing compatibility unchanged
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Mediator's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Generator fixes are behavior-correcting because previously missing registrations appear; document them in release notes. Per-Send resolution uses the caller's current DI scope and preserves container-owned disposal. Dispatcher plumbing and boxing compatibility do not change in this task.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: SP-04 fixtures post-fix..

Documentation

Update Mediator README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: SP-04 fixtures post-fix.
```

Acceptance criteria

- A record handler and a two-interface handler both register; a packed-nupkg consumer builds and dispatches; each Send resolves its handler once from the current scope; no child scope or manual handler disposal occurs; the container disposes scoped handlers at scope end.

Working rules

Use a focused branch linked to ATYA-062; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

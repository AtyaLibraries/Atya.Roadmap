# ATYA-077 — Make UiAutomation profile options real or remove them

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-077 |
| Owning repository | Atya.Templates.UiAutomation |
| Priority | P1 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Migration |
| Initial status | Blocked |
| Hard dependencies | ATYA-025; ATYA-026; ATYA-036 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0060) |
| Confidence | High |
| Risk | High |
| Effort | L |

## Problem description

Headless/Video reportedly loaded but never applied; other advertised viewport/timeout/locale fields unbound; generated docs reference excluded/nonexistent files.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Headless/Video reportedly loaded but never applied; other advertised viewport/timeout/locale fields unbound; generated docs reference excluded/nonexistent files.

## Desired outcome

Bind every supported field through Playwright launch/context/capture or delete the option; video retention semantics; browser-level option tests + invalid-config cases; ship every referenced doc; state the Azure-vs-GitHub workflow choice. Remove the SOURCE_SOLUTION/root-csproj workaround only after the ATYA-036 action is released and prove the template packs without it.

## Affected scope

Primary owner: **Atya.Templates.UiAutomation**. Audit-affected repositories or coordination scopes: Atya.Templates.UiAutomation. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Templates.UiAutomation. Bind every supported field through Playwright launch/context/capture or delete the option; video retention semantics; browser-level option tests + invalid-config cases; ship every referenced doc; state the Azure-vs-GitHub workflow choice. Includes the UiAutomation-owned migration off the ATYA-036 workaround.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-025
- ATYA-026
- ATYA-036

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-073
- ATYA-074
- ATYA-075

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Bind every supported field through Playwright launch/context/capture or delete the option
3. video retention semantics
4. browser-level option tests + invalid-config cases
5. ship every referenced doc
6. state the Azure-vs-GitHub workflow choice.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Atya.Templates.UiAutomation's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Template-only.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Option-effect tests..

## Documentation work

Update Atya.Templates.UiAutomation README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Every advertised profile field observably changes behavior in a test, or no longer exists.
- The packed UiAutomation template succeeds through the released ATYA-036 action with no SOURCE_SOLUTION workaround.

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
# Task-specific proof: Option-effect tests.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-077 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Make UiAutomation profile options real or remove them. Bind every supported field through Playwright launch/context/capture or delete the option; video retention semantics; browser-level option tests + invalid-config cases; ship every referenced doc; state the Azure-vs-GitHub workflow choice. Remove the SOURCE_SOLUTION/root-csproj workaround only after the ATYA-036 action is released and prove the template packs without it.

Exact repository/package scope

Owning repository: Atya.Templates.UiAutomation. Primary owner: **Atya.Templates.UiAutomation**. Audit-affected repositories or coordination scopes: Atya.Templates.UiAutomation. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Headless/Video reportedly loaded but never applied; other advertised viewport/timeout/locale fields unbound; generated docs reference excluded/nonexistent files.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Headless/Video reportedly loaded but never applied; other advertised viewport/timeout/locale fields unbound; generated docs reference excluded/nonexistent files.

Required outcome

Bind every supported field through Playwright launch/context/capture or delete the option; video retention semantics; browser-level option tests + invalid-config cases; ship every referenced doc; state the Azure-vs-GitHub workflow choice. Remove the SOURCE_SOLUTION/root-csproj workaround only after the ATYA-036 action is released and prove the template packs without it.

In scope

Atya.Templates.UiAutomation. Bind every supported field through Playwright launch/context/capture or delete the option; video retention semantics; browser-level option tests + invalid-config cases; ship every referenced doc; state the Azure-vs-GitHub workflow choice. Includes the UiAutomation-owned migration off the ATYA-036 workaround.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-025, ATYA-026, ATYA-036.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Bind every supported field through Playwright launch/context/capture or delete the option
3. video retention semantics
4. browser-level option tests + invalid-config cases
5. ship every referenced doc
6. state the Azure-vs-GitHub workflow choice.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Atya.Templates.UiAutomation's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Template-only.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Option-effect tests..

Documentation

Update Atya.Templates.UiAutomation README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

# ATYA-076 — Verify the NuGet template from its packed artifact

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-076 |
| Owning repository | Atya.Templates.NuGetPackage |
| Priority | P1 |
| Phase | 6 — Migration, documentation, templates, and adoption |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-017; ATYA-026; ATYA-030 |
| Advisory prerequisites | None |
| Implementation state | Partially satisfied |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0059) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Template CI installs the source directory, not the nupkg; generated docs unconditionally mention optional features; smoke assertions previously enforced mutable refs.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Template CI installs the source directory, not the nupkg; generated docs unconditionally mention optional features; smoke assertions previously enforced mutable refs.

## Desired outcome

Pack → fresh-hive install → generate prefixed/unprefixed + feature variants → locked restore/build/test/pack on both OSes; assert SHA-pinned generated workflows, conditional README content, package contents, placeholder removal; keep the strong symbol/GUID matrix.

## Affected scope

Primary owner: **Atya.Templates.NuGetPackage**. Audit-affected repositories or coordination scopes: Atya.Templates.NuGetPackage, AtyaLibraries, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Templates.NuGetPackage. Pack → fresh-hive install → generate prefixed/unprefixed + feature variants → locked restore/build/test/pack on both OSes; assert SHA-pinned generated workflows, conditional README content, package contents, placeholder removal; keep the strong symbol/GUID matrix.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-017
- ATYA-026
- ATYA-030

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-017
- ATYA-073
- ATYA-074

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Pack → fresh-hive install → generate prefixed/unprefixed + feature variants → locked restore/build/test/pack on both OSes
3. assert SHA-pinned generated workflows, conditional README content, package contents, placeholder removal
4. keep the strong symbol/GUID matrix.
5. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Atya.Templates.NuGetPackage's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

None.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fresh-hive matrix in CI..

## Documentation work

Update Atya.Templates.NuGetPackage README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- CI proves the packed template end-to-end for every variant.

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
# Task-specific proof: Fresh-hive matrix in CI.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-076 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Verify the NuGet template from its packed artifact. Pack → fresh-hive install → generate prefixed/unprefixed + feature variants → locked restore/build/test/pack on both OSes; assert SHA-pinned generated workflows, conditional README content, package contents, placeholder removal; keep the strong symbol/GUID matrix.

Exact repository/package scope

Owning repository: Atya.Templates.NuGetPackage. Primary owner: **Atya.Templates.NuGetPackage**. Audit-affected repositories or coordination scopes: Atya.Templates.NuGetPackage, AtyaLibraries, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Template CI installs the source directory, not the nupkg; generated docs unconditionally mention optional features; smoke assertions previously enforced mutable refs.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Template CI installs the source directory, not the nupkg; generated docs unconditionally mention optional features; smoke assertions previously enforced mutable refs.

Required outcome

Pack → fresh-hive install → generate prefixed/unprefixed + feature variants → locked restore/build/test/pack on both OSes; assert SHA-pinned generated workflows, conditional README content, package contents, placeholder removal; keep the strong symbol/GUID matrix.

In scope

Atya.Templates.NuGetPackage. Pack → fresh-hive install → generate prefixed/unprefixed + feature variants → locked restore/build/test/pack on both OSes; assert SHA-pinned generated workflows, conditional README content, package contents, placeholder removal; keep the strong symbol/GUID matrix.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-017, ATYA-026, ATYA-030.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Pack → fresh-hive install → generate prefixed/unprefixed + feature variants → locked restore/build/test/pack on both OSes
3. assert SHA-pinned generated workflows, conditional README content, package contents, placeholder removal
4. keep the strong symbol/GUID matrix.
5. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
6. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Atya.Templates.NuGetPackage's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

None.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fresh-hive matrix in CI..

Documentation

Update Atya.Templates.NuGetPackage README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

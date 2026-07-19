# ATYA-030 — Build Atya.Build.Sdk conformance fixtures (archetype-aware)

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-030 |
| Owning repository | Atya.Build.Sdk |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Verification |
| Initial status | Blocked |
| Hard dependencies | ATYA-027; ATYA-005; ATYA-025 |
| Advisory prerequisites | None |
| Implementation state | No audit-driven completion claim |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0015) |
| Confidence | High |
| Risk | High |
| Effort | S |

## Problem description

The SDK claims more than its targets enforce; warnings-as-errors is less overrideable than documented; broad AtyaDisable* escape hatches ungoverned; effectively no negative tests for property precedence, CPM conflicts, packed contents, metadata validation.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. The SDK claims more than its targets enforce; warnings-as-errors is less overrideable than documented; broad AtyaDisable* escape hatches ungoverned; effectively no negative tests for property precedence, CPM conflicts, packed contents, metadata validation.

## Desired outcome

Archetype profiles + fixtures: property precedence, opt-outs (narrow, named, CI-reported), TFM rules, Authors/Company/tags, missing Git metadata, locked restore, CPM conflicts, analyzer/test injection, nupkg/snupkg contents, SourceLink, multi-target packs; replace string-matching tests with evaluated MSBuild/package inspection; delete the dead RepositoryHasGitDirectory property (CC-39); update the stale README. Consume the released ATYA-025 CodeQuality analyzer in a Build.Sdk fixture and prove its diagnostic contract before fleet rollout.

## Affected scope

Primary owner: **Atya.Build.Sdk**. Audit-affected repositories or coordination scopes: Atya.Build.Sdk, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Build.Sdk. Archetype profiles + fixtures: property precedence, opt-outs (narrow, named, CI-reported), TFM rules, Authors/Company/tags, missing Git metadata, locked restore, CPM conflicts, analyzer/test injection, nupkg/snupkg contents, SourceLink, multi-target packs; replace string-matching tests with evaluated MSBuild/package inspection; delete the dead RepositoryHasGitDirectory property (CC-39); update the stale README. Includes the Build.Sdk-owned packed-consumer adoption proof for ATYA-025.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-027
- ATYA-005
- ATYA-025

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-027

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Archetype profiles + fixtures: property precedence, opt-outs (narrow, named, CI-reported), TFM rules, Authors/Company/tags, missing Git metadata, locked restore, CPM conflicts, analyzer/test injection, nupkg/snupkg contents, SourceLink, multi-target packs
3. replace string-matching tests with evaluated MSBuild/package inspection
4. delete the dead RepositoryHasGitDirectory property (CC-39)
5. update the stale README.
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Atya.Build.Sdk's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Fixture-driven; any tightened enforcement release-noted.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fixture matrix on both OSes..

## Documentation work

Update Atya.Build.Sdk README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Negative fixtures fail for each documented rule; opt-out use is enumerated in CI output.
- A Build.Sdk consumer fixture loads the released ATYA-025 analyzer with the expected diagnostic IDs/severities and no AD0001.

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
# Task-specific proof: Fixture matrix on both OSes.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-030 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Build Atya.Build.Sdk conformance fixtures (archetype-aware). Archetype profiles + fixtures: property precedence, opt-outs (narrow, named, CI-reported), TFM rules, Authors/Company/tags, missing Git metadata, locked restore, CPM conflicts, analyzer/test injection, nupkg/snupkg contents, SourceLink, multi-target packs; replace string-matching tests with evaluated MSBuild/package inspection; delete the dead RepositoryHasGitDirectory property (CC-39); update the stale README. Consume the released ATYA-025 CodeQuality analyzer in a Build.Sdk fixture and prove its diagnostic contract before fleet rollout.

Exact repository/package scope

Owning repository: Atya.Build.Sdk. Primary owner: **Atya.Build.Sdk**. Audit-affected repositories or coordination scopes: Atya.Build.Sdk, platform. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

The SDK claims more than its targets enforce; warnings-as-errors is less overrideable than documented; broad AtyaDisable* escape hatches ungoverned; effectively no negative tests for property precedence, CPM conflicts, packed contents, metadata validation.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. The SDK claims more than its targets enforce; warnings-as-errors is less overrideable than documented; broad AtyaDisable* escape hatches ungoverned; effectively no negative tests for property precedence, CPM conflicts, packed contents, metadata validation.

Required outcome

Archetype profiles + fixtures: property precedence, opt-outs (narrow, named, CI-reported), TFM rules, Authors/Company/tags, missing Git metadata, locked restore, CPM conflicts, analyzer/test injection, nupkg/snupkg contents, SourceLink, multi-target packs; replace string-matching tests with evaluated MSBuild/package inspection; delete the dead RepositoryHasGitDirectory property (CC-39); update the stale README. Consume the released ATYA-025 CodeQuality analyzer in a Build.Sdk fixture and prove its diagnostic contract before fleet rollout.

In scope

Atya.Build.Sdk. Archetype profiles + fixtures: property precedence, opt-outs (narrow, named, CI-reported), TFM rules, Authors/Company/tags, missing Git metadata, locked restore, CPM conflicts, analyzer/test injection, nupkg/snupkg contents, SourceLink, multi-target packs; replace string-matching tests with evaluated MSBuild/package inspection; delete the dead RepositoryHasGitDirectory property (CC-39); update the stale README. Includes the Build.Sdk-owned packed-consumer adoption proof for ATYA-025.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-027, ATYA-005, ATYA-025.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Archetype profiles + fixtures: property precedence, opt-outs (narrow, named, CI-reported), TFM rules, Authors/Company/tags, missing Git metadata, locked restore, CPM conflicts, analyzer/test injection, nupkg/snupkg contents, SourceLink, multi-target packs
3. replace string-matching tests with evaluated MSBuild/package inspection
4. delete the dead RepositoryHasGitDirectory property (CC-39)
5. update the stale README.
6. Record Confirmed, Refuted, or Partial evidence and re-scope dependents without implementing unapproved fixes.
7. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Atya.Build.Sdk's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Fixture-driven; any tightened enforcement release-noted.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Fixture matrix on both OSes..

Documentation

Update Atya.Build.Sdk README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

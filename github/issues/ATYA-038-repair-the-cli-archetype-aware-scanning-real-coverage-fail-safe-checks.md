# ATYA-038 — Repair the CLI: archetype-aware scanning, real coverage, fail-safe checks; release

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-038 |
| Owning repository | Cli |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-001; ATYA-002 |
| Advisory prerequisites | None |
| Implementation state | Partially satisfied |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (S-0018 + S-0019 + F-0035 (repair/release half)) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Embedded constitution 1.2.0 vs live 1.5.1; scanner recurses into artifacts/generated projects and misclassifies archetypes; behavior classes carry ExcludeFromCodeCoverage; online failures become optimistic absence; checks not tied to current HEAD; the spec-architecture refactor sits unreleased.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Embedded constitution 1.2.0 vs live 1.5.1; scanner recurses into artifacts/generated projects and misclassifies archetypes; behavior classes carry ExcludeFromCodeCoverage; online failures become optimistic absence; checks not tied to current HEAD; the spec-architecture refactor sits unreleased.

## Desired outcome

Generate embedded policy/version from the manifest; explicit archetypes; exclude generated/ignored paths; deterministic project discovery incl. worktrees; remove broad coverage exclusions with a reviewed exclusion budget; unknown external state → explicit unknown/manual, never success; timeouts/cancellation; NuGet.Versioning + XML parsing; fixture corpus across all archetypes; release v0.1.1 (refactor) when fail-open semantics are fixed.

## Affected scope

Primary owner: **Cli**. Audit-affected repositories or coordination scopes: Cli, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Tooling.Cli. Generate embedded policy/version from the manifest; explicit archetypes; exclude generated/ignored paths; deterministic project discovery incl. worktrees; remove broad coverage exclusions with a reviewed exclusion budget; unknown external state → explicit unknown/manual, never success; timeouts/cancellation; NuGet.Versioning + XML parsing; fixture corpus across all archetypes; release v0.1.1 (refactor) when fail-open semantics are fixed.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-001
- ATYA-002

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-027

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Generate embedded policy/version from the manifest
3. explicit archetypes
4. exclude generated/ignored paths
5. deterministic project discovery incl
6. remove broad coverage exclusions with a reviewed exclusion budget
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Cli's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Pre-1.0 tool; document compatibility policy (S-0013 note).

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Failure-injection fixtures..

## Documentation work

Update Cli README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Simulated gh auth failure yields unknown, exit-code-mapped, not a pass; scanner classifies all 36 repos correctly against the manifest; coverage gate reflects real behavior code.

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
# Task-specific proof: Failure-injection fixtures.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-038 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Repair the CLI: archetype-aware scanning, real coverage, fail-safe checks; release. Generate embedded policy/version from the manifest; explicit archetypes; exclude generated/ignored paths; deterministic project discovery incl. worktrees; remove broad coverage exclusions with a reviewed exclusion budget; unknown external state → explicit unknown/manual, never success; timeouts/cancellation; NuGet.Versioning + XML parsing; fixture corpus across all archetypes; release v0.1.1 (refactor) when fail-open semantics are fixed.

Exact repository/package scope

Owning repository: Cli. Primary owner: **Cli**. Audit-affected repositories or coordination scopes: Cli, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Embedded constitution 1.2.0 vs live 1.5.1; scanner recurses into artifacts/generated projects and misclassifies archetypes; behavior classes carry ExcludeFromCodeCoverage; online failures become optimistic absence; checks not tied to current HEAD; the spec-architecture refactor sits unreleased.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Embedded constitution 1.2.0 vs live 1.5.1; scanner recurses into artifacts/generated projects and misclassifies archetypes; behavior classes carry ExcludeFromCodeCoverage; online failures become optimistic absence; checks not tied to current HEAD; the spec-architecture refactor sits unreleased.

Required outcome

Generate embedded policy/version from the manifest; explicit archetypes; exclude generated/ignored paths; deterministic project discovery incl. worktrees; remove broad coverage exclusions with a reviewed exclusion budget; unknown external state → explicit unknown/manual, never success; timeouts/cancellation; NuGet.Versioning + XML parsing; fixture corpus across all archetypes; release v0.1.1 (refactor) when fail-open semantics are fixed.

In scope

Atya.Tooling.Cli. Generate embedded policy/version from the manifest; explicit archetypes; exclude generated/ignored paths; deterministic project discovery incl. worktrees; remove broad coverage exclusions with a reviewed exclusion budget; unknown external state → explicit unknown/manual, never success; timeouts/cancellation; NuGet.Versioning + XML parsing; fixture corpus across all archetypes; release v0.1.1 (refactor) when fail-open semantics are fixed.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-001, ATYA-002.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Generate embedded policy/version from the manifest
3. explicit archetypes
4. exclude generated/ignored paths
5. deterministic project discovery incl
6. remove broad coverage exclusions with a reviewed exclusion budget
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Cli's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Pre-1.0 tool; document compatibility policy (S-0013 note).

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Failure-injection fixtures..

Documentation

Update Cli README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

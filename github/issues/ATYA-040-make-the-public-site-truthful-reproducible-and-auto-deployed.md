# ATYA-040 — Make the public site truthful, reproducible, and auto-deployed

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-040 |
| Owning repository | AtyaLibraries.github.io |
| Primary contract owner | AtyaLibraries.github.io |
| Downstream repositories | publisher |
| Child migration requirement | required-existing |
| Child migration tasks | ATYA-024; ATYA-126 |
| Priority | P1 |
| Phase | 3 — Build, workflow, and release consolidation |
| Type | Documentation |
| Initial status | Blocked |
| Hard dependencies | ATYA-001; ATYA-024; ATYA-019; ATYA-126 |
| Advisory prerequisites | None |
| Implementation state | Partially satisfied |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Merged (F-0032 + S-0021) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Deploys are manual-dispatch (stale catalog after every release); no npm lock file (npm install at deploy); mutable actions; managed repos labeled Published without NuGet verification; stale categories/counts; wildcard SDK snippet contradicting the org's own pinning rule.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. Deploys are manual-dispatch (stale catalog after every release); no npm lock file (npm install at deploy); mutable actions; managed repos labeled Published without NuGet verification; stale categories/counts; wildcard SDK snippet contradicting the org's own pinning rule.

## Desired outcome

Make the public site truthful and reproducible from the manifest and authoritative NuGet state; commit the lock file, use npm ci, pin actions, expose the authenticated refresh receiver, and retain a weekly cron fallback. ATYA-024 supplies the publisher dispatch sender.

## Affected scope

Primary owner: **AtyaLibraries.github.io**. Audit-affected repositories or coordination scopes: AtyaLibraries.github.io, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

AtyaLibraries.github.io data generation, lock file, build/deploy workflow, refresh receiver, cache/retry/timeout behavior, and weekly fallback.

## Out-of-scope work

Publisher authentication or dispatch mutation; ATYA-024 owns that independently deployable sender.

## Hard dependencies

- ATYA-001
- ATYA-024
- ATYA-019
- ATYA-126

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-025
- ATYA-026
- ATYA-027

## Ownership and downstream migrations

- Primary contract owner: AtyaLibraries.github.io
- Final owning repository: AtyaLibraries.github.io
- Downstream repositories: publisher
- Child migration requirement: required-existing
- Child migration tasks: ATYA-024
- Rationale: The site owns truth generation, the event receiver, deployment, and cron fallback; ATYA-024 owns the independently deployable authenticated publisher dispatch sender.

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Commit lock file, npm ci, pin actions
3. generate package/category/lifecycle data from the manifest + authoritative NuGet status with distinct published/prerelease/repo-only states
4. exact SDK version in snippets
5. add timeout/retry/cache to generation
6. then Fable's repository_dispatch from successful publishes + weekly cron fallback.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside AtyaLibraries.github.io's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

None.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Publish a scratch prerelease; site reflects it within the cron window..

## Documentation work

Update AtyaLibraries.github.io README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Site states match NuGet reality for every package and the build is reproducible from the lock file.
- The site refresh receiver and weekly fallback are tested.
- A successful ATYA-024 authenticated dispatch triggers refresh without a publisher edit in this task.

## Definition of done

- All acceptance criteria pass with durable evidence.
- Tests, documentation, compatibility/migration notes, and security review are complete.
- No unresolved high-severity regression, dependency break, or untracked follow-up remains; downstream tasks are unblocked explicitly.

## Validation commands

```powershell
npm ci
npm test
npm run build
# Task-specific proof: Publish a scratch prerelease; site reflects it within the cron window.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-040 for the AtyaLibraries ecosystem. Work independently; do not assume you have read the original analyses or repository audit.

Task objective

Make the public site truthful, reproducible, and auto-deployed. Make the public site truthful and reproducible from the manifest and authoritative NuGet state; commit the lock file, use npm ci, pin actions, expose the authenticated refresh receiver, and retain a weekly cron fallback. ATYA-024 supplies the publisher dispatch sender.

Exact repository/package scope

Owning repository: AtyaLibraries.github.io. Primary owner: **AtyaLibraries.github.io**. Audit-affected repositories or coordination scopes: AtyaLibraries.github.io, AtyaLibraries. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

Discovery requirements

Before editing, inspect AGENTS.md, git status and branches, project/workflow/package files, tests, public API and metadata, live issue/PR/run state, and every evidence path named below. Verify current state, preserve unrelated changes, and stop destructive work if evidence contradicts the task.

Authoritative constraints

Primary repository and live service evidence govern facts; the accepted Atya.Roadmap decisions govern cross-repository policy. Hard dependencies alone determine Ready/Blocked. Phases are thematic reporting groups and non-blocking reporting milestones. Never rewrite published tags/packages, delete unverified work, expose secrets, or create another policy source.

Current problem

Deploys are manual-dispatch (stale catalog after every release); no npm lock file (npm install at deploy); mutable actions; managed repos labeled Published without NuGet verification; stale categories/counts; wildcard SDK snippet contradicting the org's own pinning rule.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. Deploys are manual-dispatch (stale catalog after every release); no npm lock file (npm install at deploy); mutable actions; managed repos labeled Published without NuGet verification; stale categories/counts; wildcard SDK snippet contradicting the org's own pinning rule.

Required outcome

Make the public site truthful and reproducible from the manifest and authoritative NuGet state; commit the lock file, use npm ci, pin actions, expose the authenticated refresh receiver, and retain a weekly cron fallback. ATYA-024 supplies the publisher dispatch sender.

In scope

AtyaLibraries.github.io data generation, lock file, build/deploy workflow, refresh receiver, cache/retry/timeout behavior, and weekly fallback.

Out of scope

Publisher authentication or dispatch mutation; ATYA-024 owns that independently deployable sender.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-001, ATYA-024, ATYA-019, ATYA-126.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Commit lock file, npm ci, pin actions
3. generate package/category/lifecycle data from the manifest + authoritative NuGet status with distinct published/prerelease/repo-only states
4. exact SDK version in snippets
5. add timeout/retry/cache to generation
6. then Fable's repository_dispatch from successful publishes + weekly cron fallback.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside AtyaLibraries.github.io's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

None.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Publish a scratch prerelease; site reflects it within the cron window..

Documentation

Update AtyaLibraries.github.io README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

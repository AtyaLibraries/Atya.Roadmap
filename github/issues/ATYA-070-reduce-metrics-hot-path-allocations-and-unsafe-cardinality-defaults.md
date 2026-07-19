# ATYA-070 — Reduce Metrics hot-path allocations and unsafe cardinality defaults

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-070 |
| Owning repository | Metrics |
| Priority | P2 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-068 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0056) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

IMeterAccessor mirrors/leaks Meter; success/failure helpers allocate tag arrays per measurement; exported constants encourage tenant/user/entity labels.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. IMeterAccessor mirrors/leaks Meter; success/failure helpers allocate tag arrays per measurement; exported constants encourage tenant/user/entity labels.

## Desired outcome

Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter; add fixed-arity and TagList paths; eliminate avoidable copies; apply the dimension policy; add listener-based correctness tests and allocation-budget benchmarks that fail on regression.

## In-scope work

Diagnostics.Metrics. Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter; add fixed-arity and TagList paths; eliminate avoidable copies; apply the dimension policy; add listener-based correctness tests and allocation-budget benchmarks that fail on regression.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-068

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter
3. fixed-arity + TagList paths
4. eliminate avoidable copies
5. apply the dimension policy
6. listener-based correctness + allocation-budget benchmarks failing on regression.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Metrics's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Introduce the narrow owned-instrument paths additively, obsolete the raw-Meter surface, and remove that surface in the 2.0 wave. Direct Meter access is not retained as the package contract.

## Security and privacy considerations

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Benchmarks..

## Documentation work

Update Metrics README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Public package abstractions no longer expose raw Meter after the 2.0 migration; the measurement hot path is allocation-free in the benchmark; policy-violating labels are rejected by lint.

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
# Task-specific proof: Benchmarks.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-070 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Reduce Metrics hot-path allocations and unsafe cardinality defaults. Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter; add fixed-arity and TagList paths; eliminate avoidable copies; apply the dimension policy; add listener-based correctness tests and allocation-budget benchmarks that fail on regression.

Exact repository/package scope

Owning repository: Metrics. In scope: Diagnostics.Metrics. Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter; add fixed-arity and TagList paths; eliminate avoidable copies; apply the dimension policy; add listener-based correctness tests and allocation-budget benchmarks that fail on regression.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

IMeterAccessor mirrors/leaks Meter; success/failure helpers allocate tag arrays per measurement; exported constants encourage tenant/user/entity labels.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. IMeterAccessor mirrors/leaks Meter; success/failure helpers allocate tag arrays per measurement; exported constants encourage tenant/user/entity labels.

Required outcome

Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter; add fixed-arity and TagList paths; eliminate avoidable copies; apply the dimension policy; add listener-based correctness tests and allocation-budget benchmarks that fail on regression.

In scope

Diagnostics.Metrics. Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter; add fixed-arity and TagList paths; eliminate avoidable copies; apply the dimension policy; add listener-based correctness tests and allocation-budget benchmarks that fail on regression.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-068.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Narrow IMeterAccessor to package-owned instrument-factory semantics and stop exposing raw Meter
3. fixed-arity + TagList paths
4. eliminate avoidable copies
5. apply the dimension policy
6. listener-based correctness + allocation-budget benchmarks failing on regression.
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Metrics's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Introduce the narrow owned-instrument paths additively, obsolete the raw-Meter surface, and remove that surface in the 2.0 wave. Direct Meter access is not retained as the package contract.

Security and privacy requirements

Do not introduce credentials, personal data, unbounded externally controlled values, or new network trust. Run dependency and secret scans appropriate to the repository and document any accepted risk.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Benchmarks..

Documentation

Update Metrics README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Benchmarks.
```

Acceptance criteria

- Public package abstractions no longer expose raw Meter after the 2.0 migration; the measurement hot path is allocation-free in the benchmark; policy-violating labels are rejected by lint.

Working rules

Use a focused branch linked to ATYA-070; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

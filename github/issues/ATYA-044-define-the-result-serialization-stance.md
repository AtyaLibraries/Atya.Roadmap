# ATYA-044 — Define the Result serialization stance

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-044 |
| Owning repository | Results |
| Primary contract owner | Results |
| Downstream repositories | Serialization |
| Child migration requirement | required-existing |
| Child migration tasks | ATYA-048 |
| Priority | P2 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-042; ATYA-009 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | Fable (F-0014) |
| Confidence | High |
| Risk | Medium |
| Effort | M |

## Problem description

JsonSerializer.Serialize(anyResult) always throws (STJ walks throwing getters); no converter; private ctors prevent round-trip; consumers will hit this in caching/message payloads.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. JsonSerializer.Serialize(anyResult) always throws (STJ walks throwing getters); no converter; private ctors prevent round-trip; consumers will hit this in caching/message payloads.

## Desired outcome

Define, document, and enforce the Results-owned stance: Error is a legitimate wire value with a normative converter contract, while Result and Result<T> are non-wire types with explicit rejection/throw-trap guidance. ATYA-048 implements and registers the converter in Serialization.

## In-scope work

Foundation.Results public semantics, documentation, API/release baseline, explicit Result serialization rejection behavior, and the normative Error converter contract consumed by ATYA-048.

## Out-of-scope work

ErrorJsonConverter implementation, ApplyDefaults registration, and AOT converter verification; these belong to Serialization under ATYA-048.

## Ownership and downstream migrations

- Primary contract owner: Results
- Final owning repository: Results
- Downstream repositories: Serialization
- Child migration requirement: required-existing
- Child migration tasks: ATYA-048
- Rationale: Results owns Error/Result wire semantics; Serialization owns converter implementation and registration.

## Hard dependencies

- ATYA-042
- ATYA-009

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-042
- ATYA-043
- ATYA-045

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Specify and fixture-test the normative Error converter contract for ATYA-048, including Details recursion, Target casing, nullability, and tolerant reading; do not edit Serialization in this task
3. Document Result/Result<T> as non-wire types and test a clear explicit rejection path rather than relying on throwing getters.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside Results's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Additive; documented stance.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Results API rejection tests and converter-contract fixtures; ATYA-048 owns Serialization round-trip tests.

## Documentation work

Update Results README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Results documentation and API behavior unambiguously classify Error as wire-capable and Result/Result<T> as non-wire.
- The Error converter contract specifies Details recursion, Target casing, nullability, and tolerant-reading behavior for ATYA-048.
- Unsupported Result serialization fails with a clear, tested message.

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
# Task-specific proof: Results API rejection tests and converter-contract fixtures; ATYA-048 owns converter round trips.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-044 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Define the Result serialization stance. Define, document, and enforce the Results-owned stance: Error is a legitimate wire value with a normative converter contract, while Result and Result<T> are non-wire types with explicit rejection/throw-trap guidance. ATYA-048 implements and registers the converter in Serialization.

Exact repository/package scope

Owning repository: Results. In scope: Foundation.Results public semantics, documentation, API/release baseline, explicit Result serialization rejection behavior, and the normative Error converter contract consumed by ATYA-048.

Ownership and migration split

- Primary contract owner: Results
- Final owning repository: Results
- Downstream repositories: Serialization
- Child migration requirement: required-existing
- Child migration tasks: ATYA-048
- Rationale: Results owns Error/Result wire semantics; Serialization owns converter implementation and registration.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

JsonSerializer.Serialize(anyResult) always throws (STJ walks throwing getters); no converter; private ctors prevent round-trip; consumers will hit this in caching/message payloads.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. JsonSerializer.Serialize(anyResult) always throws (STJ walks throwing getters); no converter; private ctors prevent round-trip; consumers will hit this in caching/message payloads.

Required outcome

Define, document, and enforce the Results-owned stance: Error is a legitimate wire value with a normative converter contract, while Result and Result<T> are non-wire types with explicit rejection/throw-trap guidance. ATYA-048 implements and registers the converter in Serialization.

In scope

Foundation.Results public semantics, documentation, API/release baseline, explicit Result serialization rejection behavior, and the normative Error converter contract consumed by ATYA-048.

Out of scope

ErrorJsonConverter implementation, ApplyDefaults registration, and AOT converter verification; these belong to Serialization under ATYA-048.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-042, ATYA-009.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Specify and fixture-test the normative Error converter contract for ATYA-048, including Details recursion, Target casing, nullability, and tolerant reading; do not edit Serialization in this task
3. Document Result/Result<T> as non-wire types and test a clear explicit rejection path rather than relying on throwing getters.
4. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
5. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside Results's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Additive; documented stance.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: Results API rejection tests and converter-contract fixtures; ATYA-048 owns Serialization round-trip tests.

Documentation

Update Results README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Results API rejection tests and converter-contract fixtures; ATYA-048 owns converter round trips.
```

Acceptance criteria

- Results documentation and API behavior unambiguously classify Error as wire-capable and Result/Result<T> as non-wire.
- The Error converter contract specifies Details recursion, Target casing, nullability, and tolerant-reading behavior for ATYA-048.
- Unsupported Result serialization fails with a clear, tested message.

Working rules

Use a focused branch linked to ATYA-044; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

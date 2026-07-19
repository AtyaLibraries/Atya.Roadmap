# ATYA-067 — OpenTelemetry: remove silent options, add production controls

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-067 |
| Owning repository | OpenTelemetry |
| Priority | P1 |
| Phase | 5 — Messaging, data, web, and diagnostics hardening |
| Type | Migration |
| Initial status | Blocked |
| Hard dependencies | ATYA-066 |
| Advisory prerequisites | None |
| Evidence status | Public summary only; detailed evidence is retained privately by maintainers. |
| Origin | GPT 5.6 SOL (S-0053) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

EF Core/gRPC toggles reportedly bind but do nothing; no sampler/per-signal filter/export limits/redaction hooks; OTLP endpoint validation loose; enabling SQL text duplicates statements into two sensitive attributes.

## Root cause

The package contract, its automation, and its consumers evolved without a complete executable invariant. EF Core/gRPC toggles reportedly bind but do nothing; no sampler/per-signal filter/export limits/redaction hooks; OTLP endpoint validation loose; enabling SQL text duplicates statements into two sensitive attributes.

## Desired outcome

Remove or fail-validate unsupported toggles until implemented; sampling + per-signal filters/processors/limits; central redaction hooks; protocol-aware endpoint validation; sensitive-SQL capture off by default, single current semantic attribute; in-memory-exporter tests asserting spans/metrics/logs/sampling/redaction/option effects.

## In-scope work

Diagnostics.OpenTelemetry. Remove or fail-validate unsupported toggles until implemented; sampling + per-signal filters/processors/limits; central redaction hooks; protocol-aware endpoint validation; sensitive-SQL capture off by default, single current semantic attribute; in-memory-exporter tests asserting spans/metrics/logs/sampling/redaction/option effects.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-066

## Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-057
- ATYA-058
- ATYA-059

## Implementation sequence

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Remove or fail-validate unsupported toggles until implemented
3. sampling + per-signal filters/processors/limits
4. central redaction hooks
5. protocol-aware endpoint validation
6. sensitive-SQL capture off by default, single current semantic attribute
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

## Architecture guidance

Keep the change inside OpenTelemetry's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

## Compatibility and migration

Removing public no-op options is breaking — fail-validation first (minor), removal at 2.0.

## Security and privacy considerations

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

## Testing strategy

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: In-memory exporter assertions..

## Documentation work

Update OpenTelemetry README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

## Measurable acceptance criteria

- Setting an unimplemented toggle fails validation with a clear message; emitted-telemetry tests prove each real option's effect.

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
# Task-specific proof: In-memory exporter assertions.
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-067 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

OpenTelemetry: remove silent options, add production controls. Remove or fail-validate unsupported toggles until implemented; sampling + per-signal filters/processors/limits; central redaction hooks; protocol-aware endpoint validation; sensitive-SQL capture off by default, single current semantic attribute; in-memory-exporter tests asserting spans/metrics/logs/sampling/redaction/option effects.

Exact repository/package scope

Owning repository: OpenTelemetry. In scope: Diagnostics.OpenTelemetry. Remove or fail-validate unsupported toggles until implemented; sampling + per-signal filters/processors/limits; central redaction hooks; protocol-aware endpoint validation; sensitive-SQL capture off by default, single current semantic attribute; in-memory-exporter tests asserting spans/metrics/logs/sampling/redaction/option effects.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

EF Core/gRPC toggles reportedly bind but do nothing; no sampler/per-signal filter/export limits/redaction hooks; OTLP endpoint validation loose; enabling SQL text duplicates statements into two sensitive attributes.

Root cause: The package contract, its automation, and its consumers evolved without a complete executable invariant. EF Core/gRPC toggles reportedly bind but do nothing; no sampler/per-signal filter/export limits/redaction hooks; OTLP endpoint validation loose; enabling SQL text duplicates statements into two sensitive attributes.

Required outcome

Remove or fail-validate unsupported toggles until implemented; sampling + per-signal filters/processors/limits; central redaction hooks; protocol-aware endpoint validation; sensitive-SQL capture off by default, single current semantic attribute; in-memory-exporter tests asserting spans/metrics/logs/sampling/redaction/option effects.

In scope

Diagnostics.OpenTelemetry. Remove or fail-validate unsupported toggles until implemented; sampling + per-signal filters/processors/limits; central redaction hooks; protocol-aware endpoint validation; sensitive-SQL capture off by default, single current semantic attribute; in-memory-exporter tests asserting spans/metrics/logs/sampling/redaction/option effects.

Out of scope

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

Blockers and dependencies

Do not start mutation until these hard dependencies are accepted: ATYA-066.

Advisory prerequisites

None. Advisory prerequisites are nonblocking and do not determine Ready/Blocked status.

Detailed implementation steps

1. Inspect the cited repository paths, public APIs, workflows, tests, tags, and open work before changing anything.
2. Remove or fail-validate unsupported toggles until implemented
3. sampling + per-signal filters/processors/limits
4. central redaction hooks
5. protocol-aware endpoint validation
6. sensitive-SQL capture off by default, single current semantic attribute
7. Add regression/conformance coverage before migration or rollout, then execute the smallest dependency-ordered change.
8. Update documentation, migration notes, API/release baselines, and roadmap evidence; run every validation command and attach results.

Architecture constraints

Keep the change inside OpenTelemetry's public responsibility. Preserve dependency direction, avoid a new shared package unless an accepted ADR requires it, and prefer explicit bounded contracts over ambient/global state.

Compatibility and migration requirements

Removing public no-op options is breaking — fail-validation first (minor), removal at 2.0.

Security and privacy requirements

Apply least privilege, treat repository and payload inputs as hostile, redact secrets and internal diagnostics by default, bound untrusted input size/cardinality, and add negative/adversarial tests for the affected trust boundary.

Tests

Translate every acceptance criterion into an automated regression, conformance, fixture, or scenario test where possible. Include negative and boundary cases; preserve existing tests. Source-specific validation: In-memory exporter assertions..

Documentation

Update OpenTelemetry README/architecture material, migration or release notes, and Atya.Roadmap evidence. Link any ADR and identify the last compatible behavior/version.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: In-memory exporter assertions.
```

Acceptance criteria

- Setting an unimplemented toggle fails validation with a clear message; emitted-telemetry tests prove each real option's effect.

Working rules

Use a focused branch linked to ATYA-067; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 5 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

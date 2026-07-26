# ATYA-137 — Adopt Foundation.Serialization fleet-wide and remove DictionaryKeyPolicy camelCasing

## Task metadata

| Field | Value |
|---|---|
| ATYA ID | ATYA-137 |
| Owning repository | Serialization |
| Priority | P1 |
| Phase | 4 — Foundation and cross-cutting contracts |
| Type | Implementation |
| Initial status | Blocked |
| Hard dependencies | ATYA-047; ATYA-009 |
| Advisory prerequisites | ATYA-048 |
| Implementation state | Implemented inconsistently |
| Evidence status | Verified by execution during the Opus 5 delta review (2026-07-26); reproduction commands and observed output are recorded in the task body. |
| Origin | Opus 5 delta review (O5-06) |
| Confidence | High |
| Risk | High |
| Effort | M |

## Problem description

Atya.Foundation.Serialization is published and referenced by exactly one package (Messaging.Outbox, via OutboxMessageSerializer). Five other sites build their own configuration instead: `Errors/ProblemDetails/.../AtyaProblemDetailsExceptionHandler.cs:18`, `Web/HealthChecks/.../AtyaHealthCheckResponseWriter.cs:16`, `Http/Client/.../AtyaHttpClientOptions.cs:45`, `Http/Client/.../ProblemDetailsErrorMapper.cs:17`, and the UiAutomation template — every one of them `new JsonSerializerOptions(JsonSerializerDefaults.Web)`. The foundational package is the foundation of nothing, and the same logical payload has a different shape depending on which package emitted it. Separately, `JsonSerializerConfiguration.ApplyDefaults` sets `DictionaryKeyPolicy = JsonNamingPolicy.CamelCase`, which rewrites DATA keys, not property names. Verified round-trip with those exact options: `{"X-Correlation-ID","SKU","Tenant_Id"}` is written as `{"x-Correlation-ID","sku","tenant_Id"}` and reads back with the mangled keys — PropertyNameCaseInsensitive does not apply to dictionary keys, so the transformation is irreversible. The affected shapes are exactly the ecosystem's own metadata carriers: ProblemDetails.Extensions, AtyaException.Metadata, MessageEnvelope.Headers and OutboxMessage.Headers.

## Root cause

A property-naming convention was applied to a dictionary-key policy, and no conformance rule requires packages to source their JSON policy from the shared package, so each package solved serialization locally.

## Desired outcome

One JSON policy, owned by Foundation.Serialization, used by every package that serializes, with dictionary keys round-tripping byte-for-byte.

## Affected scope

Primary owner: **Serialization**. Package: `Atya.Foundation.Serialization`. Only the cited findings and their direct acceptance evidence are added; unaffected architecture remains unchanged.

## In-scope work

Atya.Foundation.Serialization. One JSON policy, owned by Foundation.Serialization, used by every package that serializes, with dictionary keys round-tripping byte-for-byte.

## Out-of-scope work

Unrelated repositories or public APIs, speculative package creation, and destructive cleanup not explicitly named by this task.

## Hard dependencies

- ATYA-047
- ATYA-009

## Advisory prerequisites

- ATYA-048

Advisory prerequisites are nonblocking and do not affect Ready/Blocked status.

## Related tasks

- ATYA-048
- ATYA-039
- ATYA-058

## Implementation sequence

1. Remove `options.DictionaryKeyPolicy = JsonNamingPolicy.CamelCase` from ApplyDefaults; dictionary keys are data and must round-trip unchanged.
2. Add a round-trip regression test over a key set including a header name, an all-caps token and an underscore token.
3. Replace every `new JsonSerializerOptions(JsonSerializerDefaults.Web)` in ProblemDetails, HealthChecks and Http.Client with `JsonSerializerConfiguration.CreateDefault()` (or the shared read-only Default where no mutation follows).
4. Expose the Http.Client options as a settable JsonSerializerOptions seeded from the shared configuration.
5. Add a fleet conformance check to the CLI audit (ATYA-039) that fails when a package constructs JsonSerializerOptions without going through Foundation.Serialization.

## Architecture guidance

Foundation.Serialization is the single source of JSON policy. Downstream packages configure from it and may override explicitly; they may not define a parallel default. Land this before ATYA-048 so there is one resolver chain to make AOT-safe rather than five.

## Compatibility and migration

Removing DictionaryKeyPolicy is a wire-format change for anything already persisted by Messaging.Outbox — check for in-flight outbox rows before rolling and document it as a fix in release notes. Packages moving from Web defaults to Atya defaults may see property-casing and null-handling changes; capture golden fixtures before and after.

## Security and privacy considerations

Restores fidelity of security-relevant metadata keys (correlation ids, tenant ids) that were previously mangled on write and unrecoverable on read.

## Testing strategy

Dictionary-key round-trip tests; golden-fixture comparison for every relocated call site; a conformance test asserting no package constructs JsonSerializerOptions directly.

## Documentation work

Document the shared policy, what it guarantees, and how to override it per call site, in the Serialization README and in each adopting package's README.

## Measurable acceptance criteria

- `{"X-Correlation-ID","SKU","Tenant_Id"}` serialized and deserialized with the shared defaults returns the identical key set.
- No package outside Foundation.Serialization constructs `new JsonSerializerOptions(...)` directly, enforced by a conformance check.
- ProblemDetails, HealthChecks and Http.Client emit and parse using the shared configuration.
- Golden fixtures for each relocated call site are recorded and reviewed for intentional shape changes.

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
# Task-specific proof: Round-trip assertion proving dictionary keys survive serialize/deserialize unchanged.
dotnet test -c Release --filter FullyQualifiedName~DictionaryKeyRoundTrip
```

## Rollback strategy

Use a feature/configuration switch or revert the isolated change before publishing. Published packages are immutable: issue a corrected forward version and retain migration notes; never rewrite tags or packages.

## Standalone implementation prompt

You are implementing ATYA-137 for the AtyaLibraries ecosystem. Work independently; do not assume you have read any assessment or roadmap.

Task objective

Adopt Foundation.Serialization fleet-wide and remove DictionaryKeyPolicy camelCasing. One JSON policy, owned by Foundation.Serialization, used by every package that serializes, with dictionary keys round-tripping byte-for-byte.

Exact repository/package scope

Owning repository: Serialization. In scope: `Atya.Foundation.Serialization` only. Do not modify any other repository.

Discovery requirements

Before editing, inspect the repository's AGENTS.md/instructions, git status and branches, project/workflow files, public API and package metadata, existing tests, open issue/PR context supplied with the task, and all cited evidence. Verify the current state; record evidence that refutes the task and stop destructive or breaking work until scope is corrected. Preserve unrelated user changes.

Authoritative constraints

Atya.Roadmap decisions and accepted ADRs govern cross-repository policy. Repository source and live GitHub/NuGet state govern facts. Hard dependencies alone block execution. Phases are thematic reporting groups, not implicit dependencies. Do not rewrite published tags or packages, delete unverified work, invent another policy source, or create a repository/package seam without the accepted topology and admission gates.

Current problem

Atya.Foundation.Serialization is published and referenced by exactly one package (Messaging.Outbox, via OutboxMessageSerializer). Five other sites build their own configuration instead: `Errors/ProblemDetails/.../AtyaProblemDetailsExceptionHandler.cs:18`, `Web/HealthChecks/.../AtyaHealthCheckResponseWriter.cs:16`, `Http/Client/.../AtyaHttpClientOptions.cs:45`, `Http/Client/.../ProblemDetailsErrorMapper.cs:17`, and the UiAutomation template — every one of them `new JsonSerializerOptions(JsonSerializerDefaults.Web)`. The foundational package is the foundation of nothing, and the same logical payload has a different shape depending on which package emitted it. Separately, `JsonSerializerConfiguration.ApplyDefaults` sets `DictionaryKeyPolicy = JsonNamingPolicy.CamelCase`, which rewrites DATA keys, not property names. Verified round-trip with those exact options: `{"X-Correlation-ID","SKU","Tenant_Id"}` is written as `{"x-Correlation-ID","sku","tenant_Id"}` and reads back with the mangled keys — PropertyNameCaseInsensitive does not apply to dictionary keys, so the transformation is irreversible. The affected shapes are exactly the ecosystem's own metadata carriers: ProblemDetails.Extensions, AtyaException.Metadata, MessageEnvelope.Headers and OutboxMessage.Headers.

Root cause: A property-naming convention was applied to a dictionary-key policy, and no conformance rule requires packages to source their JSON policy from the shared package, so each package solved serialization locally.

Required outcome

One JSON policy, owned by Foundation.Serialization, used by every package that serializes, with dictionary keys round-tripping byte-for-byte.

Blockers and dependencies

Blocked until these complete: ATYA-047, ATYA-009.

Advisory prerequisites

Advisory only, nonblocking: ATYA-048.

Detailed implementation steps

1. Remove `options.DictionaryKeyPolicy = JsonNamingPolicy.CamelCase` from ApplyDefaults; dictionary keys are data and must round-trip unchanged.
2. Add a round-trip regression test over a key set including a header name, an all-caps token and an underscore token.
3. Replace every `new JsonSerializerOptions(JsonSerializerDefaults.Web)` in ProblemDetails, HealthChecks and Http.Client with `JsonSerializerConfiguration.CreateDefault()` (or the shared read-only Default where no mutation follows).
4. Expose the Http.Client options as a settable JsonSerializerOptions seeded from the shared configuration.
5. Add a fleet conformance check to the CLI audit (ATYA-039) that fails when a package constructs JsonSerializerOptions without going through Foundation.Serialization.

Architecture constraints

Foundation.Serialization is the single source of JSON policy. Downstream packages configure from it and may override explicitly; they may not define a parallel default. Land this before ATYA-048 so there is one resolver chain to make AOT-safe rather than five.

Compatibility and migration requirements

Removing DictionaryKeyPolicy is a wire-format change for anything already persisted by Messaging.Outbox — check for in-flight outbox rows before rolling and document it as a fix in release notes. Packages moving from Web defaults to Atya defaults may see property-casing and null-handling changes; capture golden fixtures before and after.

Security and privacy requirements

Restores fidelity of security-relevant metadata keys (correlation ids, tenant ids) that were previously mangled on write and unrecoverable on read.

Tests

Dictionary-key round-trip tests; golden-fixture comparison for every relocated call site; a conformance test asserting no package constructs JsonSerializerOptions directly.

Documentation

Document the shared policy, what it guarantees, and how to override it per call site, in the Serialization README and in each adopting package's README.

Validation commands

```powershell
dotnet restore --locked-mode
dotnet build -c Release --no-restore
dotnet test -c Release --no-build
dotnet pack -c Release --no-build
# Task-specific proof: Round-trip assertion proving dictionary keys survive serialize/deserialize unchanged.
dotnet test -c Release --filter FullyQualifiedName~DictionaryKeyRoundTrip
```

Acceptance criteria

- `{"X-Correlation-ID","SKU","Tenant_Id"}` serialized and deserialized with the shared defaults returns the identical key set.
- No package outside Foundation.Serialization constructs `new JsonSerializerOptions(...)` directly, enforced by a conformance check.
- ProblemDetails, HealthChecks and Http.Client emit and parse using the shared configuration.
- Golden fixtures for each relocated call site are recorded and reviewed for intentional shape changes.

Working rules

Use a focused branch linked to ATYA-137; make small reviewable commits; do not modify other repositories unless this task explicitly names them; never suppress a failing test or security check to obtain green CI; distinguish verified facts from assumptions; request approval before irreversible remote actions; update the roadmap ledger with evidence.

Required final response

Return the files and public APIs changed, decisions made, compatibility/security impact, tests and commands run with results, migration/rollback notes, linked issue/PR/ADR evidence, and any remaining blocker or follow-up ATYA task. Do not claim completion if any task acceptance criterion remains unmet. Report the effect on the phase 4 milestone separately; that reporting milestone does not block this task once its hard dependencies are satisfied.

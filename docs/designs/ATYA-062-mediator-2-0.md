# ATYA-062 + ATYA-142: Atya.Application.Mediator 2.0.0

Status: Proposed for owner review. No code. Read against `Mediator` `development` at `5b0643d`.
Fixed by the owner: the generator discovers records and every handler interface per type, packed-analyzer verification, explicit lifetimes.

## Problem

Verified in source:

- The generator's predicate is `ClassDeclarationSyntax { BaseList: not null }`. A `record` handler is a `RecordDeclarationSyntax`, so it is silently skipped.
- `GetHandlerRegistration` returns inside the `foreach` over `AllInterfaces` after the first match. A class implementing two `IRequestHandler<,>` interfaces gets one registration, chosen by interface order.
- `AddAtyaMediator` registers `IMediator` Scoped, but every `IRequestHandler<>` and both dispatcher interfaces Transient. The `Mediator` constructor takes `IEnumerable<IMediatorRequestDispatcher>` and `IEnumerable<IMediatorResponseDispatcher>`, so resolving `IMediator` constructs every dispatcher and therefore every handler and its dependency graph, and holds them for the scope (ATYA-142: captive dependency).
- The sample project-references the generator (`OutputItemType="Analyzer"`), so the packed analyzer path is never exercised. `Mediator.csproj` packs the generator from `..\Mediator.SourceGeneration\bin\$(Configuration)\netstandard2.0\`, which is only valid if that exact configuration was built first.
- Handler lifetime is hard-coded Transient inside `MediatorRegistrationBuilder`, with no way to state a different one.

## Public API, before and after

Before: `IMediator` (4 `Send` overloads, unchanged by this work); `IMediatorRequestDispatcher` and `IMediatorResponseDispatcher` (public, `EditorBrowsable.Never`); `MediatorRegistrationBuilder.AddRequestHandler<TRequest, THandler>()` and the 3-argument overload; `AddAtyaMediator(Action<MediatorRegistrationBuilder>)`; generated `AddAtyaMediator(this IServiceCollection)`.

After (2.0.0):

```csharp
public enum MediatorHandlerLifetime { Transient = 0, Scoped = 1, Singleton = 2 }

[AttributeUsage(AttributeTargets.Class)]
public sealed class MediatorHandlerLifetimeAttribute(MediatorHandlerLifetime lifetime) : Attribute { ... }

public sealed class MediatorRegistrationBuilder
{
    AddRequestHandler<TRequest, THandler>(MediatorHandlerLifetime lifetime = Transient);
    AddRequestHandler<TRequest, TResponse, THandler>(MediatorHandlerLifetime lifetime = Transient);
}
// generated, unchanged signature:  IServiceCollection AddAtyaMediator(this IServiceCollection services)
```

Removed from the public surface: `IMediatorRequestDispatcher`, `IMediatorResponseDispatcher` (internalised; they were never meant to be implemented, see the existing `EditorBrowsable` attribute). `IMediator` and the handler interfaces do not change. This is a major bump because of the removals and the lifetime of `IMediator`, not because of `IMediator`'s shape.

## Behaviour

**Generator.**
- Predicate becomes `TypeDeclarationSyntax` restricted to class and record class (`record struct` is excluded: the interfaces constrain to `class`).
- For each non-abstract, non-generic-open, accessible type, emit one registration per closed `IRequestHandler<>`/`IRequestHandler<,>` in `AllInterfaces`, sorted by fully-qualified request, response, handler names, so output is deterministic.
- A type with two handler interfaces is registered once under its concrete type with its lifetime, and each interface is forwarded (`sp => sp.GetRequiredService<THandler>()`). Without forwarding, a Scoped multi-interface handler would be two different instances in one scope.
- Diagnostics (all `Error` unless noted): `ATYAMEDIATOR001` duplicate handler for a request/response shape (exists); `002` open generic handler; `003` handler not accessible from the generated file (private/nested private); `004` conflicting lifetime attributes; `005` (Warning) abstract or static type implements a handler interface and is skipped.

**Runtime (ATYA-142).**
- `AddAtyaMediator` builds one frozen `MediatorMap` (request type, optional response type to a stateless, internal dispatcher function) as a singleton. It holds no handler instances.
- `IMediator` stays **Scoped**, with constructor `(MediatorMap map, IServiceProvider scopedProvider)`. `Send` looks up the dispatcher and calls `scopedProvider.GetRequiredService<IRequestHandler<...>>()` once per send. No child scope is created and no handler is disposed manually: the current scope's container owns disposal (ATYA-062 step 5).
- Resolving `IMediator` constructs zero handlers. A `Send` constructs exactly one handler.

## Concurrency and lifetime invariants, and how tests prove them

1. Resolving `IMediator` constructs 0 handlers; one `Send` constructs exactly 1 (construction counters in test handlers).
2. A handler with a Scoped dependency receives the same instance as the ambient scope (reference equality).
3. Scoped handlers are disposed when the scope ends, not on `Send` return (disposal-order test).
4. A two-interface Scoped handler yields one instance per scope across both `Send` types.
5. `BuildServiceProvider(new ServiceProviderOptions { ValidateScopes = true, ValidateOnBuild = true })` succeeds for the generated registrations, including a scoped handler.
6. Generator output is byte-identical across runs and across input file ordering (snapshot test with shuffled syntax trees).

## Packed-analyzer verification

A smoke test, per supported TFM (currently one: `net10.0`, per ADR-01 no multi-targeting), runs `dotnet pack`, installs the resulting `.nupkg` from a local feed into a fresh console project with **no** `ProjectReference`, builds it, and dispatches a request. It asserts the nupkg contains `analyzers/dotnet/cs/Atya.Application.Mediator.SourceGeneration.dll`, that the consumer has no compile-time reference to the generator assembly, and that the generated file exists. The `Mediator.csproj` pack include is changed to be configuration-independent (build the generator as a `ProjectReference` with `OutputItemType` and pack from `$(TargetPath)`), so the Release pack cannot silently ship a stale or missing DLL.

## Migration for consumers

- Handlers previously skipped (records, second interfaces) now register: behaviour-correcting, release-noted. A build that had hand-registered those handlers will hit duplicate registrations; the builder throws at registration with the offending type named.
- `IMediator` is Scoped, as before (the earlier proposal to make it a singleton is not adopted, see below).
- Code that implemented or referenced the dispatcher interfaces must stop; they were `EditorBrowsable.Never`.
- Handlers are Transient unless annotated or registered with a lifetime. Last compatible version 1.x.

## Test plan

Generator tests (Roslyn driver) for records, multi-interface, duplicates, open generics, nested and inaccessible types, deterministic output; DI tests for the invariants above; the packed-consumer smoke test in CI; the existing benchmark re-run (the removal of per-`Send` boxing is out of scope; the issue says boxing compatibility is unchanged).

## PR breakdown

1. Generator: records, all interfaces, forwarding, diagnostics, snapshots.
2. Runtime: `MediatorMap`, scoped `IMediator`, internal dispatchers, lifetimes and attribute.
3. Packaging: configuration-independent pack path, packed-consumer smoke test, docs.

## Contradictions with ADRs and the plan

- **ATYA-142 vs ATYA-062.** ATYA-142 step 2 registers `IMediator` as Singleton "over IServiceScopeFactory / IServiceProvider". A singleton can only see the root provider or create a new scope. ATYA-062 requires resolving "from the current DI scope" and "without creating a child scope". These cannot both hold. This design keeps `IMediator` Scoped and cheap (it holds a map and the scope's provider), which satisfies both acceptance lists. ATYA-142's "zero handlers on resolve" is met either way.
- ATYA-142 describes the map as populated by the generator. Here the builder populates it, so the escape-hatch builder works identically.
- ATYA-062 hard dependency ATYA-033 is Deferred in Plan v2; ATYA-002 is the verification batch. Proposal: keep only ATYA-062 to ATYA-142 ordering (same repository).
- ATYA-062 says "any future breaking internalization requires a separate benchmark-backed ADR". Internalising the two dispatcher interfaces is that kind of change. Because 2.0.0 is already breaking, I propose it ships here without an ADR, but the owner may prefer to keep them public and `[Obsolete]`.

## Open questions for the owner

1. Internalise the dispatcher interfaces now (recommended) or keep them public and obsolete until a later major?
2. Handler lifetime default: Transient (current, recommended) or Scoped?
3. Should the lifetime attribute live in `Atya.Application.Mediator` (needs no new package) or be a generator-owned constant? Recommended: in the runtime package.

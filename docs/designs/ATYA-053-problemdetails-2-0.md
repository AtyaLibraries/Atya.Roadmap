# ATYA-053 (+ ATYA-143, 144): Atya.Errors.ProblemDetails 2.0.0

Status: Proposed for owner review. No code. Read against `ProblemDetails` `development` at `7310b7b`.
Fixed by the owner: symmetric customization, one constructor, trace id from `Activity.TraceId` (not `Activity.Id`), 429/503/504 rows using the new `ErrorKind` values `Unavailable`, `Timeout`, `TooManyRequests`.

## Prerequisite

`Foundation.Results` on `development` has `ErrorKind` up to `Unexpected = 6`. The owner approved adding `Unavailable = 7`, `Timeout = 8` and `TooManyRequests = 9` in Results 1.2.0 (Wave 1), which supersedes ATYA-045's deferral for these three values. ProblemDetails 2.0.0 depends on Results 1.2.0. Appending values is source-compatible but breaks exhaustive `switch` expressions in consumers; release notes must say so.

## Problem

Verified in source:

- `CustomizeProblemDetails` (`Action<HttpContext, Exception, ProblemDetails>`) is invoked only by `DefaultExceptionToProblemDetailsMapper`. `DefaultResultToProblemDetailsMapper` never calls it.
- Exception mapping resolution is exact-type first, then `FirstOrDefault` over the mapping list for assignable types. List order is registration order (`Insert(0, ...)`), so mapping a base type after a derived one changes which wins.
- `AtyaProblemDetailsOptions` is a mutable object shared by singleton mappers (`Mappings`, `ErrorMappings`, `ExtensionNames`).
- `ExtensionNames` can be set to the same value or to RFC 9457 members (`type`, `title`, `status`, `detail`, `instance`).
- `ValidateHttpStatusCode` accepts 100–599.
- `AtyaProblemDetailsExceptionHandler` awaits without `ConfigureAwait(false)`.
- Each mapper has two public single-parameter constructors (`AtyaProblemDetailsOptions` and `IOptions<AtyaProblemDetailsOptions>`). Registering the concrete options type next to `IOptions<>` makes both satisfiable and DI throws "multiple constructors" at first resolve (ATYA-143).
- `traceId` is `Activity.Current?.Id ?? httpContext.TraceIdentifier`. Under W3C, `Activity.Id` is the whole `traceparent` (`00-<trace>-<span>-<flags>`), not the trace id (ATYA-144).
- Unmapped `ErrorKind`s fall to 422; there is no row for 429, 503 or 504.

## Public API, before and after

```csharp
// New
public sealed class ProblemDetailsCustomizationContext
{ HttpContext HttpContext; Exception? Exception; Error? Error; AspNetProblemDetails ProblemDetails; }
AtyaProblemDetailsOptions.Customize : Action<ProblemDetailsCustomizationContext>?
AtyaProblemDetailsOptions.AllowNonErrorStatusCodes : bool          // named escape hatch, default false

// Kept as sugar, [Obsolete] in 2.0, removal in the next major:
AtyaProblemDetailsOptions.CustomizeProblemDetails : Action<HttpContext, Exception, ProblemDetails>?   // exception path only, as today

// One public constructor each (the IOptions one). Removed: the AtyaProblemDetailsOptions overloads.
DefaultExceptionToProblemDetailsMapper(IOptions<AtyaProblemDetailsOptions> options)
public static DefaultExceptionToProblemDetailsMapper Create(AtyaProblemDetailsOptions options)   // tests, manual composition
public static DefaultResultToProblemDetailsMapper Create(AtyaProblemDetailsOptions options)
```

Interfaces `IExceptionToProblemDetailsMapper` and `IResultToProblemDetailsMapper` keep their signatures. New default `ErrorKind` rows:

| ErrorKind | Status | Title | Type URI | Detail and `errorCode` |
|---|---|---|---|---|
| TooManyRequests | 429 | Too Many Requests | `urn:atya:problem-type:too-many-requests` | shown (4xx) |
| Unavailable | 503 | Service Unavailable | `urn:atya:problem-type:service-unavailable` | masked (5xx policy, ATYA-014) |
| Timeout | 504 | Gateway Timeout | `urn:atya:problem-type:gateway-timeout` | masked (5xx policy) |

`Retry-After` is not emitted (an `Error` carries no retry hint); decided: no `Retry-After` for now.

## Behaviour

- **Snapshot.** Each mapper builds an immutable policy in its constructor: `FrozenDictionary<ErrorKind, ...>` for errors, an array sorted by inheritance depth for exceptions, a copy of extension names. Later mutation of `AtyaProblemDetailsOptions` has no effect on a constructed mapper. `AtyaProblemDetailsOptions` stays a mutable binding surface.
- **Startup validation** (`IValidateOptions`, `ValidateOnStart` in `AddAtyaProblemDetails`): every mapped status is within 400–599 unless `AllowNonErrorStatusCodes`; configured extension names are non-empty, mutually distinct, and not RFC 9457 reserved members; titles and types non-empty. The check lives in the snapshot builder, not in `Map<T>`, so setting the escape hatch after mapping calls still works.
- **Most-specific mapping.** Select the assignable mapping with the smallest inheritance distance to the thrown type. Exception classes have one inheritance chain, so distances are unique and ties cannot occur; a second registration for the same type replaces the first (as today). Registration order therefore never changes the outcome.
- **Customization on both paths.** After extensions are added, both mappers build one `ProblemDetailsCustomizationContext` (`Exception` set on the exception path, `Error` on the result path) and invoke `Customize`, then the obsolete sugar (exception path only). A customizer may overwrite Atya extensions; documented.
- **Trace id.** `Activity.Current` with a non-default `TraceId` (W3C format): `Activity.TraceId.ToString()`, 32 hex characters, no prefix. Otherwise `httpContext.TraceIdentifier`. A hierarchical `Activity.Id` is never emitted. The format is documented once in the README.
- `ConfigureAwait(false)` on the handler's awaits.

## Invariants and how tests prove them

1. Registration-order independence: permutation test over the default and custom mappings (all orders of N mappings give the same resolution).
2. Both paths call customization exactly once; context carries `Exception` xor `Error`.
3. A mapper is unaffected by post-construction option mutation (mutate, then map).
4. Invalid status, duplicate or reserved extension names fail host start.
5. `traceId` matrix: W3C activity, hierarchical activity, no activity. With a W3C activity, the value equals `Activity.TraceId`.
6. 429, 503 and 504 rows per `ErrorKind`; 503/504 detail is masked, 429 detail shown. Existing 5xx redaction tests unchanged.
7. DI test registers both `AtyaProblemDetailsOptions` and `IOptions<AtyaProblemDetailsOptions>`; both mappers resolve.
8. The log/response equality check (ATYA-144) cannot live here (no edge to Logging). It is an integration test in Middleware (see ATYA-055).

## Migration for consumers

- Breaking: removed public constructors; `traceId` value changes from full `traceparent` to 32-hex trace id (wire-visible, release-noted with both formats); non-error statuses now rejected at startup unless `AllowNonErrorStatusCodes`; mapping outcomes can change for apps that relied on registration order.
- `CustomizeProblemDetails` keeps working (obsolete warning).
- Requires `Foundation.Results` with the three new kinds (see prerequisite). Older consumers' 422 fallback for unknown kinds is unchanged.
- Last compatible version 1.x.

## Test plan

Unit and pipeline tests as above, extending the existing test files; byte-level snapshot of the existing response corpus must be identical except the `traceId` value and the new rows.

## PR breakdown

1. Snapshot, validator, most-specific resolution, status policy, single constructors with `Create`.
2. `ProblemDetailsCustomizationContext` on both paths, `AllowNonErrorStatusCodes`, `ConfigureAwait`.
3. Trace id format and new `ErrorKind` rows (after the Results release), docs and migration notes.

## Contradictions with ADRs and the plan

- ATYA-053's 429/503/504 rows depend on the three `ErrorKind` values; ATYA-045's deferral is superseded for them (see prerequisite). The same applies to hard dependencies ATYA-009 (wire contract, Deferred), and ATYA-025 and ATYA-066 (hard dependencies of ATYA-143 and ATYA-144, both Deferred): stale for this scope.
- ATYA-144 step 2 falls back to `Activity.Id` for hierarchical format. The owner's decision is `Activity.TraceId`; for hierarchical activities this design falls back to `TraceIdentifier` instead, so no response ever carries a non-APM value.
- ATYA-143 step 4 asks for a "one-public-constructor" analyzer in Governance.CodeQuality. Out of scope here (CodeQuality is SDK-injected); not proposed.
- ATYA-053 says "old property kept as sugar"; this design marks it obsolete. Owner choice.

## Decisions (2026-11-27)

- `CustomizeProblemDetails` is `[Obsolete]` in 2.0 (sugar, exception path only).
- No `Retry-After` for now.
- 503/504 detail is masked by default.
- `ErrorKind` values come from Results 1.2.0 (7, 8, 9); this supersedes ATYA-045's deferral for them.

# ATYA-055 (+ ATYA-139, 145): Atya.Web.Middleware 2.0.0

Status: Proposed for owner review. No code. Read against `Middleware` `development` at `eef9cff`.
Fixed by the owner: symmetric customization and trace id (delivered by ProblemDetails 2.0, see ATYA-053), one constructor per injectable type, 429/503/504 through the new `ErrorKind` values. Correlation behaviour follows the ATYA-022 design.

## Problem

Verified in source:

- `ResultHttpExtensions.ToProblemHttpResult` rebuilds the problem with `Results.Problem(detail, instance, statusCode, title, type, extensions)`. A custom `IResultToProblemDetailsMapper` returning a derived `ProblemDetails` (extra properties, `HttpValidationProblemDetails`) is flattened to the base shape (ATYA-055).
- Success is fixed: `Result` becomes 204, `Result<T>` becomes 200. A 201 with `Location`, a 202, or a custom header needs a bypass. There are six `ToHttpResult` overloads.
- `UseAtyaWebMiddleware` adds `AtyaCorrelationIdMiddleware` and the exception handler on every call, so calling it twice stacks both.
- `Middleware.csproj` references `Atya.Errors.Exceptions` directly; no source file uses it (it also arrives transitively through ProblemDetails).
- `AtyaCorrelationIdMiddleware` writes the correlation header eagerly. `UseExceptionHandler` calls `HttpResponse.Clear()` on an unhandled exception, which removes every header, so the header is present on 2xx and absent on 5xx (ATYA-139). The `correlationId` body extension hides this from body-level tests.
- `AddAtyaWebMiddleware` installs the accessor with `services.Configure<AtyaProblemDetailsOptions>(...)`, which runs in registration order. A consumer's later `Configure` overwrites the wrapper and silently disables the feature; calling `AddAtyaWebMiddleware` twice nests two wrappers (ATYA-145).
- The correlation value is taken from the inbound header without length, charset or multi-value checks, and never reaches log scope or `Activity` (ATYA-022).

## Public API, before and after

```csharp
// ResultHttpExtensions: six overloads collapse to three; mapper and success policy are optional.
IResult ToHttpResult(this Result r, HttpContext c, IResultToProblemDetailsMapper? mapper = null, HttpSuccess? success = null)
IResult ToHttpResult<T>(this Result<T> r, HttpContext c, IResultToProblemDetailsMapper? mapper = null, HttpSuccess<T>? success = null)
IResult ToHttpResult(this Error e, HttpContext c, IResultToProblemDetailsMapper? mapper = null)

public sealed class HttpSuccess        // immutable, factory + With* methods
{ static HttpSuccess NoContent(); Ok(); Accepted(); Created(string location); WithHeader(string name, string value); }
public sealed class HttpSuccess<T>     // same, but Created(Func<T,string> location) and WithHeader(name, Func<T,string>)

IApplicationBuilder UseAtyaWebMiddleware(this IApplicationBuilder app)   // idempotent per pipeline
IServiceCollection AddAtyaWebMiddleware(this IServiceCollection, ...)    // idempotent per collection
```

`AtyaWebMiddlewareOptions` gains the bounded correlation policy defined in the ATYA-022 design. The existing `Features.Get<AtyaCorrelationIdFeature>()` contract is unchanged. `Atya.Errors.Exceptions` is removed from the package dependencies.

## Behaviour

- **Mapped shapes preserved.** The mapped `ProblemDetails` object is returned through an internal `IResult` that sets the status code, sets `application/problem+json`, and serializes with the **runtime** type so derived properties and extensions survive. It reads `Microsoft.AspNetCore.Http.Json.JsonOptions` from the request services. Implementation must first test `Results.Problem(ProblemDetails)` / `TypedResults.Problem`; if those serialize the declared base type, the internal result is required. Acceptance stays: a derived problem round-trips with extra properties intact.
- **Success policy.** Defaults reproduce today (204 for `Result`, 200 for `Result<T>`). `Created(...)` returns 201 with `Location`; `WithHeader` adds a header. No overload matrix; any new shape is a new factory on `HttpSuccess`.
- **Registration.** `UseAtyaWebMiddleware` records a marker in `app.Properties`; a second call is a no-op. `AddAtyaWebMiddleware` adds a marker singleton and registers the accessor wiring only when the marker was newly added, and wiring is `PostConfigure<AtyaProblemDetailsOptions>` so any consumer `Configure` runs first and the consumer accessor becomes the fallback (ATYA-145). Failure mode when the pipeline was built without `AddAtyaWebMiddleware`: `InvalidOperationException` naming the missing call (as today for the mapper).
- **Correlation header.** `InvokeAsync` registers `Response.OnStarting` that writes the header from the feature, overwriting any value, and keeps the eager write. `OnStarting` callbacks and `HttpContext.Features` survive `Response.Clear()` (ATYA-139). It also performs the ATYA-022 steps: validate or regenerate the inbound id, begin a logger scope with `KnownLogPropertyNames.CorrelationId`, and set `Activity` tag and baggage.
- **Status rows.** Middleware owns no table. `Error` kinds `TooManyRequests`, `Unavailable`, `Timeout` map to 429, 503 and 504 in ProblemDetails 2.0; Middleware proves them end to end.

## Invariants and how tests prove them

1. Derived `ProblemDetails` from a custom mapper round-trips through a TestServer with all added properties.
2. `Result<T>` with `HttpSuccess<T>.Created(...)` returns 201 with `Location`; defaults still return 204/200.
3. Header present on 200, mapped 4xx, `Unavailable` 503 and unhandled-exception 500, and header equals the body `correlationId` and the feature value (TestServer matrix).
4. Registration order matrix for `AddAtyaWebMiddleware`: consumer `Configure` before, after, and twice. Result: feature id wins, consumer accessor is the fallback, exactly one wrapper (assert by counting `IPostConfigureOptions` registrations).
5. `UseAtyaWebMiddleware` twice produces one correlation middleware (request count of correlation scopes is one).
6. `dotnet pack` output has no `Atya.Errors.Exceptions` dependency in the nuspec; a packed consumer builds.
7. Cross-package: for one request, the response `traceId`, `Activity.TraceId`, and the `TraceId` scope value emitted by `Microsoft.Extensions.Logging` activity tracking are identical (this is ATYA-144's cross-package check, which cannot live in ProblemDetails).

## Migration for consumers

- Source-breaking only where code called the removed overloads by their exact shape; named and positional calls `ToHttpResult(ctx)` and `ToHttpResult(ctx, mapper)` still compile.
- Behaviour: derived problem shapes appear in responses (fidelity fix); header now present on error responses; junk inbound correlation ids are replaced (ATYA-022 release note); double registration is harmless.
- Requires ProblemDetails 2.0 and the Results release with the new kinds. Last compatible version 1.x.

## Test plan

TestServer pipeline tests above; the SP-08 regression named in the issue; a packed-nupkg restore test for the dependency list; registration-order matrix for every `Add*` helper owned by this repo.

## PR breakdown

1. Mapped-shape preservation and `HttpSuccess`; drop the Exceptions edge (ATYA-055).
2. Idempotent registration and `PostConfigure` wiring (ATYA-145); header via `OnStarting` (ATYA-139).
3. ATYA-022 Middleware part (policy, scope, Activity) after the Tracing change lands.
4. Docs, migration notes, cross-package traceId test.

## Contradictions with ADRs and the plan

- ATYA-145 step 5 asks this repository to make `AddAtyaHttpClient`, `AddAtyaWebHealthChecks`, `AddAtyaMediator` and `AddAtyaProblemDetails` idempotent. Those live in four other repositories. Proposal: each repository's own 2.0 PR carries its helper (Client in ATYA-023, Mediator in ATYA-062, ProblemDetails in ATYA-053, HealthChecks a small separate fix); ATYA-145 keeps only the Middleware helper.
- ATYA-139 and ATYA-145 declare hard dependencies on ATYA-022 and ATYA-055. ATYA-055 is genuine (same file ordering); ATYA-022 is a different repository and is only needed for the shared policy, so ATYA-139 can ship before it.
- ATYA-055 hard dependencies ATYA-034 (Deferred) and ATYA-002 are stale for this scope.
- No ADR conflict.

## Open questions for the owner

1. Second `UseAtyaWebMiddleware` call: silent no-op (recommended) or throw?
2. Should `HttpSuccess` live in this package (recommended) or be left to callers?
3. Is the internal `IResult` acceptable, given it takes over serialization options, or do you prefer relying on `TypedResults.Problem` if it preserves derived shapes? Implementation will test and report.

# ATYA-023 (+ ATYA-138, 132): Atya.Http.Client 2.0.0

Status: Proposed for owner review. No code. Read against `Client` `development` at `c9ee218`.
Fixed by the owner: transport exceptions become `Result` failures, bounded body read, transport status wins, an internal RFC 9457 type, no `ProblemDetails` or ASP.NET Core reference.

## Problem

Verified in source:

- `SendAsync` and `SendJsonAsync` call `HttpClient.SendAsync` with no `try`. DNS, socket, TLS, `HttpRequestException` and `HttpClient.Timeout` (a `TaskCanceledException`) all throw out of a method that is documented to return `Result`.
- `ProblemDetailsErrorMapper.Map` takes the kind from `problemDetails.Status ?? transportStatus`. A 502 whose body says `"status":200` yields a 200-derived kind.
- `ReadFromJsonAsync` is used for both error and success bodies: unbounded size (chunked included), default depth, and it throws `NotSupportedException` for a non-JSON content type (a proxy's `text/html` 502/503/504) or `JsonException` on a truncated success body. The error path catches only `JsonException` (ATYA-138).
- `Error.Target` is `requestUri.ToString()`, which keeps the query string and any user info.
- `Client.csproj` references `Atya.Errors.ProblemDetails`, which carries `FrameworkReference Microsoft.AspNetCore.App`. Every consumer of the client, including workers, MAUI and Blazor WebAssembly, inherits it. `AtyaHttpClientOptions.ProblemDetailsOptions` exposes the server `AtyaProblemDetailsOptions`, and the client compiles against `Microsoft.AspNetCore.Mvc.ProblemDetails` (ATYA-132).
- The correlation id is added from an accessor with no validation (handled in the ATYA-022 design).

## Public API, before and after

Before (1.x): `AtyaHttpClient(HttpClient, IOptions<AtyaHttpClientOptions>)`, `SendAsync`, `SendJsonAsync<T>`; `AtyaHttpClientOptions { CorrelationIdHeaderName, CorrelationIdAccessor, JsonSerializerOptions, ProblemDetailsOptions }`; `AtyaHttpClientErrors { HttpFailure, EmptyJsonResponse, internal MapStatusCode }`.

After (2.0.0):

```csharp
public sealed class AtyaHttpClient(HttpClient httpClient, IOptions<AtyaHttpClientOptions> options, ILogger<AtyaHttpClient> logger)
{ Task<Result> SendAsync(HttpRequestMessage, CancellationToken); Task<Result<T>> SendJsonAsync<T>(HttpRequestMessage, CancellationToken); }

public sealed class AtyaHttpClientOptions
{   // removed: ProblemDetailsOptions
    int MaxResponseBodyBytes = 1_048_576;   int MaxProblemBodyBytes = 65_536;   int MaxJsonDepth = 32;
    IDictionary<int, ErrorKind> StatusKindOverrides;                     // replaces the server option type
    AtyaHttpErrorTarget ErrorTarget = AtyaHttpErrorTarget.OriginAndPath; // Origin | OriginAndPath; never query, user info or fragment
    JsonSerializerOptions JsonSerializerOptions;                         // cloned and frozen at client construction
}
internal sealed class ProblemDocument { type, title, status, detail, instance, [JsonExtensionData] extensions }   // RFC 9457, client-owned
```

New stable error codes in `AtyaHttpClientErrors`: `transport_failure` (Unavailable), `timeout` (Timeout), `body_too_large` (Failure), `malformed_payload` (Unexpected), `unexpected_content_type` (Unexpected, from ATYA-138). `http_failure` and `empty_json_response` remain. The package no longer references `Atya.Errors.ProblemDetails` or any `Microsoft.AspNetCore.*` type, and no new package is created.

## Behaviour and failure modes

**Exception boundary** (written down so it is a release-noted contract):

| Situation | Outcome |
|---|---|
| Null request, no resolvable URI, invalid options | throws before I/O (`ArgumentException`/`InvalidOperationException`) |
| Caller's token cancelled | `OperationCanceledException` propagates |
| `HttpRequestException` (DNS, socket, TLS, proxy) | `Result` failure `transport_failure`, kind `Unavailable`; the exception is logged, never wrapped or exposed |
| `TaskCanceledException`/timeout while the caller's token is not cancelled | failure `timeout`, kind `Timeout` |
| `IOException` or `HttpRequestException` while reading the body | failure `transport_failure` |
| Body larger than the bound (declared length or counted while streaming, chunked included) | failure `body_too_large`; no more than the bound plus one buffer is ever held |
| Success with non-JSON or missing media type, or truncated JSON | failure `unexpected_content_type` / `malformed_payload` |
| Error status with non-JSON, missing, oversized or malformed body | failure `http_failure` from the transport status alone |
| Any other exception | propagates (it is a bug, not an operational failure) |

- **Transport status wins.** `Kind` comes from the HTTP status through one client-owned table: 400 Validation, 401 Unauthorized, 403 Forbidden, 404 NotFound, 408 and 504 Timeout, 409 Conflict, 429 TooManyRequests, 503 Unavailable, other 5xx Unexpected, other 4xx Failure, with `StatusKindOverrides` on top. A body `status` that differs is ignored and logged once at warning level with both values. (`Error` has no diagnostics field, so the log is the diagnostic channel.)
- **Parsing.** An error body is parsed only when the media type is `application/json` or `application/*+json` and the body is within `MaxProblemBodyBytes`; `errorCode` and `errors` extensions are read from the extension bag with the same names and shapes the server emits. `detail`/`title` text is truncated to 512 characters (it is remote-controlled).
- **Targets.** `Error.Target` is built from scheme, host, port and (by default) path only; query, user info and fragment never appear. Logs use the same redacted form.
- **Serializers.** `JsonSerializerOptions` is copied at construction; `MaxDepth` is forced to `MaxJsonDepth`.

## Invariants and how tests prove them

1. `SendAsync`/`SendJsonAsync` never throw an operational exception: a fake handler injects `HttpRequestException` (each `HttpRequestError` value), `TaskCanceledException`, `IOException` mid-body, and assertions check a failed `Result` with no exception type or message in `Message`.
2. Cancellation is distinguished: caller token cancelled gives `OperationCanceledException`; timeout with a live token gives the `timeout` failure.
3. A 502 with body `"status":200` yields `Unexpected`; 429/503/504 yield the new kinds.
4. Bounds hold: 1 GiB chunked stream stops at the bound; depth 100 payload fails; declared length above the bound fails before reading.
5. Media-type matrix (138): success and failure statuses crossed with `text/html`, `text/plain`, absent, malformed, `application/problem+json`; problem details still map with details preserved.
6. No `?` or `@` in any `Error.Target` for a corpus of URLs with query strings and user info.
7. Restore graph (132): a `Microsoft.NET.Sdk` (not `.Web`) `net10.0` console and worker project, plus a Blazor WebAssembly project, reference the **packed** `.nupkg` from a local feed, build, and the test asserts `project.assets.json` contains no `Microsoft.AspNetCore.App` framework reference and no `Atya.Errors.ProblemDetails` package.
8. Parity (test-only reference to ProblemDetails in the test project): a server-emitted problem corpus is parsed by the client with the same `errorCode`, `errors` and kind outcomes. This replaces the shared contract that ATYA-009 would have provided.

## Migration for consumers

- Breaking: `AtyaHttpClientOptions.ProblemDetailsOptions` is removed (use `StatusKindOverrides`); code that caught `HttpRequestException` or `TaskCanceledException` from the client must now inspect the `Result`; error `Target` loses the query string; error kinds change for transport failures and for bodies that disagreed with the status.
- Callers with `try/catch` around client calls can remove it. Callers depending on caller-cancellation behaviour are unaffected.
- Last compatible version 1.x. The Constitution matrix edge `Http.Client -> ProblemDetails` is removed.

## Test plan

Handler-stub unit tests for 1-6; packed-consumer restore fixtures for 7 (CI job per fixture, one TFM, per ADR-01); parity test for 8; SP-09 probes named in the issue re-run.

## PR breakdown

1. Drop the ProblemDetails reference: internal `ProblemDocument`, status table, options change, restore-graph fixtures (ATYA-132).
2. Exception boundary, bounded reads, content-type handling, target redaction, logging (ATYA-023 and ATYA-138).
3. Correlation handler hookup from the ATYA-022 design; docs and migration notes.

## Contradictions with ADRs and the plan

- **ATYA-132 step 1 creates `Atya.Errors.ProblemDetails.Abstractions`.** That contradicts the Plan v2 rule "no new packages until ATYA-075 and ATYA-153 are done" and the Constitution's "extract, never invent" rule for abstractions packages. The owner's decision (internal type) replaces it, so ATYA-132 should be rewritten accordingly and its PackageId/allowlist/manifest steps dropped.
- ATYA-023 and ATYA-132 hard-depend on ATYA-009 and ATYA-032, ATYA-052 (all Deferred). The ADR-less wire contract is replaced by item 8 above; revisit if ATYA-009 is ever un-deferred.
- The kinds `Unavailable`, `Timeout`, `TooManyRequests` need the Results release (ATYA-045, Deferred; see ATYA-053 design). Until then the client could only emit `Unexpected`/`Failure`.
- ATYA-023 asks that body disagreement "yields diagnostics". `Error` has no diagnostics field; this design uses logging.

## Open questions for the owner

1. Add `ILogger<AtyaHttpClient>` as a constructor dependency (recommended; the connection failure is otherwise invisible)? It is a breaking constructor change.
2. Default `MaxResponseBodyBytes` of 1 MiB: right for your consumers, or larger?
3. Keep `OriginAndPath` as the default target, or `Origin` only (safer, less useful)?

# ATYA-022: Correlation across Middleware, Client, ProblemDetails, Logging and Tracing

Status: Proposed for owner review. No code. Read against `Middleware` `eef9cff`, `Client` `c9ee218`, `ProblemDetails` `7310b7b`, `Logging` `edcf62c`, `Tracing` `ae4c307` (all `development`).
Constraint from the owner: no new package. The Constitution edges this needs are listed at the end for separate approval in `platform`.

## Problem

Verified in source:

- The header name `X-Correlation-ID` is a literal in `AtyaWebMiddlewareOptions`, `AtyaHttpClientOptions` and `AtyaProblemDetailsOptions.DefaultCorrelationIdAccessor` (three owners).
- `Logging` defines the scope property `CorrelationId` (`KnownLogPropertyNames`, `BeginCorrelationScope`); `Tracing` defines the tag `correlation.id` (`TracingTagNames`, `ActivityExtensions.SetCorrelationId`). Nothing connects them to `Middleware` or `Client`: `Middleware` references neither package.
- Inbound values are accepted with only a `Trim()`: any length, any characters, first non-empty value wins. A value with line breaks or megabytes of text reaches the response header, logs and the problem body.
- The accepted id never reaches a log scope, an `Activity`, or an outbound request. `AtyaHttpClient` only applies the id returned by a user-supplied `Func<string?>`, default `null`.
- Defect found while reading: `TraceContextSnapshot.WriteTo` writes the correlation id under the header key `TracingTagNames.CorrelationId` (`"correlation.id"`, a tag name), not a header name.

## Where each piece lives (the layering problem)

ATYA-022 says "Middleware owns the concept". The Constitution layers packages `Foundation` → `Errors`/`Diagnostics` → `Http`/`Hosting`/`Messaging` → `Web`/`Application`, with no upward edges. `Client` (Http) and `ProblemDetails` (Errors) sit **below** `Middleware` (Web), so they cannot depend on it, and a literal-free design needs a shared owner below all of them. `Atya.Diagnostics.Tracing` already owns the `correlation.id` tag and carries the id in `TraceContextSnapshot`, and it is below both `Middleware` and `Client`. Decision (approved): **Tracing owns the concept.** Middleware owns request handling.

| Piece | Owner (existing package) |
|---|---|
| Default header name constant, id policy (max length, charset, normalise, generate), carrier names | `Tracing` |
| Log scope property name | `Logging` (unchanged) |
| Inbound handling: accept predicate, validate or regenerate, response header, log scope, `CorrelationContext` and Activity tag | `Middleware` |
| Reading the id for problem bodies | `ProblemDetails` options accessor; wired by `Middleware` |
| Outbound propagation | `Client` (`CorrelationPropagationHandler`) |

## Public API, before and after

```csharp
// Atya.Diagnostics.Tracing (new, additive)
public static class CorrelationHeader { public const string DefaultName = "X-Correlation-ID"; }
public sealed class CorrelationIdPolicy
{
    int MaxLength = 128;  Func<char,bool> IsAllowedChar = alphanumeric or one of  - _ . :
    string? Resolve(IEnumerable<string?> inboundValues);   // null when empty, too long, bad char, or several distinct values
    string Generate();                                      // Guid "N"
}
public static class CorrelationContext        // AsyncLocal ambient carrier
{ string? Current { get; }  IDisposable Push(string id); /* also sets the correlation.id tag on Activity.Current when one exists; restores on dispose */ }
// ActivityExtensions.SetCorrelationId (exists) is unchanged. No Activity baggage, no manufactured Activity.

// Atya.Web.Middleware options (additive)
AtyaWebMiddlewareOptions.CorrelationPolicy;  Func<HttpContext,bool> AcceptInboundCorrelationId = _ => true;   // trusted-proxy hook

// Atya.Http.Client
public sealed class CorrelationPropagationHandler : DelegatingHandler   // added by AddAtyaHttpClient
// AtyaHttpClientOptions.CorrelationIdAccessor stays as a fallback when no Activity carries an id.

// Atya.Errors.ProblemDetails: AtyaProblemDetailsOptions.CorrelationIdAccessor default changes from header sniffing to "returns null".
```

## Behaviour

- **Inbound (Middleware).** If `AcceptInboundCorrelationId` is true, resolve the header values through the policy; otherwise, or when resolution returns null, generate a new id. Several distinct values are invalid by policy (no guessing which one is real). Set the `AtyaCorrelationIdFeature`, write the response header via `OnStarting` (ATYA-139), begin `logger.BeginCorrelationScope(id)` for the request, and `CorrelationContext.Push(id)` (which also tags `Activity.Current` when one exists).
- **Carrier (decided).** The id travels in `CorrelationContext`, an `AsyncLocal<string?>` owned by Tracing. When an Activity exists, the `correlation.id` tag is also set on it. Activity baggage is not used (the default propagator would forward it to every outgoing call, third parties included) and no Activity is manufactured (it would change `Activity.Current` for the whole app). Reading the carrier needs no `HttpContext` and no ASP.NET reference in `Client`.
- **Outbound (Client).** The handler adds the header explicitly from `CorrelationContext.Current` (fallback: the options accessor), validates it with the same policy, and sets the configured header only if the request has none. An invalid id is omitted and logged once. `AtyaHttpClient.ApplyCorrelation` is removed in favour of the handler.
- **ProblemDetails.** The body extension comes from the accessor; Middleware's `PostConfigure` (ATYA-145) sets it from the feature. Used alone, ProblemDetails no longer reads the request header: no literal remains.
- **Header rename.** `CorrelationIdHeaderName` is configured in Middleware and in Client separately; both default to `CorrelationHeader.DefaultName`. Renaming in both breaks nothing; renaming in only one is a configuration mistake and is documented.
- **Tracing fix.** `TraceContextSnapshot.WriteTo` switches to `CorrelationHeader.DefaultName`. This is wire-visible for anyone parsing the old `correlation.id` key; release-noted.

## Invariants and how tests prove them

1. Policy: oversized, control-character, space-containing, empty and duplicate-distinct inputs are regenerated; a valid id of exactly 128 characters is kept (boundary tests on `CorrelationIdPolicy`, no HTTP needed).
2. End to end (the acceptance test, a two-service sample on two TestServers): inbound id X appears in service A's response header, A's log scope, A's Activity tag, the outbound request header, and service B's response header and log scope. Invalid inbound input is replaced consistently everywhere.
3. Works with no listener and no Activity: same test with no `ActivitySource` listeners still propagates; with an Activity present, its `correlation.id` tag equals the id; no `baggage` header is sent to the downstream service.
4. Rename test: custom header name configured in both services; nothing else changes.
5. `AcceptInboundCorrelationId = false` ignores a valid inbound header.
6. The header is present on error responses (shared with ATYA-139).
7. No `"X-Correlation-ID"` literal remains outside `Tracing` (a source grep test in each repository's CI).

## Migration for consumers

Junk inbound ids are now replaced (release note, behavioural). Standalone ProblemDetails users lose automatic header sniffing and must set the accessor or use Middleware. Client users get automatic propagation when `AddAtyaHttpClient` is used and an id is present. The Tracing `WriteTo` key change is the only wire change outside correlation handling.

## Test plan

Unit tests per package for 1, 5, 7; integration tests in `Middleware` (which gains test-time references to `Client`) for 2 to 4 and 6. The end-to-end test is the single acceptance proof; it must run in CI on a packed-package build, not project references.

## PR breakdown and release order

1. Tracing 1.2.0: policy, header constant, `CorrelationContext`, `WriteTo` fix (behavioural fix in a minor; not part of the Wave 1 Tracing 1.1.0). Release first.
2. ProblemDetails 2.0 and Results kinds (see ATYA-053).
3. Middleware 2.0 (see ATYA-055) adopting the policy.
4. Client 2.0 (see ATYA-023) with the handler.
5. Two-service sample and docs.

## Constitution edges needed (for approval in `platform`)

Matrix rows to amend (all downward, no layering change):

| Package | Now | Proposed |
|---|---|---|
| `Atya.Web.Middleware` | Exceptions, ProblemDetails, Guards | ProblemDetails, Guards, **Logging, Tracing** (Exceptions removed, ATYA-055) |
| `Atya.Http.Client` | Guards, Results, ProblemDetails | Guards, Results, **Tracing** (ProblemDetails removed, ATYA-023) |
| `Atya.Diagnostics.Tracing` | Guards | Guards (unchanged; scope widens, README note) |
| `Atya.Application.Idempotency` | Guards, Time, Results | Guards, Results (Time removed, ATYA-057) |
| `Atya.Messaging.Outbox` | Abstractions, Time, Serialization, Guards | Abstractions, Serialization, Guards (Time removed, ATYA-058) |

No edge is added to `ProblemDetails`, `Logging`, `BackgroundServices` or `Mediator`. After the Idempotency and Outbox changes `Atya.Foundation.Time` has no internal consumer; whether to deprecate it is a separate decision under ADR-02 and is not proposed here.

## Contradictions with ADRs and the plan

- ATYA-022 puts ownership in Middleware, which the Constitution layering forbids for `Client` and `ProblemDetails` (above).
- ATYA-022 lists "Atya.Roadmap" as the owning repository and a single change; implementation necessarily splits across five repositories (above).
- Hard dependency ATYA-034 is Deferred in Plan v2; ATYA-019 is the reference policy and is not a code dependency.
- ATYA-022 asks the Client to ship the handler "registered by AddAtyaHttpClient" while ATYA-132's removal of ASP.NET references applies: consistent, because the handler uses only `System.Diagnostics`.

## Decisions (2026-11-27)

- Tracing owns the correlation concept (approved); no new package.
- Carrier changed: `CorrelationContext` (AsyncLocal) in Tracing; when an Activity exists the `correlation.id` tag is also set. No Activity baggage and no manufactured Activity (baggage would reach third parties; a manufactured Activity changes `Activity.Current` app-wide). The Client handler adds the header explicitly.
- Default charset (alphanumeric plus `- _ . :`) and 128-character limit accepted.
- The `TraceContextSnapshot.WriteTo` header-key fix is accepted as a behavioural fix in a minor, shipped in Tracing 1.2.0 with this work, not in Wave 1's Tracing 1.1.0.

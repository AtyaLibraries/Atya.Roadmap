# Implementation designs: NEXT: FIXES lane

Status: Proposed for owner review. Design documents only; no library code, no issue or board changes, nothing merged or published. Each design was written against the `development` branch of its repository in a fresh clone (commit hashes are in each file).

| Design | Items | Package(s) |
|---|---|---|
| [ATYA-057](ATYA-057-idempotency-2-0.md) | 057, 140 | Application.Idempotency 2.0.0 |
| [ATYA-058](ATYA-058-outbox-2-0.md) | 058, 146 | Messaging.Outbox 2.0.0 |
| [ATYA-062](ATYA-062-mediator-2-0.md) | 062, 142 | Application.Mediator 2.0.0 |
| [ATYA-021](ATYA-021-backgroundservices-2-0.md) | 021, 134, 135, 136 | Hosting.BackgroundServices 2.0.0 |
| [ATYA-053](ATYA-053-problemdetails-2-0.md) | 053, 143, 144 | Errors.ProblemDetails 2.0.0 |
| [ATYA-055](ATYA-055-middleware-2-0.md) | 055, 139, 145 | Web.Middleware 2.0.0 |
| [ATYA-023](ATYA-023-client-2-0.md) | 023, 138, 132 | Http.Client 2.0.0 |
| [ATYA-022](ATYA-022-correlation.md) | 022 | Tracing, Middleware, Client, ProblemDetails, Logging |
| [ATYA-075](ATYA-075-reference-app.md) | 075 | Golden API + worker in `Atya/reference/` (no package) and the composition readiness gate |

## Cross-cutting findings

1. **The new `ErrorKind` values arrive in Results 1.2.0.** `Unavailable`, `Timeout` and `TooManyRequests` (values 7, 8, 9) are added in Results 1.2.0 (owner decision), which supersedes ATYA-045's deferral for them. ATYA-053, 055 and 023 depend on that release.
2. **The issues still say `IClock`.** ATYA-057, 058, 140 and 021 assume `IClock` and the Governance.Testing `FakeClock` (ATYA-051, Deferred). ADR-02 says `TimeProvider`; the designs use it and `FakeTimeProvider`. After 057 and 058 ship, `Atya.Foundation.Time` has no internal consumer.
3. **Stale hard dependencies.** Many "hard dependencies" point at items Plan v2 deferred or rejected (for example 051, 059, 033, 034, 009, 025, 066 Deferred; 112 Rejected). Plan v2 says Blocked items keep only real code-order dependencies. The designs name the real ones; the issues are untouched.
4. **ATYA-132 creates a new package** (`Atya.Errors.ProblemDetails.Abstractions`), against the Plan v2 "no new packages" rule. The owner's decision (an internal RFC 9457 type in the Client) replaces it.
5. **ATYA-142 contradicts ATYA-062** on `IMediator` lifetime (singleton versus resolving from the ambient scope); the design keeps `IMediator` Scoped and cheap.
6. **ATYA-022 ownership is forbidden by layering** (Client and ProblemDetails sit below Middleware); the design puts the concept in Tracing.
7. **ATYA-058 and 146 conflict with the fixed decisions** on upcasters (deferred) and on persisting stack traces (not persisted).

## Suggested release order

Results 1.2.0 (Wave 1, already in flight) and Tracing 1.2.0 (correlation policy) first, then ProblemDetails 2.0.0, Middleware 2.0.0 and Client 2.0.0. Idempotency, Outbox, Mediator and BackgroundServices are independent of that chain and of each other, except that the Outbox relay recipe consumes BackgroundServices 2.0.0.

## Constitution edges (approve separately in `platform`)

Listed in [ATYA-022](ATYA-022-correlation.md): Middleware gains Logging and Tracing and loses Exceptions; Client gains Tracing and loses ProblemDetails; Idempotency and Outbox lose Time.

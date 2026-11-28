# ATYA-075: Composition readiness gate and golden reference applications

Status: Proposed for Coordinator review, with decisions flagged. Design only: no code, no issue, board or platform changes.
Read against `AtyaLibraries/Atya` `main` (CI: `.github/workflows/ci.yml`; the release tags listed below), issue Atya.Roadmap#32, PLAN-V2, ADR-13, ADR-14, and `platform/CONSTITUTION.md`.

## Summary

- Two small golden applications, an **API** and a **worker**, live in the Atya monorepo under `reference/`, with their own solution and their own `Directory.Packages.props`. They are outside `Atya.slnx`, so they are never packed.
- They consume Atya **only as published NuGet packages**, at the versions an adopter would install today. The library pipeline is untouched.
- The readiness gate is a new `reference` CI job with two parts:
  - The **published** leg is blocking. It does a locked restore from nuget.org, then build and scenario tests.
  - The **candidate** leg is advisory. It runs the same tests against the packages packed from `main`, to catch a composition break before a release.

  A dispatchable **evidence run** adds checks that must not turn `main` red when a release lands: version currency, provenance and package coverage. It writes the report that marks ATYA-075 Done.
- The scenario tests cover the issue's list: restore, build and test from packed packages; 5xx secrecy; validation round trips; cancellation; health; correlation and telemetry; idempotency; the outbox and worker lifecycle; release provenance.
- The design uses none of the Deferred items (009, 025, 051, 052, 063) and none of ATYA-153's provider: the in-memory stores are used throughout.
- **Finding:** Errors.ProblemDetails 2.0.0 still writes validation errors as a JSON **array** on the exception path and as an object map on the Result path. Http.Client 2.0.0 reads only the map. So "validation round trips" cannot fully pass on the published set while ATYA-052 (the fix) is Deferred. Decision R1.

## Where the applications live

```
reference/                                   # monorepo root sibling of packages/ (not under packages/)
  Atya.Reference.slnx                        # its own solution; NOT in Atya.slnx
  Directory.Packages.props                   # published Atya.* versions (adopter view), CPM + transitive pinning
  README.md                                  # what each app demonstrates; "not a template"; package coverage table
  src/Atya.Reference.Api/                    # Microsoft.NET.Sdk.Web, minimal APIs
  src/Atya.Reference.Worker/                 # Microsoft.NET.Sdk.Worker
  tests/Atya.Reference.Tests/                # xUnit v3 / MTP; API + worker scenarios
  eng/Test-ReferenceComposition.ps1          # coverage, currency, prerelease and not-packed checks
  eng/Test-ReferenceProvenance.ps1           # repository/commit/tag and signature checks per restored package
  eng/New-CandidateVersions.ps1              # writes the candidate version overrides from the pack artifact
```

Why `reference/` and not `packages/<X>/samples` or root `samples/`:
- Per-package samples already exist and use project references. These apps compose **many** packages through **package** references, so they belong to no single package.
- Keeping them outside `packages/` keeps the existing per-package tooling (`Invoke-PackageTests.ps1 -Root packages`, `Test-SolutionFilters.ps1`, the per-package coverage gate) unchanged.
- The name says what they are: a reference composition, not samples of one package.

How "not packed" is guaranteed, three ways:
1. They are not in `Atya.slnx`, so `dotnet pack Atya.slnx` (the CI pack job) never sees them.
2. Every project sets `<IsPackable>false</IsPackable>` explicitly. Microsoft.NET.Sdk.Web's default is not relied on, and the worker SDK has no such default.
3. `Test-ReferenceComposition.ps1` fails if the pack artifact contains any `Atya.Reference.*` package.

Build shape (how an adopter builds):
- The projects use the Microsoft SDKs (`Microsoft.NET.Sdk.Web` / `.Worker`), **not** `Atya.Build.Sdk`, which is the library packaging SDK.
- They share the root `global.json` for the .NET SDK version.
- They have `TreatWarningsAsErrors`, nullable enabled, and a checked-in `packages.lock.json` per project.
- There is no `nuget.config` (forbidden by the Constitution). Candidate sources are passed on the command line.

## What they compose

All versions below are the **latest stable on nuget.org on 2026-11-28**, matching the monorepo release tags. They are pinned in `reference/Directory.Packages.props`. Renovate (already configured for the monorepo) proposes a bump after every release, and that bump PR runs the gate against the new version.

| Package | Version | API | Worker | Exercised by |
|---|---|---|---|---|
| Atya.Web.Middleware | 2.0.0 | ✓ | | exception and Result mapping at the edge, correlation boundary |
| Atya.Errors.ProblemDetails | 2.0.0 | ✓ | | RFC 9457 bodies, 5xx redaction (ATYA-014) |
| Atya.Errors.Validation | 1.2.0 | ✓ | | request validation as failure `Result`s |
| Atya.Errors.Exceptions | 1.0.0 | ✓ | | taxonomy exceptions on the exception path |
| Atya.Foundation.Results | 1.2.0 | ✓ | ✓ | every handler returns `Result`/`Result<T>` |
| Atya.Foundation.Guards | 1.1.0 | ✓ | ✓ | domain constructors |
| Atya.Foundation.Primitives | 1.0.2 | ✓ | | value objects (order id) |
| Atya.Foundation.Serialization | 1.1.0 | ✓ | ✓ | one `JsonSerializerOptions` for HTTP and messages |
| Atya.Application.Mediator | 2.0.1 | ✓ | | endpoint → handler dispatch (no pipeline behaviours; 063 Deferred) |
| Atya.Application.Idempotency | 2.0.0 | ✓ | ✓ | `Idempotency-Key` on POST (API); dedupe by `MessageId` (worker); in-memory store |
| Atya.Data.Pagination | 1.1.0 | ✓ | | `GET /orders` paging |
| Atya.Web.HealthChecks | 1.1.0 | ✓ | ✓ | `/health/live`, `/health/ready` (ATYA-015) |
| Atya.Diagnostics.OpenTelemetry | 2.0.1 | ✓ | ✓ | tracing and metrics wiring |
| Atya.Diagnostics.Tracing | 1.2.0 | ✓ | ✓ | correlation policy (ATYA-022) |
| Atya.Diagnostics.Logging | 1.0.3 | ✓ | ✓ | structured logging, correlation scope |
| Atya.Diagnostics.Metrics | 1.0.2 | ✓ | ✓ | bounded-tag counters (ATYA-070 caveat) |
| Atya.Diagnostics.Observation | 1.0.2 | ✓ | ✓ | operation observation around handlers and jobs |
| Atya.Http.Client | 2.0.0 | | ✓ | worker → API calls; ProblemDetails → `Result` |
| Atya.Hosting.BackgroundServices | 2.0.0 | | ✓ | periodic poller and relay host, validated per-worker options (ATYA-021) |
| Atya.Messaging.Abstractions | 1.1.0 | | ✓ | envelopes, publisher and handler contracts |
| Atya.Messaging.InMemory | 1.0.0 | | ✓ | the in-process bus |
| Atya.Messaging.Outbox | 2.0.0 | | ✓ | in-memory outbox store, `OutboxRelay`, contract registry |

Not composed, with reasons recorded in `reference/README.md` and checked by the coverage script:
- `Atya.Foundation.Abstractions`: transitive only.
- `Atya.Governance.Testing`: not needed while ATYA-051 is Deferred. Tests use `Microsoft.Extensions.TimeProvider.Testing`. It becomes a test dependency when ATYA-148 ships (see Tests).
- `Atya.Governance.CodeQuality`: a library analyzer pack, under overhaul in ATYA-025 (Deferred). Adopting it in application code is not a documented scenario (Q2).
- Excluded as build tools or templates rather than runtime libraries: `Atya.Build.Sdk`, `Atya.Tooling.Cli`, `Atya.Templates.*`.

Test-only third-party packages in `reference/Directory.Packages.props`:
- `Microsoft.AspNetCore.Mvc.Testing` 10.0.x
- `Microsoft.Extensions.TimeProvider.Testing`
- `OpenTelemetry.Exporter.InMemory`, on the same 1.15.x line that Atya.Diagnostics.OpenTelemetry 2.0.1 uses (pinned together)

### The two applications

The applications stay deliberately small: about 10 endpoints and handlers in total.

**Atya.Reference.Api** ("Orders"):
- `POST /orders`
  - validates the body with Errors.Validation and dispatches via the Mediator
  - runs under `IdempotentExecutor` keyed by the `Idempotency-Key` header, with the in-memory store and `SuccessOnly` per ADR-12
  - returns `201` and a `Location` header
- `GET /orders?page=&pageSize=&status=`: Pagination.
- `GET /orders/{id}`: a `NotFound` `Result` becomes `404` ProblemDetails.
- `POST /orders/{id}/fulfil`: idempotent by header. The worker calls it.
- `/health/live`, `/health/ready`: `MapAtyaWebHealthChecks`. Readiness includes one app check that the test host can flip.
- Composition order in `Program.cs`: logging, tracing, metrics and observation; OpenTelemetry; ProblemDetails; web middleware; mediator; health. This order is what `ATYA-API-TEMPLATE.md` would record (D3).

**Atya.Reference.Worker** ("Fulfilment"):
- A periodic poller (`AddAtyaBackgroundService`) calls `GET /orders?status=placed` through the Atya Http.Client. For each order it enqueues `OrderAccepted` in the outbox (in-memory store).
- A second periodic service runs `OutboxRelay` passes into the Messaging.InMemory bus, following the ATYA-058 hosting recipe: one scope per pass, contract registry `orders.accepted@1`.
- The `OrderAccepted` handler dedupes on `MessageId` through Idempotency, then calls `POST /orders/{id}/fulfil` with `Idempotency-Key = MessageId`.
- Each process uses its own in-memory stores, because in-memory stores are single-process. Moving the outbox into the API process is a follow-up once a durable provider exists (ATYA-153). This design does not depend on it.

## Tests that prove the composition end to end

There is one test project, `Atya.Reference.Tests` (xUnit v3 on MTP per ADR-10, the house assertion library per ADR-11):
- The API runs in-process through `WebApplicationFactory<Program>`.
- The worker runs as a real `IHost` whose Atya HTTP client is pointed at the factory's server handler, so the worker→API traffic is genuine HTTP through both stacks with no sockets.
- Endpoints needed only to provoke failures (throw with a secret, throw `ValidationException`, slow handler) are added **by the test host** through `ConfigureWebHost`. The golden app itself never ships them.
- Waiting uses `FakeTimeProvider` where a package accepts a `TimeProvider`, and bounded polling otherwise. There is never a fixed sleep.

| # | Scenario | Asserts |
|---|---|---|
| A1 | Create order, then replay with the same `Idempotency-Key`, then the same key with a different body | `201`; the replay returns an identical body and the handler ran once; a different payload gives `409` with the `payload_mismatch` code |
| A2 | Validation via a failure `Result` | `400` ProblemDetails with an `errors` object map; the **Atya Http.Client** returns a failure `Result` holding **every** field error with its code and target (wire round trip) |
| A3 | Validation via a thrown `ValidationException` | See R1. Recommended: a known-gap test that asserts today's divergence (array on the wire, zero details in the client), named and linked to ATYA-148/052, so the fix flips it visibly |
| A4 | 5xx secrecy | A thrown exception carrying a connection string and a nested inner exception, and an `Unexpected` failure `Result`, both give `500` with a generic `detail`. The body has no message text, stack, exception type or secret substring, and does carry the correlation/trace id (ATYA-014). The secret also never appears in captured logs below Error. |
| A5 | Not found | `404` ProblemDetails with the stable `type`/`code` |
| A6 | Client cancellation | Cancel during the slow endpoint. The handler's token is cancelled, no Error-level log or `500` body is produced, and the response follows Middleware 2.0's documented client-abort behaviour. If that behaviour is undocumented, the test records a finding issue; no fix is made under 075. |
| A7 | Health | Live and ready return `200` with minimal bodies (no versions, exception text or check details). Flipping the app check makes ready return `503`, still minimal, while live stays `200` (ATYA-015). |
| A8 | Correlation | An inbound valid correlation id is honoured and echoed; an oversized or invalid one is replaced. The id appears in the log scope, the ProblemDetails body and the outgoing Http.Client header of the worker's call (ATYA-022). |
| A9 | Telemetry | Through the in-memory exporter: the server span uses the route template, not the raw path; the client span comes from Http.Client in the worker; parent/child linkage holds across worker→API; Atya metrics are emitted with bounded tags only (no ids). |
| W1 | Worker end to end | Placed order → poll → outbox → relay → bus → handler → fulfil. The order is `fulfilled`, and the outbox row is `Published` exactly once. |
| W2 | Duplicate delivery | The same envelope is delivered twice (a test publisher decorator re-sends). The fulfil endpoint's side effect happens once, through Idempotency on both sides. |
| W3 | Poison message | A handler that always fails: the relay follows backoff (`JitterFactor = 0`), the row is `Failed` after `MaxAttempts`, and the worker stays healthy. |
| W4 | Lifecycle | Invalid per-worker options fail host start with a clear validation error (ATYA-021). `StopAsync` cancels both periodic services within the shutdown timeout with no unobserved exceptions. |
| W5 | Downstream failure | The API returns `503` or `500`. Http.Client yields a failure `Result` of the matching `ErrorKind`; the worker logs, retries next tick and does not crash. |

**ATYA-148, once it ships.** ATYA-148 adds the shared, executable validation-wire definition and its golden fixture to `Atya.Governance.Testing`. When that version is published:
- the test project references it
- A2 (and A3, once ATYA-052 lands) also assert the raw JSON of both producers against the fixture
- the client side is asserted by feeding the fixture to Http.Client

Until then, A2 asserts the wire shape directly. Adopting 148 is a small follow-up PR and does not gate ATYA-075 (D2).

## The readiness gate and where it runs

### CI: a new `reference` job in `Atya/.github/workflows/ci.yml` (ubuntu-latest only)

**Published leg (blocking).** On every PR and push to `main`:
1. `dotnet restore reference/Atya.Reference.slnx --locked-mode` from nuget.org.
2. `dotnet build -c Release` with warnings as errors, including NU1605, NU1608 and NU1107. Any version conflict in the published graph fails.
3. `dotnet test`.
4. `Test-ReferenceComposition.ps1 -Fast`: no prerelease `Atya.*` in the graph, every project not packable, and every composed package listed in the coverage table.

**Candidate leg (advisory, `continue-on-error: true`).** It `needs: pack`:
1. Downloads the existing `packages` artifact.
2. `New-CandidateVersions.ps1` writes a `Directory.Packages.Candidate.props`, which `reference/Directory.Packages.props` imports only when `AtyaCandidate=true`. The file pins each `Atya.*` id to its packed `main` version.
3. Unlocked restore with `--source artifacts/packages --source https://api.nuget.org/v3/index.json`, then build and test.
4. The pack artifact is checked for `Atya.Reference.*` (must be absent).

The leg is advisory because a deliberate breaking major in a library cannot compile against the published and candidate sets at once. Its job is to make the break visible in the PR, so the reference app moves in the same release wave.

Windows is not needed: the applications are platform-neutral and the library matrix already covers Windows. Estimated cost is about 2 minutes per leg. All `uses:` stay SHA-pinned, and the existing checkout, setup-dotnet and upload/download actions are reused.

### Evidence run (dispatchable, also weekly)

A `reference-gate.yml` workflow runs the published leg, then the slow and network-bound checks, which must not block unrelated PRs:
- **Currency:** every pinned `Atya.*` version equals the latest stable on nuget.org. Running this on PRs would turn `main` red the moment a release lands, before the Renovate bump merges.
- **Coverage:** every package in `platform/ecosystem/ecosystem.json` with `publish: true` and lifecycle `keep` is either composed or in the README's exclusion list. The script reads the public file at a pinned commit, so there is no credential.
- **Provenance**, per restored `Atya.*` `.nupkg`:
  - `dotnet nuget verify --all` (the nuget.org repository signature)
  - the `.nuspec` `<repository>` URL and commit exist
  - the commit is the target of the release tag: `<PackageId>/v<version>` in `AtyaLibraries/Atya`, or, for versions released before ADR-14, `v<version>` in the archived per-package repository
  - the publisher's attestation check is Q3
- **Report:** a Markdown and JSON artifact (`reference-gate-report`) with one row per check and per package. It is the evidence attached to the issue.

## What counts as "gate passed" (ATYA-075 Done)

1. The published leg is green on `main`, with `reference/Directory.Packages.props` at the latest stable version of every composed package.
2. An evidence run on that commit is green, and its report is attached to Atya.Roadmap#32: currency, coverage, provenance, and every scenario A1–A9 and W1–W5 passing. Known-gap tests are allowed only with an owner-accepted caveat (R1).
3. The candidate leg exists. It is not required to be green.
4. The issue is re-scoped:
   - the hard dependencies are reduced to the real ones (all closed: 013, 008, 014, 015, 017, 021, 022)
   - the Deferred 009, 025, 051, 052 and 063 are removed with a link to this design
   - the advisory ATYA-070 is recorded as an accepted caveat (the app uses bounded tags only)
5. Items D3 and D4 are resolved as the Coordinator decides: either done, or split into their own issues.

When those hold, ATYA-075 is Done. That releases the PLAN-V2 rule "no new packages or templates until ATYA-075 and ATYA-153 are done" from 075's side, and unblocks the templates task ATYA-079, which builds from these compositions.

## Decisions for review

| # | Decision | Recommendation |
|---|---|---|
| D1 | Location and isolation: `reference/` with its own solution and CPM file, outside `Atya.slnx`, Microsoft SDKs, package references only | Approve. |
| D2 | ATYA-075 Done does **not** wait for ATYA-148. A2 asserts the wire shape directly now and adopts the 148 fixture in a follow-up. | Approve. 148 is open, and its producer fix (052) is Deferred. |
| D3 | The issue also asks for `platform/specs/ATYA-API-TEMPLATE.md` (ServiceDefaults spec: health conventions, middleware order, OTel wiring, starter stack), written from the golden apps | Keep it in 075 as a short spec that cites the reference `Program.cs` files. It is about one page, and ATYA-079 needs it. |
| D4 | The issue also asks for a new-package admission gate with evidence intake (BM-02) | Reuse the Constitution's existing new-package test (the 8-step proposal and "amend before build"). Add only an issue form in Atya.Roadmap that collects the evidence. Changes in the `platform` repository need the owner. Splitting it into its own issue is also acceptable. |
| D5 | Candidate leg is advisory, published leg is blocking; currency check is in the evidence run only | Approve, for the reasons above. |

## Risks

| # | Risk | Recommendation |
|---|---|---|
| R1 | **Validation divergence on the published set.** The exception path writes an `errors` array and the Result path an object map; Http.Client 2.0.0 reads only the map, so details are silently lost (the evidence behind ATYA-148). The fix (052) is Deferred. | **Owner:** either accept 075 Done with the A3 known-gap test and a recorded caveat (recommended: it keeps 075 independent of Deferred work and makes the gap executable and visible), or un-defer ATYA-052 and let A3 assert the correct behaviour. The golden apps validate through `Result`s, which is the working path, and the README says why. |
| R2 | The golden apps turn into a de facto template or a maintenance burden | Keep them to about 10 endpoints and handlers. The README states "reference composition, not a template; templates come from ATYA-079". Every scenario maps to a row above; nothing exists only for show. |
| R3 | Renovate lag means pinned versions trail a release | Currency is checked by the evidence run, not on PRs. The Renovate bump PR is itself a gate run on the new version. |
| R4 | A breaking major in a library breaks the candidate leg | It is advisory by design. Update the reference app in the same release wave as the major. |
| R5 | Undocumented behaviour discovered by a scenario (for example the client-abort status in A6) | Record a finding issue and assert only what is documented. 075 implements no library fixes (the issue's "without implementing unapproved fixes"). |
| R6 | Provenance for versions released before ADR-14 points at archived per-package repositories | Accept the legacy repository and `v<version>` tag. Archived repositories stay readable (ADR-14 reversibility). |
| R7 | Branch rules are currently absent (see the billing note), so "blocking" cannot be enforced by a required check | The job still fails visibly. Mark it required when rulesets return; owner list. |
| R8 | Network dependency on nuget.org in the published leg | Acceptable. It is exactly the adopter path. Restore is cached by the lock files. A nuget.org outage is the transient-infrastructure case (re-run). |
| R9 | `OpenTelemetry.Exporter.InMemory` drifting from the OTel line used by Atya.Diagnostics.OpenTelemetry | Pin it to the same 1.15.x line and group it in Renovate with the OTel packages. |

## Open questions

| # | Question | Recommendation |
|---|---|---|
| Q1 | Run the published leg on a schedule too, to catch a delisted or yanked dependency? | Yes: weekly, through the evidence-run workflow. |
| Q2 | Should the golden apps reference `Atya.Governance.CodeQuality`? | No, until ATYA-025 defines whether it targets applications. |
| Q3 | Verify the publisher's build attestation per package? | Try `gh attestation verify` against the sealed release bundle of the publish run. nuget.org's repository signature changes the `.nupkg` bytes, so the attested subject must be the bundle, not the downloaded package. If that proves impractical, keep signature plus repository/commit/tag and record it in the report. |
| Q4 | Should the reference app use an outbox in the API process now? | No. With in-memory stores the outbox must live in one process (the worker). Revisit after ATYA-153. |

# ATYA-021 (+ ATYA-134, 135, 136): Atya.Hosting.BackgroundServices 2.0.0

Status: Proposed for owner review. No code. Read against `BackgroundServices` `development` at `e2f3797`.
Fixed by the owner: named options per worker via `IOptionsMonitor` keyed by `typeof(TWorker).FullName`, `ValidateOnStart`, static `Default` removed, `TimeProvider`.

## Problem

Verified in source:

- `AddAtyaBackgroundService<T>(configure)` calls `services.Configure(configure)`, which writes the unnamed `PeriodicBackgroundServiceOptions`. Neither base class reads `IOptions`; they take an optional constructor argument and fall back to `PeriodicBackgroundServiceOptions.Default`. A configured value is never applied, and two workers cannot have different settings (ATYA-021).
- `Default` is a public static instance with public setters, and `Validate()` returns `this`, so every worker that omits options aliases one mutable object. Setting `Default.Interval = TimeSpan.Zero` anywhere turns every default worker into a busy loop (ATYA-136).
- The retry filter is `consecutiveFailures + 1 < MaxConsecutiveFailures`, so a value of N tolerates N-1 failures and `1` tolerates none (ATYA-136).
- In `ScopedPeriodicBackgroundService`, `using IServiceScope scope = ...CreateScope()` is a using-declaration inside the `try`, so the scope lives through `await DelayAsync(Interval)`. Scoped DbContexts and connections are held for the whole idle period (ATYA-134). `using` is also synchronous.
- The backoff `await DelayAsync(FailureDelay, ...)` sits inside a `catch` clause. A `TaskCanceledException` from host shutdown during backoff cannot reach the sibling `OperationCanceledException` catch, escapes `ExecuteAsync` and, with the default `StopHost` behaviour, logs a fatal error on a clean shutdown (ATYA-135).
- The two classes duplicate the loop, and delays use `Task.Delay` on the system clock.
- `finally` logs "completed" whether the loop was cancelled or faulted.

## Public API, before and after

Before (1.x): `PeriodicBackgroundService(ILogger, PeriodicBackgroundServiceOptions? = null)`; `ScopedPeriodicBackgroundService(ILogger, IServiceScopeFactory, PeriodicBackgroundServiceOptions? = null)`; `PeriodicBackgroundServiceOptions.Default`; `Add...BackgroundService<T>(Action<Options>?)`.

After (2.0.0):

```csharp
protected PeriodicBackgroundService(ILogger logger, IOptionsMonitor<PeriodicBackgroundServiceOptions> options,
    TimeProvider? timeProvider = null);
protected ScopedPeriodicBackgroundService(ILogger logger, IServiceScopeFactory scopeFactory,
    IOptionsMonitor<PeriodicBackgroundServiceOptions> options, TimeProvider? timeProvider = null);

public static class PeriodicBackgroundServiceOptionNames { public static string For<TWorker>(); }  // typeof(TWorker).FullName

public sealed class PeriodicBackgroundServiceOptions            // binding surface only; Default removed
{ TimeSpan Interval = 1m; TimeSpan FailureDelay = 5s; int MaxConsecutiveFailures = 3; }

AddAtyaBackgroundService<TWorker>(this IServiceCollection, Action<PeriodicBackgroundServiceOptions>? configure = null)
AddAtyaScopedBackgroundService<TWorker>(...same...)   // both: AddOptions(name).Configure(configure).Validate(...).ValidateOnStart()
```

`ExecuteIterationAsync` signatures are unchanged. Derived workers must now accept and pass the monitor, which is the breaking change ATYA-021 anticipates. A worker that wants configuration binding uses `services.AddOptions<PeriodicBackgroundServiceOptions>(PeriodicBackgroundServiceOptionNames.For<W>()).BindConfiguration("Workers:W")` (no new Atya API needed).

## Behaviour and failure modes

- The base constructor reads `options.Get(PeriodicBackgroundServiceOptionNames.For(GetType()))` once and copies it into an internal immutable `LoopSettings`. Later mutation of the options object, or a reload, cannot affect a running worker. Live reload is deliberately not offered (open question 1); `IOptionsMonitor` is used only because the owner fixed it as the lookup mechanism and because it resolves named instances without a scope.
- Validation (`IValidateOptions`, run at startup by `ValidateOnStart`): `Interval > 0`, `FailureDelay >= 0`, `MaxConsecutiveFailures >= 0`. Zero interval is rejected because it is the busy-loop hazard (open question 2). Failures name the worker and the option.
- Semantics of `MaxConsecutiveFailures = N`: exactly N consecutive failures are tolerated; the (N+1)th is rethrown. `0` means no tolerance. The XML docs say so. The default 3 now tolerates three, not two.
- One internal `PeriodicLoop.RunAsync(settings, timeProvider, logger, iteration)` serves both classes.
  - No `await` inside any `catch`: the catch records a `TimeSpan? pendingDelay` and the delay runs after the `try`, inside its own `catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)`.
  - Delays use `Task.Delay(delay, timeProvider, token)`.
  - The scoped iteration runs inside `await using AsyncServiceScope scope = factory.CreateAsyncScope()` in a method that returns before the interval delay starts.
- Outcome logging distinguishes stopped (cancelled), faulted (rethrown after the cap) and, for a worker that returns, completed. These are three distinct event ids.
- Deferred explicitly: fixed-rate scheduling, exponential backoff and metrics. ATYA-021 says "then (only)"; they stay out of 2.0.0.

## Concurrency and lifetime invariants, and how tests prove them

1. Two workers with different `Interval` and `MaxConsecutiveFailures` observe their own values (host integration test, two registrations, `FakeTimeProvider`).
2. No scoped service is alive during any delay: a scoped probe records `Constructed`, `Disposed` and a delay-start marker from a fake-time delay; the test asserts the order `Disposed` before `DelayStarted`, and that N iterations create and dispose exactly N scopes. This uses ordering, not wall-clock timestamps, so it is deterministic.
3. Async disposal: the probe implements only `IAsyncDisposable`; `DisposeAsync` is awaited.
4. Shutdown at any point is clean: stop during the iteration, during the interval and during the failure backoff. Assert `StopAsync` completes, `ExecuteTask` is not Faulted and no error-level log was written.
5. Retry arithmetic: table test for `MaxConsecutiveFailures` in {0, 1, 2, 3} with a worker that always fails; assert the observed iteration count is N+1 and the host stops with the original exception.
6. Isolation: mutate the options instance after construction (and the removed default can no longer be reached); the running worker is unaffected.
7. Startup validation: an invalid options value fails host start before any iteration runs.

## Migration for consumers

- Source-breaking: derived constructors change; `PeriodicBackgroundServiceOptions.Default` is removed (not `[Obsolete]`: 2.0 is the window, and an obsolete mutable static would keep the busy-loop hazard alive).
- Behaviour: configuration passed to `AddAtyaBackgroundService` now takes effect; previously it was ignored. `MaxConsecutiveFailures` off-by-one fix is release-noted as a fix. Shared defaults across workers use `services.ConfigureAll<PeriodicBackgroundServiceOptions>(...)`; unnamed `Configure<>` does not reach named instances.
- Derived types that kept the provider beyond an iteration now fail fast on a disposed scope.
- Last compatible version 1.x.

## Test plan

As above, in `Microsoft.Extensions.Hosting` integration tests with `FakeTimeProvider`, plus unit tests for the validator. SP-03 probe re-run as named in the issue. The sample's two-worker configuration doubles as documentation.

## PR breakdown

1. Options model, names, validator, registration, constructor change, snapshotting (ATYA-021, ATYA-136 part 2).
2. Unified loop: async scope (ATYA-134), shutdown during backoff (ATYA-135), retry semantics (ATYA-136 part 1), `TimeProvider`, outcome logging.
3. Docs, migration notes, sample, API baseline.

## Contradictions with ADRs and the plan

- ATYA-136 allows `[Obsolete]` staging for `Default`; the owner's decision is removal. Followed.
- ATYA-021 says "inject the chosen time abstraction", ADR-02 chose `TimeProvider`. Followed.
- ATYA-134 asserts "disposal timestamps"; with `TimeProvider` the equivalent deterministic assertion is event ordering (above). No conflict, a method change.
- Hard dependencies on ATYA-002 and ATYA-006: 006 is ADR-02; 134, 135 and 136 depend on 021 for code order, which is a real same-repository dependency and stays.

## Open questions for the owner

1. Live reload: snapshot at construction (recommended) or react to `OnChange`?
2. Is `Interval = 0` ever legitimate (a tight loop)? Recommended: reject.
3. Should `MaxConsecutiveFailures = 0` (no retries) be valid? Recommended: yes.
4. Keep the optional `TimeProvider? = null` constructor parameter (falls back to `TimeProvider.System`) or require it?

# ATYA-057 + ATYA-140: Atya.Application.Idempotency 2.0.0

Status: Proposed for owner review. No code. Read against `Idempotency` `development` at `8a89577`.
Decisions fixed by the owner: fenced leases, abandon on exception, bounded store, `SuccessOnly` default (ADR-12), `TimeProvider` (ADR-02).

## Problem

Verified in source:

- `IdempotentExecutor` never calls the store if the operation throws, so the key stays In-Progress until the lease expires (ATYA-057).
- A failure `Result` is stored and replayed for the whole lease (the "sources disagree" point in the issue: it is stored, not left in progress).
- `CompleteAsync(key, result, clock)` has no ownership check. An expired slow owner overwrites a newer owner.
- `CompleteAsync` receives the caller's `CancellationToken`, so cancelling the caller loses the completion.
- The lease is computed before `TryBeginAsync` and reused as the replay window (ATYA-140). A slow operation is already expired when stored. The next caller gets `Expired`, the one after re-executes. This needs no concurrency.
- `InMemoryIdempotencyStore` removes expired entries only when the same key is begun again, so it grows without bound.
- A typed replay with the wrong `TValue` throws `InvalidOperationException` from inside the store.
- The public API uses `IClock` (`TryBeginAsync(..., IClock clock, ...)`) and the public struct `IdempotencyLease.From(IClock, ...)`.

## Public API, before and after

Before (1.0.0): `IIdempotencyStore.TryBeginAsync<T>(key, IdempotencyLease, IClock, ct)`, `CompleteAsync<T>(key, Result<T>, IClock, ct)`; `IdempotentExecutor(store, IClock)` with `ExecuteAsync(key, TimeSpan timeToLive, operation, ct)`.

After (2.0.0), all in `Atya.Application.Idempotency`:

```csharp
public readonly record struct IdempotencyFence(string Value);          // opaque; compare by ordinal equality only
public sealed record IdempotencyExecution(IdempotencyKey Key, IdempotencyFence Fence, DateTimeOffset LeaseExpiresAtUtc);
public enum IdempotencyTransition { Applied, Superseded, NotFound }    // CAS outcome of complete / renew / abandon
public enum IdempotencyCompletionPolicy { SuccessOnly = 0, SuccessAndFailure = 1 }

public interface IIdempotencyStore
{
    bool IsEphemeral { get; }
    ValueTask<IdempotencyBeginResult<T>> TryBeginAsync<T>(IdempotencyKey key, TimeSpan executionLease,
        string? requestFingerprint, CancellationToken ct);
    ValueTask<IdempotencyTransition> CompleteAsync<T>(IdempotencyExecution e, Result<T> result,
        TimeSpan replayTimeToLive, CancellationToken ct);
    ValueTask<IdempotencyTransition> RenewAsync(IdempotencyExecution e, TimeSpan extension, CancellationToken ct);
    ValueTask<IdempotencyTransition> AbandonAsync(IdempotencyExecution e, CancellationToken ct);
}

public sealed class IdempotentExecutor(IIdempotencyStore store, TimeProvider timeProvider, IdempotencyExecutorOptions? options = null)
{
    ValueTask<Result<T>> ExecuteAsync<T>(IdempotencyKey key, Func<CancellationToken, ValueTask<Result<T>>> operation,
        IdempotencyCallOptions? call = null, CancellationToken ct = default);
}
public sealed record IdempotencyExecutorOptions   // registration-level defaults
{ IdempotencyCompletionPolicy CompletionPolicy = SuccessOnly; TimeSpan ExecutionLease = 30s; TimeSpan ReplayTimeToLive = 24h; TimeSpan FinalizationTimeout = 10s; }
public sealed record IdempotencyCallOptions       // per-call overrides, all nullable, plus RequestFingerprint
```

`IdempotencyBeginResult<T>` gains `Begun(IdempotencyExecution)`, `PayloadMismatch` and `CapacityExceeded` statuses. `IdempotencyLease`, `IClock` parameters and `IdempotencyReplay.Lease` are removed. Stores own a `TimeProvider` (constructor) and compute absolute expiries themselves. This resolves ATYA-140's choice between "an `IdempotencyLease` or a `TimeSpan`": pass `TimeSpan`, so no caller-side clock can anchor the replay window to the start.

## Behaviour and failure modes

| Outcome | Executor action | Store state after |
|---|---|---|
| Success | `Complete` | Completed, replay until completion time + `ReplayTimeToLive` |
| Failure `Result` | `SuccessOnly`: `Abandon`. `SuccessAndFailure`: `Complete` | Released / Completed |
| Exception | `Abandon`, rethrow | Released |
| Caller cancellation | `Abandon`, rethrow | Released |
| Lease expired and another owner began | Completion returns `Superseded` | Newer owner's state untouched |

- Finalization (`Complete`/`Abandon`) uses `CancellationToken.None` linked to a `CancellationTokenSource(FinalizationTimeout, timeProvider)`, never the caller's token (ADR-12).
- A `Superseded` completion does not change the result returned to the caller. The caller already holds a valid result, so the executor returns it and does not throw.
- If finalization fails or times out, the lease simply expires. Recommended: swallow, never replace the operation's result, report through an optional `Action<IdempotencyFinalizationFailure>` on the options (Idempotency has no logger dependency). See open question 2.
- Late completion by an expired owner that nobody superseded is accepted: the rule is fence equality, not clock comparison. This matches ADR-12 row "expired owner's completion is rejected" only after a new owner began, and ATYA-057's acceptance wording.
- `requestFingerprint` (optional): same key with a different fingerprint returns `PayloadMismatch` (Conflict, `atya.application.idempotency.payload_mismatch`). A `TValue` mismatch on replay returns the same failure instead of throwing.

## Concurrency and persistence invariants, and how tests prove them

1. One live owner per key: N parallel `TryBegin` calls yield exactly one `Begun`. Test: barrier-released tasks, repeated 1,000 times.
2. Fencing: complete/renew/abandon succeed iff the presented fence equals the current fence of an In-Progress entry. Test with `FakeTimeProvider`: A begins, advance past lease, B begins, A completes (`Superseded`), B completes, replay equals B's result.
3. Replay window starts at durable completion. Test: operation runs 3x `ExecutionLease`, then two further callers both receive `Completed`; operation body ran once (ATYA-140 acceptance).
4. ADR-12 table, every row, for both policies, in a table-driven store conformance test.
5. Finalization survives a cancelled caller token and a disposed caller scope.
6. Bounded store: entry count never exceeds `MaxEntries` (default 10,000) after any call. Expired entries are purged by expiry order (priority queue) at every mutating call, so cleanup is deterministic under `FakeTimeProvider`. At capacity after purge, `TryBegin` returns `CapacityExceeded` and the executor returns a failure `Result` (`atya.application.idempotency.capacity_exceeded`).
7. Production guard: `IsEphemeral` is true for the in-memory store. A new `AddAtyaIdempotency` extension fails `ValidateOnStart` in a Production host environment unless `AllowEphemeralStore` is set.

The conformance suite is the migration contract for any store (`ATYA-153` is its first external consumer).

## Migration for consumers

- Breaking for `IIdempotencyStore` implementers and for callers of `IdempotentExecutor` (constructor takes `TimeProvider`, `ExecuteAsync` takes options not a bare TTL).
- Behaviour change called out in release notes (ADR-12): failure `Result`s are no longer replayed by default. Handlers with non-compensated partial side effects must set `SuccessAndFailure`.
- `PackageValidationBaselineVersion` stays 1.0.0 until 2.0.0 ships; suppress with a documented suppression file, not by editing the baseline.
- Fallback: last compatible version is 1.0.0.

## Test plan

Unit tests per invariant above; a conformance base class `IdempotencyStoreConformanceTests` run against the in-memory store; sample updated; `FakeTimeProvider` from `Microsoft.Extensions.TimeProvider.Testing`. The existing benchmark project is re-run and before/after numbers are recorded in the PR (no regression threshold exists today; proposing none).

## PR breakdown

1. Contract + executor + in-memory store with fencing, abandon, policy, `TimeProvider` (one PR; the contract is indivisible).
2. Capacity, purge and `IsEphemeral` guard, DI extension.
3. Conformance suite extraction, docs, migration notes.

## Contradictions with ADRs and the plan

- ATYA-057 and ATYA-140 are written for `IClock`; ADR-02 says `TimeProvider`. This design follows the ADR.
- ATYA-057 requires replacing the private fake with the Governance.Testing fake (ATYA-051). That fake (`FakeClock`) implements `IClock`, and ATYA-051 is Deferred in Plan v2. Use `FakeTimeProvider` instead and drop the dependency.
- Hard dependencies on ATYA-051 and ATYA-122 are stale: 122 is ADR-12 (done), 051 is Deferred. Proposal: clear them from the issue (not done here).
- After this change the `Atya.Foundation.Time` edge in the Constitution matrix is no longer needed for Idempotency.

## Open questions for the owner

1. Request fingerprint: in scope now, or only typed-replay mismatch? Recommended: in scope, optional, null means unchecked.
2. Finalization failure: swallow with an observer (recommended) or throw?
3. Auto-renewal heartbeat in the executor: leave to callers (recommended, `RenewAsync` is exposed) or opt-in timer?
4. Where does the conformance suite live so provider repos can reuse it, given the rule against depending on another package's test assets and the no-new-packages rule? Recommended: in-repo now, decide with ATYA-153.
5. `AddAtyaIdempotency` adds a `Microsoft.Extensions.Hosting.Abstractions` reference (README justification needed). Accept, or warn-only via `IsEphemeral`?

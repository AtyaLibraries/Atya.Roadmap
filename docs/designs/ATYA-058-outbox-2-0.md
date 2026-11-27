# ATYA-058 + ATYA-146: Atya.Messaging.Outbox 2.0.0

Status: Proposed for owner review. No code. Read against `Messaging.Outbox` `development` at `2be1f22`.
Fixed by the owner: atomic claim (claim token + lease expiry), `NextAttemptAt` with backoff, sanitized failure diagnostics, contract-name registry with no `Type.GetType` fallback (upcasters deferred), `TimeProvider`.

## Problem

Verified in source:

- `LoadPendingAsync` returns every Pending row with no claim. Two relays read the same rows and both publish.
- `MarkFailedAsync` leaves the row Pending, so a poison message is retried on every cycle with no delay.
- `OutboxMessage.MessageTypeName` is `Type.AssemblyQualifiedName`, resolved with `Type.GetType(name, throwOnError: true)`. It breaks across versions and lets stored data pick the type to load.
- The relay persists `ex.Message` into `LastError` (public, unbounded). Transport messages often carry connection strings or broker URIs (ATYA-146).
- One `catch` covers publish and the `MarkPublishedAsync` acknowledgement. If the acknowledgement throws after a successful publish, the relay then records a publish failure and the message is sent again. The at-least-once window is undocumented.
- `IClock` is used in `OutboxPublisher` and `OutboxRelay`.

## Public API, before and after

Before (1.x): `IOutboxStore { AddAsync, LoadPendingAsync(maxCount), MarkPublishedAsync(id, publishedAt), MarkFailedAsync(id, attemptedAt, failure, terminal) }`; `OutboxMessage(.., messageTypeName, ..)`; `OutboxRelay(store, publisher, IClock, maxAttempts, serializer)`.

After (2.0.0):

```csharp
public sealed record OutboxClaimToken(string Value);                       // opaque, unique per claim
public sealed record OutboxClaim(OutboxClaimToken Token, DateTimeOffset LeaseExpiresAtUtc, IReadOnlyList<OutboxMessage> Messages);
public enum OutboxTransition { Applied, ClaimLost, NotFound }

public interface IOutboxStore
{
    bool IsEphemeral { get; }
    ValueTask AddAsync(OutboxMessage message, CancellationToken ct);
    ValueTask<OutboxClaim> ClaimAsync(int maxCount, TimeSpan lease, string owner, CancellationToken ct);
    ValueTask<OutboxTransition> RenewAsync(OutboxClaimToken token, TimeSpan extension, CancellationToken ct);  // whole claim
    ValueTask<OutboxTransition> MarkPublishedAsync(OutboxClaimToken token, string id, CancellationToken ct);
    ValueTask<OutboxTransition> MarkFailedAsync(OutboxClaimToken token, string id, OutboxFailure failure,
        DateTimeOffset? nextAttemptAt, bool terminal, CancellationToken ct);
}
public sealed record OutboxFailure(string ErrorType, string Description, string? Handle);  // bounded, sanitized
public sealed class OutboxContractRegistry { Register<T>(string contractName, int schemaVersion = 1); ... }  // frozen at build
public sealed class OutboxRelayOptions { MaxAttempts=5; ClaimLease=2m; BatchSize; Backoff{Initial=5s, Max=15m, Factor=2, JitterFactor=0.2};
    Func<Exception, OutboxFailure> DescribeFailure; int MaxFailureLength=512; }
public sealed class OutboxRelay(IOutboxStore, IMessagePublisher, TimeProvider, OutboxContractRegistry, OutboxRelayOptions);
```

`OutboxMessage` replaces `MessageTypeName` with `ContractName` + `SchemaVersion`, adds `NextAttemptAt`, claim owner/expiry, and `Status` gains `Claimed`. `OutboxMessage.LastError` is replaced by `LastFailure` (type, bounded description, handle). `OutboxMessageSerializer.ResolveMessageType` is removed.

## Behaviour and failure modes

- Claim: one atomic operation selects up to `maxCount` rows that are Pending with `NextAttemptAt <= now`, or Claimed with `LeaseExpiresAt <= now`, orders by `NextAttemptAt` then `OccurredAt`, stamps owner, a fresh token and expiry, and returns them. Expired claims are reclaimed by the same operation, so a crashed relay needs no recovery job.
- Every later transition is a compare-and-set on (id, token). A relay whose lease expired gets `ClaimLost` and must not publish further from that batch. The relay checks remaining lease before each publish and renews when under half.
- Backoff: `delay = min(Max, Initial * Factor^(attempt-1))` adjusted by `Random.Shared` within `JitterFactor` (0 to 1, default 0.2); tests set `JitterFactor = 0`, so they are deterministic. `NextAttemptAt = now + delay` from `TimeProvider`.
- Terminal classes: unknown contract name or deserialization failure is terminal on first sight (the data will never become valid); attempts exhausted is terminal; everything else is retryable.
- Failure diagnostics (ATYA-146): `OutboxFailure` carries the exception type name, a description truncated to `MaxFailureLength` after redaction, and a handle (a GUID) under which the full exception is logged through `ILogger`. Default description is the type name only, and the message text is included only through a caller-supplied `DescribeFailure`. Stack traces are not persisted (ATYA-058 asks for "type + truncated stack"; stacks leak paths and types, so they go to the log under the handle). One schema migration covers both `NextAttemptAt` and the failure fields.
- Publish vs acknowledge: publish failure and acknowledge failure are separate. If `MarkPublishedAsync` throws after a successful publish, the relay does not record a failure; the claim lease expires and the row is re-sent. This is the documented at-least-once window; consumers pair with Idempotency using `MessageId` as key.
- Contract registry: `Register<T>("orders.placed", 1)`. Resolution is a dictionary lookup on (name, version). No `Type.GetType`, no assembly-qualified names in stored rows. Upcasters are deferred; an unknown version is a terminal "unknown contract" failure.

## Concurrency and persistence invariants, and how tests prove them

1. A row is delivered to at most one live claim: R relays race `ClaimAsync` over M rows; the union of returned ids has no duplicates (property test, parallel, repeated).
2. Stale acknowledgements are rejected: claim by A, advance `FakeTimeProvider` past lease, claim by B, A's `MarkPublishedAsync` returns `ClaimLost` and the row is unchanged.
3. Poison messages follow the schedule: a publisher that always throws is claimed at exactly the computed `NextAttemptAt` values and is terminal after `MaxAttempts`; no earlier claim is possible.
4. No AQN in stored rows (assertion over every persisted field).
5. Redaction: a hostile exception corpus (connection string, URI with credentials, SQL fragment, 100 KB message) never reaches `LastFailure`, and the length bound holds.
6. Cancellation: cancelling mid-batch releases nothing silently; unprocessed claimed rows become claimable when the lease lapses (tested).
7. Transaction enlistment: the conformance suite requires `AddAsync` to participate in the caller's ambient transaction for durable stores; the in-memory store declares `IsEphemeral` and the label "outbox contracts and relay with a test store" stays in the README until ATYA-153's provider passes the suite.

## Migration for consumers

Breaking for store implementers, for code constructing `OutboxRelay` (takes `TimeProvider`, options, registry), and for stored data: rows written by 1.x carry AQNs. No legacy mapping helper is shipped (no durable store exists yet): 1.x pending rows become terminal "unknown contract" failures. Last compatible version is 1.x.

## Test plan

Conformance suite as above plus unit tests for backoff arithmetic, registry, redaction and the relay loop; the multi-relay race test is the acceptance test named in ATYA-058. A sample hosts the relay on `PeriodicBackgroundService` (a recipe, not a package, per the issue; it consumes BackgroundServices 2.0 options, see ATYA-021).

## PR breakdown

1. Contracts: claim, tokens, `OutboxFailure`, registry, message model; in-memory store.
2. Relay: backoff, terminal rules, publish/ack split, redaction, `TimeProvider`.
3. Conformance suite, sample and README recipe, migration helper and notes.

## Contradictions with ADRs and the plan

- ATYA-058 asks for a resolver/upcaster registry; the owner's fixed decision defers upcasters. This design ships only the contract-name registry.
- ATYA-058 and ATYA-146 persist "type + truncated stack"/`ex.Message`; this design persists neither (see above). Decision for the owner if the stack is wanted.
- Hard dependencies are stale: ATYA-059 is Deferred, ATYA-112 (data-classification model named by ATYA-146) is Rejected in Plan v2, ATYA-006 is ADR-02. Proposal: reduce to ATYA-057 only if the shared "claim/fence" vocabulary is wanted; otherwise none.
- The issues assume `IClock`; ADR-02 says `TimeProvider`.

## Decisions (2026-11-27)

- No stack traces persisted; the stack goes to the log under the failure handle.
- No legacy-row mapping helper.
- One claim token per batch; renewal extends the whole claim.
- Jitter uses `Random.Shared` scaled by an options value `JitterFactor` (0 to 1); tests set it to 0. No injected random source.
- Upcasters remain deferred.

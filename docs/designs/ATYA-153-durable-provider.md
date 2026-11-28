# ATYA-153: First durable provider for the outbox and idempotency stores

Status: Accepted 2026-11-28. D1 was decided by the owner (two adapter packages). D2 and the design choices were approved by the Coordinator. Design only: no library code, no issue, board or platform changes.
Read against `AtyaLibraries/Atya` `main` at `5030493`: `Atya.Messaging.Outbox` 2.0.0 and `Atya.Application.Idempotency` 2.0.0 are released (tags `…/v2.0.0`), so the hard dependencies ATYA-057 and ATYA-058 are met.
Inputs: issue AtyaLibraries/Atya#11, PLAN-V2, ADR-01, ADR-02, ADR-10, ADR-12, ADR-13, ADR-14, the ATYA-057 and ATYA-058 designs, `platform/CONSTITUTION.md` and `ecosystem.json` (with platform PR #130 applied), and the Admin Platform direction (PostgreSQL, one schema per module).

## Summary

- The provider targets PostgreSQL through plain ADO.NET (`System.Data.Common.DbDataSource`, `DbTransaction`). It has **no third-party runtime dependency**, and EF Core is a documented, tested integration recipe rather than a dependency (decision D2).
- The outbox claim is one SQL statement using `FOR UPDATE SKIP LOCKED`. Every later transition is a compare-and-set on `(id, claim_token)`. Idempotency `TryBegin` is one `INSERT … ON CONFLICT DO UPDATE … WHERE expired` statement. Every transition is a compare-and-set on `(key, fence)`.
- Time always comes from the application's `TimeProvider` and is sent to SQL as parameters. The database clock is never read, so the existing conformance suites (which use `FakeTimeProvider`) run unchanged against the database.
- Schema: versioned, idempotent SQL scripts shipped in the package. Adopters apply them with their own migration tool (EF Core `migrationBuilder.Sql(...)`, DbUp, Flyway or psql). A helper exists for tests and development. The schema name is configurable, so it fits the "one schema per module" setup.
- Tests run on real PostgreSQL through Testcontainers on `ubuntu-latest`. The two existing conformance suites run unchanged, alongside extra multi-process race tests.
- **Package shape (D1, decided by the owner on 2026-11-28):** two thin adapter packages, `Atya.Messaging.Outbox.PostgreSql` and `Atya.Application.Idempotency.PostgreSql`.

## D1: Package shape (decided by the owner, 2026-11-28)

**Decision:** two adapter packages:
- `Atya.Messaging.Outbox.PostgreSql`, which implements `IOutboxStore`
- `Atya.Application.Idempotency.PostgreSql`, which implements `IIdempotencyStore`

Why one combined package was rejected: it collides with three Constitution rules.
- **Layering** (one-way, downward: Foundation → Errors/Diagnostics → Http/Hosting/Messaging/Data → Web/Application). A Messaging-area package cannot depend on `Atya.Application.Idempotency`.
- **Provider naming.** The fourth segment (`Atya.{Area}.{Name}.{Provider}`) is reserved for adapters of *one* existing package.
- **Area scope.** The Application area lists persistence under "not allowed".

The two adapters are fully compliant:
- each is a fourth-segment adapter with downward edges only, and each is usable alone
- the parked catalog row `Atya.Messaging.Outbox.EntityFrameworkCore` graduates, renamed to `…PostgreSql` per D2
- about 150 lines of shared internal helpers (identifier validation, schema-script runner) are compiled into both through a linked source file; that is neither a package nor public API

The Constitution amendment and the allowlist entries this needs are implementation steps 1 and 2 under "Versioning and release plan".

## D2: ADO.NET over a `DbDataSource`, not an EF Core dependency (approved by the Coordinator, 2026-11-28)

The issue says "EF Core / PostgreSQL". This design keeps PostgreSQL and moves EF Core from a dependency to a supported, tested recipe. Reasons:

- **Public API rule.** The Constitution says "No leaking third-party types in public signatures", and "an ORM type in a public signature is a build-review failure". An EF Core store would expose `DbContext`/`ModelBuilder`. `DbDataSource` and `DbTransaction` are BCL types.
- **The SQL is PostgreSQL-specific either way** (`SKIP LOCKED`, `ON CONFLICT`, `jsonb`). EF Core would only carry the connection and the transaction, and `DbTransaction` already does that.
- **Zero third-party runtime dependencies.** No "Why this dependency" section is needed, and no EF Core or Npgsql version line is forced on adopters. That matters because EF Core and Npgsql 11.x target `net11.0` only, while Atya targets `net10.0` (ADR-01). It works with EF Core, Dapper and raw Npgsql alike. Atya.Admin currently uses raw Npgsql.
- EF Core adopters get the outbox insert into their transaction with one registration line (see the API section). The integration tests prove the EF Core path end to end (commit and rollback with `SaveChangesAsync`).

Consequence: the provider segment is `PostgreSql`, not `EntityFrameworkCore`.

## Package

| | `Atya.Messaging.Outbox.PostgreSql` | `Atya.Application.Idempotency.PostgreSql` |
|---|---|---|
| Path | `packages/Messaging/Outbox.PostgreSql/` (`src/Outbox.PostgreSql`, `tests/Outbox.PostgreSql.IntegrationTests`, `Outbox.PostgreSql.slnf`) | `packages/Application/Idempotency.PostgreSql/` (same layout) |
| Target | `net10.0` only (ADR-01) | `net10.0` only |
| Atya dependencies | `Atya.Messaging.Outbox` 2.0.0, `Atya.Foundation.Guards` | `Atya.Application.Idempotency` 2.0.0, `Atya.Foundation.Results`, `Atya.Foundation.Guards`, `Atya.Foundation.Serialization` |
| Other runtime dependencies | `Microsoft.Extensions.DependencyInjection.Abstractions` | `Microsoft.Extensions.DependencyInjection.Abstractions` |
| Matrix edges to add | → Messaging.Outbox (same area, downward to the contract) | → Application.Idempotency, → Foundation.Serialization (Guards and Results need no amendment) |

Notes:
- The Serialization edge supplies the default `JsonSerializerOptions` for stored results, so replays use the fleet's JSON conventions. Dropping it means taking `JsonSerializerOptions.Default`. Recommendation: keep it.
- No `Microsoft.Extensions.Options` (it isn't an `*.Abstractions` package): options are plain classes configured through `Action<T>` at registration.
- Each project is identity-only per the Constitution: `PackageId` = `AssemblyName` = `RootNamespace`, `MinVerTagPrefix` = `<PackageId>/v`, `MinVerMinimumMajorMinor` = `1.0`, and no `PackageValidationBaselineVersion` until 1.0.0 ships.
- `Directory.Packages.props` gains runtime pins for `Atya.Messaging.Outbox` 2.0.0 and `Atya.Application.Idempotency` 2.0.0. In the existing "Testing and samples" group it gains `Npgsql`, `Testcontainers.PostgreSql`, `Microsoft.EntityFrameworkCore` and `Npgsql.EntityFrameworkCore.PostgreSQL`, all on the 10.0.x line (Npgsql 10.0.4, Testcontainers 4.17.0 today), and test-only.

## Schema

### Strategy

- The package ships ordered, versioned SQL scripts as embedded resources. 1.0.0 has one script per package: version 1. Every script is idempotent (`CREATE SCHEMA/TABLE/INDEX IF NOT EXISTS`), so applying it twice is harmless.
- Rule: a published script never changes. A schema change ships as a new script version in a minor release (additive) or a major release (breaking). The store's README lists which script versions each package version requires.
- Only the schema name is configurable (default `atya`). Table and column names are fixed, because the store SQL is written against them. Schema names are validated against `^[a-z_][a-z0-9_]{0,62}$` and always double-quoted, so the name cannot be used for injection. Both packages' tables have distinct names and can share one schema.
- How adopters apply it:
  - **EF Core migrations** (recommended for EF Core apps): `migrationBuilder.Sql(PostgresOutboxSchema.GetScript("orders", version: 1));` in a hand-written migration. The tables are not part of the EF model; the store does not need them to be.
  - **Any other tool** (DbUp, Flyway, psql): `PostgresOutboxSchema.GetScript(schema, version)` returns the text to save as a migration file.
  - **Tests and development only**: `PostgresOutboxSchema.ApplyAsync(dataSource, schema)` runs all scripts. The README says not to call it at production startup, because it needs DDL rights.
- No schema-version table in 1.0. `COMMENT ON TABLE … IS 'atya:outbox:v1'` (and `atya:idempotency:v1`) makes the applied version visible to operators. A startup check is an open question (Q5).

### DDL: outbox (script version 1)

```sql
CREATE SCHEMA IF NOT EXISTS "atya";

CREATE TABLE IF NOT EXISTS "atya".outbox_messages (
    id                       text        PRIMARY KEY,
    contract_name            text        NOT NULL,
    schema_version           integer     NOT NULL CHECK (schema_version > 0),
    payload                  text        NOT NULL,              -- text, not jsonb: the serializer owns the bytes
    message_id               text        NOT NULL,
    correlation_id           text        NULL,
    headers                  jsonb       NOT NULL DEFAULT '{}'::jsonb,
    occurred_at              timestamptz NOT NULL,
    status                   smallint    NOT NULL CHECK (status IN (0, 1, 2, 3)),  -- OutboxMessageStatus values
    attempt_count            integer     NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
    next_attempt_at          timestamptz NOT NULL,
    published_at             timestamptz NULL,
    last_attempt_at          timestamptz NULL,
    last_failure_type        text        NULL,
    last_failure_description text        NULL,
    last_failure_handle      text        NULL,
    claim_owner              text        NULL,
    claim_token              text        NULL,
    claim_lease_expires_at   timestamptz NULL,
    CONSTRAINT outbox_messages_claim_ck CHECK (
        (status = 3) = (claim_owner IS NOT NULL AND claim_token IS NOT NULL AND claim_lease_expires_at IS NOT NULL))
);

-- Claim scan: Pending rows plus the few Claimed rows (at most relays x batch), in claim order.
CREATE INDEX IF NOT EXISTS outbox_messages_claimable_ix
    ON "atya".outbox_messages (next_attempt_at, occurred_at, id) WHERE status IN (0, 3);
CREATE INDEX IF NOT EXISTS outbox_messages_claim_token_ix
    ON "atya".outbox_messages (claim_token) WHERE status = 3;
CREATE INDEX IF NOT EXISTS outbox_messages_published_ix
    ON "atya".outbox_messages (published_at) WHERE status = 1;
CREATE INDEX IF NOT EXISTS outbox_messages_failed_ix
    ON "atya".outbox_messages (last_attempt_at) WHERE status = 2;

COMMENT ON TABLE "atya".outbox_messages IS 'atya:outbox:v1';
```

### DDL: idempotency (script version 1)

```sql
CREATE SCHEMA IF NOT EXISTS "atya";

CREATE TABLE IF NOT EXISTS "atya".idempotency_entries (
    key_hash            bytea       PRIMARY KEY CHECK (octet_length(key_hash) = 32),  -- SHA-256 of the UTF-8 key
    key                 text        NOT NULL,             -- kept for diagnostics and the collision check
    fence               text        NOT NULL,
    status              smallint    NOT NULL CHECK (status IN (0, 1)),  -- 0 InProgress, 1 Completed
    request_fingerprint text        NULL,
    value_type          text        NULL,                 -- comparison only; never resolved to a Type
    result              jsonb       NULL,
    begun_at            timestamptz NOT NULL,
    completed_at        timestamptz NULL,
    expires_at          timestamptz NOT NULL,             -- lease expiry while InProgress, replay end when Completed
    CONSTRAINT idempotency_entries_completed_ck CHECK (
        (status = 1) = (value_type IS NOT NULL AND result IS NOT NULL AND completed_at IS NOT NULL))
);

CREATE INDEX IF NOT EXISTS idempotency_entries_expires_ix ON "atya".idempotency_entries (expires_at);

COMMENT ON TABLE "atya".idempotency_entries IS 'atya:idempotency:v1';
```

The primary key is a hash because `IdempotencyKey` has no length limit, and a B-tree entry fails above about 2.7 KB. A hash collision is detected by comparing `key` and surfaces as an `InvalidOperationException` (a 2^-128 event). No key length limit is added, so the behaviour matches the contract and the in-memory store.

## Store implementations

Common rules for both stores:

- **Time:** `now` is `TimeProvider.GetUtcNow()`, sent as a parameter. All expiries are computed in .NET (`now + lease`). The SQL never calls `now()`. This keeps the stores honest to the 2.0 contract ("stores own a `TimeProvider`"). It is also what lets the conformance suites, which advance a `FakeTimeProvider`, run against the database.
- **Tokens:** fences and claim tokens are `Guid.NewGuid().ToString("N")`, generated client-side, like the in-memory stores.
- **SQL:** each store builds its SQL text once per instance (the schema name is fixed at construction). It uses positional `$n` parameters with unnamed `DbParameter`s (Npgsql's native mode). Every transition is a single statement, so each is atomic under autocommit at READ COMMITTED. There are no explicit transactions, except that the outbox `AddAsync` joins the caller's.
- **Cancellation:** `ThrowIfCancellationRequested` runs before any I/O, which matches `CancelledToken_ThrowsBeforeTouchingState`. The token then flows to `ExecuteReaderAsync`/`ExecuteNonQueryAsync`. Finalization tokens are the executor's business (ADR-12: never the caller's token).
- `IsEphemeral` is `false` for both.

### Outbox

**AddAsync(message): joins the caller's transaction.**
- The store is constructed with a `Func<DbTransaction?> currentTransaction`. When it returns a transaction, the `INSERT` runs on `transaction.Connection` with `command.Transaction` set, so the row commits or rolls back with the caller's business data. That is the property the outbox exists for (ATYA-058 invariant 7).
- When it returns `null` and `RequireTransaction` is `true` (the default), `AddAsync` throws `InvalidOperationException` ("the outbox insert must run inside the caller's transaction"). This catches the classic mistake: EF Core's implicit `SaveChanges` transaction is invisible, so without the guard the insert would autocommit separately from the business write.
- When it returns `null` and `RequireTransaction` is `false`, the insert autocommits through the `DbDataSource`. Used by the conformance suite and by hosts that only enqueue.
- A duplicate `id` (SQLSTATE `23505`, read from the BCL `DbException.SqlState`) is rethrown as `ArgumentException`, the same as the in-memory store. The README notes that PostgreSQL has then aborted the caller's transaction.

**ClaimAsync(maxCount, lease, owner): one atomic statement.** It runs autonomously through the `DbDataSource`, never in the caller's transaction.

```sql
WITH candidates AS (
    SELECT id FROM "atya".outbox_messages
    WHERE status IN (0, 3)
      AND ((status = 0 AND next_attempt_at <= $1) OR (status = 3 AND claim_lease_expires_at <= $1))
    ORDER BY next_attempt_at, occurred_at, id
    LIMIT $2
    FOR UPDATE SKIP LOCKED)
UPDATE "atya".outbox_messages m
SET status = 3, claim_owner = $3, claim_token = $4, claim_lease_expires_at = $5
FROM candidates c
WHERE m.id = c.id
RETURNING m.*;
```

- **No double-claim.** Rows locked by a concurrent claim are skipped, not waited on. A row another claim has already committed fails the re-check of the `WHERE` clause: PostgreSQL re-evaluates locked rows against their latest version, so a row that is now Claimed with a future lease is dropped. The worst case under contention is a short batch, never a duplicate.
- **Crash recovery:** expired claims are reclaimed by the same statement, the same as the in-memory store. No recovery job is needed.
- `RETURNING` order is not guaranteed, so rows are sorted client-side by `(next_attempt_at, occurred_at, id)` to match the in-memory order. Rows map to `OutboxMessage` through its public constructor, and `headers` are read with `System.Text.Json` into a dictionary.

**Transitions: compare-and-set on `(id, claim_token)`.** `MarkPublishedAsync` and `MarkFailedAsync` use one statement:

```sql
WITH u AS (
    UPDATE "atya".outbox_messages
    SET status = 1, published_at = $3, last_attempt_at = $3, attempt_count = attempt_count + 1,
        last_failure_type = NULL, last_failure_description = NULL, last_failure_handle = NULL,
        claim_owner = NULL, claim_token = NULL, claim_lease_expires_at = NULL
    WHERE id = $1 AND status = 3 AND claim_token = $2
    RETURNING 1)
SELECT EXISTS (SELECT 1 FROM u) AS applied,
       EXISTS (SELECT 1 FROM "atya".outbox_messages WHERE id = $1) AS found;
```

- Mapping: `applied` → `Applied`; else `found` → `ClaimLost`; else `NotFound`. A stale relay whose row was reclaimed gets `ClaimLost`, and the row is unchanged (`StaleAcknowledgement_…`).
- The rule is token equality, not clock comparison, the same as the in-memory store. A relay whose lease lapsed but whose rows nobody reclaimed can still acknowledge them.
- `MarkFailedAsync` sets the following:
  - `status = CASE WHEN $terminal THEN 2 ELSE 0 END`
  - `attempt_count + 1`
  - `next_attempt_at = COALESCE($next, next_attempt_at)`
  - `last_attempt_at = now`
  - the three failure columns, from `OutboxFailure`, which the relay has already sanitized and bounded
  - the claim columns cleared

  It enforces the same argument checks as the in-memory store (a retryable failure needs `nextAttemptAt`).
- `RenewAsync(token, extension)`: `UPDATE … SET claim_lease_expires_at = now + extension WHERE status = 3 AND claim_token = $1`. A row count above 0 means `Applied`, otherwise `ClaimLost` (in-memory parity: renew never reports `NotFound`).

**Poison messages.** The relay decides which failures are terminal (unknown contract, bad payload, attempts exhausted). The store records them as `status = 2` (`Failed`) and never claims them again, because the claim scan only reads statuses 0 and 3. Failed rows stay for inspection. The README documents the operator SQL for listing them (`WHERE status = 2`) and for requeueing one (`UPDATE … SET status = 0, attempt_count = 0, next_attempt_at = <now> WHERE id = … AND status = 2`). A typed requeue API is open question Q3.

**Cleanup.** `PurgeAsync(PostgresOutboxPurge)` deletes Published rows older than `PublishedRetention` (by `published_at`). It deletes Failed rows older than `FailedRetention` (by `last_attempt_at`) only when that value is set; the default `null` keeps Failed rows. Deletion runs in batches (`DELETE … WHERE id IN (SELECT id … LIMIT $batch FOR UPDATE SKIP LOCKED)`) and returns the deleted count. The store has no timer: adopters call it from a periodic job, and the README recipe uses `PeriodicBackgroundService`. That keeps the provider free of a hosting dependency, the same as the relay recipe in ATYA-058.

### Idempotency

**TryBeginAsync(key, executionLease, fingerprint).**

Statement 1 is an atomic begin, or a takeover of an expired entry:

```sql
INSERT INTO "atya".idempotency_entries AS e
       (key_hash, key, fence, status, request_fingerprint, begun_at, expires_at)
VALUES ($1, $2, $3, 0, $4, $5, $6)
ON CONFLICT (key_hash) DO UPDATE
SET key = EXCLUDED.key, fence = EXCLUDED.fence, status = 0, request_fingerprint = EXCLUDED.request_fingerprint,
    value_type = NULL, result = NULL, completed_at = NULL, begun_at = EXCLUDED.begun_at, expires_at = EXCLUDED.expires_at
WHERE e.expires_at <= $5
RETURNING fence;
```

- If it returns our fence, the result is `Begun(new IdempotencyExecution(key, fence, now + lease))`.
- **Exactly one owner under concurrency.** Racing inserts on the same key serialize on the unique index. Losers see the conflict, the `WHERE` fails on the live row, and no row is returned. An expired entry (an expired lease or an ended replay window) is taken over by exactly one racer, the same as the in-memory store's purge-then-begin.

Statement 2 runs only when statement 1 returned nothing. It reads the live entry: `SELECT key, fence, status, request_fingerprint, value_type, result, completed_at, expires_at WHERE key_hash = $1`. It evaluates the entry in the same order as `InMemoryIdempotencyStore`:
1. Both fingerprints are non-null and differ → `PayloadMismatch`.
2. `status = 0` → `InProgress`.
3. `value_type` differs from the caller's `TValue` identity → `PayloadMismatch`.
4. The stored result cannot be deserialized as `Result<TValue>` → `PayloadMismatch` (Q4).
5. Otherwise → `Completed(new IdempotencyReplay<TValue>(key, result, completed_at, expires_at))`.

If statement 2 finds no row, or an expired one, the entry was abandoned or purged between the two statements, so the store retries from statement 1, at most three times, and then throws `InvalidOperationException`. A conformance-style test forces this race with an abandon loop.

`CapacityExceeded` is never returned: the durable store has no entry limit. The README says so, and expiry plus purge bound the table instead.

**CompleteAsync(execution, result, replayTtl): compare-and-set on `(key_hash, fence, status = 0)`.**

```sql
WITH u AS (
    UPDATE "atya".idempotency_entries
    SET status = 1, value_type = $3, result = $4::jsonb, completed_at = $5, expires_at = $6
    WHERE key_hash = $1 AND fence = $2 AND status = 0
    RETURNING 1)
SELECT EXISTS (SELECT 1 FROM u) AS applied,
       EXISTS (SELECT 1 FROM "atya".idempotency_entries WHERE key_hash = $1) AS found;
```

- Mapping: `Applied`, else `Superseded` (the row exists with another fence or is already Completed), else `NotFound`.
- The replay window is `completed_at + replayTtl`, counted from completion (ATYA-140).
- A late completion by an expired owner that nobody superseded is accepted, because the fence still matches (`LateCompletion_…`).
- `RenewAsync` uses the same compare-and-set with `SET expires_at = now + extension`.
- `AbandonAsync` is `DELETE … WHERE key_hash = $1 AND fence = $2 AND status = 0`, with the same outcome mapping.

| Transition | From | To | Guard |
|---|---|---|---|
| Begin | none, or any expired entry | InProgress(fence F) | `expires_at <= now` on conflict |
| Complete | InProgress(F) | Completed, replay until now + ttl | fence = F, status 0 |
| Renew | InProgress(F) | InProgress(F), lease = now + ext | fence = F, status 0 |
| Abandon | InProgress(F) | none | fence = F, status 0 |
| Purge | any, expired more than `PurgeGrace` ago | none | `expires_at <= now - grace` |

**Stored result format.** The store writes an internal JSON envelope and never serializes `Result<T>` itself, because it has no public constructor:
- success: `{"ok":true,"value":<TValue>}`
- failure: `{"ok":false,"error":{"code","message","kind":<int>,"target","details":[…]}}`

`TValue` is serialized with `options.SerializerOptions`, which defaults to `JsonSerializerConfiguration.Default` from Foundation.Serialization. It is serialized through `JsonTypeInfo<TValue>` from `GetTypeInfo` (no reflection-only overloads), so adopters can plug in a source-generated resolver. `ErrorKind` is stored as its stable integer value.

**Value-type identity** (`value_type`): an internal formatter writes the namespace-qualified name with generic arguments and **no assembly names**, for example `System.Collections.Generic.List<Contoso.Order>`. It is used only for ordinal comparison and is never passed to `Type.GetType` (the same principle as the outbox contract registry). Renaming a type therefore turns live replays into `PayloadMismatch` until their window ends. The README says so.

**Cleanup.** `PurgeExpiredAsync(batchSize)` deletes rows with `expires_at <= now - PurgeGrace` in `SKIP LOCKED` batches. The default `PurgeGrace` of 5 minutes keeps an expired-but-unsuperseded InProgress row long enough for a slow owner's late completion to land, instead of hitting `NotFound` (Q6). The scheduling recipe is the same as for the outbox.

## Public API surface

Each package holds only the types below. Everything else is `internal`.

```csharp
namespace Atya.Messaging.Outbox.PostgreSql;

public sealed class PostgresOutboxStoreOptions
{
    public string Schema { get; set; } = "atya";             // validated identifier
    public bool RequireTransaction { get; set; } = true;     // AddAsync throws without a caller transaction
    public object? DataSourceServiceKey { get; set; }        // DI only: keyed DbDataSource; null = unkeyed
}

public sealed class PostgresOutboxStore : IOutboxStore
{
    public PostgresOutboxStore(DbDataSource dataSource, TimeProvider timeProvider,
        PostgresOutboxStoreOptions options, Func<DbTransaction?>? currentTransaction = null);
    public bool IsEphemeral => false;
    // IOutboxStore members as specified above
    public ValueTask<int> PurgeAsync(PostgresOutboxPurge purge, CancellationToken cancellationToken = default);
}

public sealed record PostgresOutboxPurge(TimeSpan PublishedRetention, TimeSpan? FailedRetention = null, int BatchSize = 1000);

public static class PostgresOutboxSchema
{
    public const int CurrentVersion = 1;
    public static string GetScript(string schema, int version);
    public static Task ApplyAsync(DbDataSource dataSource, string schema = "atya", CancellationToken cancellationToken = default);
}

public static class PostgresOutboxServiceCollectionExtensions
{
    // Scoped IOutboxStore. currentTransaction resolves the caller's ambient DbTransaction for the scope.
    public static IServiceCollection AddAtyaPostgresOutboxStore(this IServiceCollection services,
        Func<IServiceProvider, DbTransaction?> currentTransaction, Action<PostgresOutboxStoreOptions>? configure = null);
}
```

```csharp
namespace Atya.Application.Idempotency.PostgreSql;

public sealed class PostgresIdempotencyStoreOptions
{
    public string Schema { get; set; } = "atya";
    public JsonSerializerOptions SerializerOptions { get; set; } = JsonSerializerConfiguration.Default;
    public TimeSpan PurgeGrace { get; set; } = TimeSpan.FromMinutes(5);
    public object? DataSourceServiceKey { get; set; }
}

public sealed class PostgresIdempotencyStore : IIdempotencyStore
{
    public PostgresIdempotencyStore(DbDataSource dataSource, TimeProvider timeProvider, PostgresIdempotencyStoreOptions options);
    public bool IsEphemeral => false;
    // IIdempotencyStore members as specified above
    public ValueTask<int> PurgeExpiredAsync(int batchSize = 1000, CancellationToken cancellationToken = default);
}

public static class PostgresIdempotencySchema { /* same shape as PostgresOutboxSchema */ }

public static class PostgresIdempotencyServiceCollectionExtensions
{
    // Singleton IIdempotencyStore (stateless over the DbDataSource).
    public static IServiceCollection AddAtyaPostgresIdempotencyStore(this IServiceCollection services,
        Action<PostgresIdempotencyStoreOptions>? configure = null);
}
```

DI rules:
- Both registrations resolve `DbDataSource` from DI, keyed when `DataSourceServiceKey` is set. `AddNpgsqlDataSource(...)` registers both `NpgsqlDataSource` and `DbDataSource`.
- `TimeProvider` comes from DI, falling back to `TimeProvider.System`.
- Options are validated eagerly at registration (schema identifier, positive grace).
- Registration uses plain `Add*`, so a later call replaces an earlier one. The concrete type is also registered, so cleanup jobs can resolve it.

Lifetimes:
- The outbox store is **scoped**, because its transaction delegate belongs to the request's unit of work. A relay host resolves it in a scope per pass, as the ATYA-058 recipe already does. A relay-only host passes `_ => null`; it never calls `AddAsync`.
- The idempotency store is a singleton.

EF Core recipe (README and integration test):

```csharp
services.AddNpgsqlDataSource(connectionString);
services.AddDbContext<OrdersDb>((sp, o) => o.UseNpgsql(sp.GetRequiredService<NpgsqlDataSource>()));
services.AddAtyaPostgresOutboxStore(
    sp => sp.GetRequiredService<OrdersDb>().Database.CurrentTransaction?.GetDbTransaction(),
    o => o.Schema = "orders");

// In the handler:
await using var tx = await db.Database.BeginTransactionAsync(ct);
db.Orders.Add(order);
await db.SaveChangesAsync(ct);
await publisher.PublishAsync(new OrderPlaced(order.Id), cancellationToken: ct);   // same transaction
await tx.CommitAsync(ct);
```

The README states that with `EnableRetryOnFailure`, the transaction block must run inside `db.Database.CreateExecutionStrategy().ExecuteAsync(...)` (standard EF Core guidance).

## Test strategy

**Project.** One integration test project per package, `tests/<Name>.PostgreSql.IntegrationTests`, on the Build SDK's xUnit v3 / MTP stack (ADR-10), with the house assertion library (ADR-11). It references:
- the provider `src` project
- `Testcontainers.PostgreSql`
- `Npgsql`
- for the EF Core recipe test only, `Npgsql.EntityFrameworkCore.PostgreSQL` 10.0.x

**Conformance suites run unchanged.**
- `IdempotencyStoreConformanceTests.cs` and the `OutboxStoreConformanceTests` class are **linked as source** (`<Compile Include="…" Link="Conformance\…" />`) from the existing unit-test projects. They are not copied, not moved and not packaged.
- Linking compiles the suite against the published 2.0.0 contract the provider references. A project reference to the contract's `src` would pull a second copy of the contract assembly into the test project and clash with the package.
- No existing test project changes. One prerequisite: `OutboxStoreConformanceTests` lives in `OutboxTests.cs` next to the relay tests, so it moves into its own file. That is a no-behaviour-change refactor in the Outbox unit tests.
- Each derived class implements `CreateStore(TimeProvider)` over a shared container. Isolation comes from a fresh schema per test class (`t_<guid>`), applied with `ApplyAsync`. The conformance tests already use unique keys per round, so tests within a class share the schema safely.

**PostgreSQL versions.** The container fixture runs on the oldest and newest supported majors: 15 and 18 at the time of writing (14 reached end of life in November 2026). That is two derived classes per suite, about 3 seconds of container start each. Images are pinned by tag and digest (`postgres:18-alpine@sha256:…`), and Renovate updates the digests.

**Provider-specific tests** (each proves a behaviour, rule 5):

| # | Test | Proves |
|---|---|---|
| 1 | 8 relays, each its own `NpgsqlDataSource` (separate pools, like separate processes), race claim and mark over 5,000 rows until drained | Every row reaches `Published` exactly once. The sum of `Applied` acknowledgements equals the row count. No id appears in two claims while their leases are valid. |
| 2 | Same as 1 with a short lease, `FakeTimeProvider` advanced mid-run, and one relay "frozen" holding a claim | The frozen relay's later acknowledgements return `ClaimLost`, and its rows were re-delivered exactly once to a live relay. |
| 3 | `OutboxRelay` 2.0 end to end with an always-throwing publisher and `JitterFactor = 0` | Claims happen at exactly the backoff schedule, the row is `status = 2` after `MaxAttempts`, and it is never claimed again. |
| 4 | `AddAsync` inside a caller transaction, then rollback and commit; and with no transaction while `RequireTransaction = true` | Rollback leaves nothing claimable, commit makes the row claimable, and the guard throws. |
| 5 | EF Core recipe: `SaveChangesAsync` and `PublishAsync` in one `BeginTransactionAsync` | Business row and outbox row commit or roll back together. |
| 6 | 16 `IdempotentExecutor`s over separate data sources run the same key concurrently, 200 rounds | The operation body runs once per round, and every caller gets the same `Result`. |
| 7 | Begin/abandon interleaving loop on one key | The statement-2 retry path is taken and never returns a wrong status. Exhausted retries throw rather than lie. |
| 8 | Replay round-trip for success and failure (`Error` with `Target` and nested `Details`), a source-generated `JsonSerializerContext`, and a changed `TValue` | Values and errors survive exactly, and a type change gives `PayloadMismatch`, not an exception. |
| 9 | Schema: apply twice, custom schema, hostile schema names (`a"; drop`, upper case, 64 characters) | The scripts are idempotent, and invalid identifiers are rejected before any SQL runs. |
| 10 | Purge for both stores with `FakeTimeProvider` | Only rows past retention or grace are deleted, Failed rows are kept by default, and batching respects the size. |
| 11 | No assembly-qualified name in any persisted column (outbox and `value_type`) | ATYA-058 invariant 4 holds on disk. |

**CI feasibility.**
- `ubuntu-latest` runners ship Docker, so Testcontainers works with no setup.
- `windows-latest`, also in the CI matrix, only runs Windows containers, so these tests cannot run there. Integration tests carry a Docker gate:
  - The fixture skips with an explicit reason when Docker is unavailable.
  - CI sets `ATYA_REQUIRE_DOCKER=1` on the ubuntu leg, so a missing Docker on Linux **fails** the run instead of skipping. A silent green run is impossible where it matters.
  - This needs one `env:` line in `ci.yml` (no new actions, nothing to pin).
- Estimated added CI time on ubuntu: about 60 to 90 seconds (container starts plus the 1,000-round begin race, about 8,000 round trips per PostgreSQL version). The implementing PR records the measured number.
- The provider's `.slnf` joins the existing per-package filter check.

## Versioning and release plan

1. **Constitution amendment (platform, owner merge).** This goes on top of platform PR #130 and must merge before the first release ("amend before build").
   - Catalog entries:
     - graduate `Atya.Messaging.Outbox.EntityFrameworkCore` from PARK to BUILD, renamed `Atya.Messaging.Outbox.PostgreSql` (area Messaging)
     - add `Atya.Application.Idempotency.PostgreSql` (area Application)
     - in `ecosystem.json`, each entry has `targetFrameworks: ["net10.0"]`, `publish: true` and `publishingRoute: "central"`, and the generated catalog is regenerated
   - Matrix edges (`allowedDependencies`; Guards and Results need no amendment):
     - `Atya.Messaging.Outbox.PostgreSql` → `Atya.Messaging.Outbox`, `Atya.Foundation.Guards`
     - `Atya.Application.Idempotency.PostgreSql` → `Atya.Application.Idempotency`, `Atya.Foundation.Results`, `Atya.Foundation.Guards`, `Atya.Foundation.Serialization`
2. **Publisher allowlist (security-sensitive, Coordinator review before merge, rule 9).** Regenerate it from `ecosystem.json` so that both ids map to repository `AtyaLibraries/Atya`.
3. **Implementation PRs in `Atya`**, one package at a time, in this order:
   1. Idempotency provider. Its race semantics are the simplest, and it unblocks Admin's API work.
   2. Outbox provider.
   3. A docs PR: provider rows in `docs/RELEASING.md` and READMEs.
4. **Release** `<PackageId>/v1.0.0` per `docs/RELEASING.md`.
   - Package validation runs without a baseline (first version): the SDK's `EnablePackageValidation` still checks the package's own compatibility rules.
   - After publication, a PR sets `PackageValidationBaselineVersion` to `1.0.0`.
   - No prerelease: the integration tests are the proof, and Atya.Admin can adopt 1.0.0 directly. A prerelease would also block any stable consumer (NU5104).
5. **Changes to existing packages: none to code or public API.**
   - The Outbox README's "contracts and relay with a test store" label (ATYA-058 invariant 7) is updated to point at the provider in the same docs PR. The packed README refreshes with the next Outbox release; no release just for docs.
   - The only test-project change is the no-behaviour-change file split of `OutboxStoreConformanceTests`.

Package ids, the matrix and the release each need the owner's or Coordinator's step before code can ship. The design does not need any change to a published API.

## Risks and open questions

| # | Item | Recommendation |
|---|---|---|
| D1 | One package versus two (layering, naming, scope) | **Decided by the owner on 2026-11-28:** two adapters. |
| D2 | ADO.NET over `DbDataSource` instead of an EF Core dependency (deviates from the issue wording) | **Approved by the Coordinator.** It keeps third-party types out of the public API and adds zero runtime dependencies. EF Core is proven by test 5. |
| R1 | Clock skew between hosts: application time decides lease expiry, so a host with a fast clock can reclaim a live lease early and cause one duplicate publish (at-least-once already allows this; fencing stops stale state writes) | Keep application time; it is required for contract parity and the conformance suite. Document "lease ≫ expected skew" (default lease 2 minutes against NTP-level skew). A `UseDatabaseClock` option is deferred until someone needs it. |
| R2 | Windows CI leg cannot run Linux containers | Use an explicit skip on Windows and the mandatory Docker gate on ubuntu (`ATYA_REQUIRE_DOCKER=1`). |
| R3 | Caller forgets the explicit transaction (EF Core implicit `SaveChanges`) | `RequireTransaction = true` by default fails fast. Provide the README recipe. |
| R4 | Table bloat on a high-churn outbox | Partial indexes keep the claim scan small. Run purge in batches. The README recommends a purge schedule and notes autovacuum tuning for very high volume. No `fillfactor` in v1. |
| R5 | Stored-result shape changes after a deploy | `PayloadMismatch` until the replay window ends, never re-execution (Q4). Documented. |
| R6 | CI time growth from the 1,000-round race on two PostgreSQL versions | Accept (estimated 60–90 s). Revisit only if the measured time exceeds 3 minutes. |
| Q1 | Default schema name | `atya`. Admin modules pass their own schema. |
| Q2 | Supported PostgreSQL range | 15+ (tested on 15 and 18), stated in the README. |
| Q3 | Typed API to list or requeue Failed outbox rows | Not in 1.0: documented SQL only. Add an API when an adopter asks. |
| Q4 | A stored result that cannot be deserialized as `Result<TValue>` | Return `PayloadMismatch`, the same as a type mismatch. Re-executing would defeat idempotency. |
| Q5 | Startup schema-version check | Not in 1.0. Table comments carry the version. Add a check when script version 2 exists. |
| Q6 | `PurgeGrace` default | 5 minutes. It keeps late completions working, and a smaller grace only saves table space. |
| Q7 | Should idempotency completion join the caller's transaction (exactly-once side effects) | Out of scope: the 2.0 store contract has no transaction parameter. A crash between effect and completion re-runs on retry, which is the documented at-least-once behaviour under ADR-12. Revisit with a contract change if an adopter needs it. |
| Q8 | Hosted cleanup service in the package | No. It would add a Hosting dependency. The README shows the recipe with `PeriodicBackgroundService`. |
| Q9 | File location: the task named `docs/design/` | Used `docs/designs/` to match the existing design folder and its index. |

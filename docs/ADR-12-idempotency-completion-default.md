# ADR-12: Idempotency completion-policy default

Status: Accepted (owner decision, 2026-11-13)

Date: 2026-11-13

Closes: ATYA-122

## Context

`Atya.Application.Idempotency` 1.0.0 stores and replays every completed `Result`, including failures, for the full lease time-to-live, and a thrown exception leaves the key in progress until the lease expires. The planned `IdempotencyCompletionPolicy` offers `SuccessOnly` and `SuccessAndFailure`, but the public default was left open (DEC-018, DEC-037). ATYA-057 implements the decision and may not choose it during coding.

## Decision

The public default is `SuccessOnly`.

| Outcome of the operation | Behaviour under `SuccessOnly` (default) | Behaviour under `SuccessAndFailure` (opt-in) |
|---|---|---|
| Success `Result` | Stored; replayed until the replay window ends | Same |
| Failure `Result` | Not stored; the key is released so the caller can retry | Stored and replayed like a success |
| Exception thrown | Key released; the exception propagates | Key released; the exception propagates |
| Caller cancellation | Key released; cancellation propagates | Key released; cancellation propagates |
| Lease expires while running | A new owner may begin; the expired owner's completion is rejected | Same |

The policy is chosen per executor registration and may be overridden per call. Releasing the key and recording completion do not use the caller's cancellation token.

## Consequences

- This changes 1.0.0 behaviour, where failure results are replayed. It ships in the Idempotency major version delivered by ATYA-057 and is called out in its migration notes.
- Trade-off: under the default, an operation that fails after a partial side effect can run again on retry. Handlers with non-compensated partial side effects must opt in to `SuccessAndFailure`; the package documentation must say so.
- The default is preferred because replaying a transient failure for the whole time-to-live is the more common harm.
- Store conformance tests must cover every row of the table above.

## Source

Owner decision recorded under `docs/PLAN-V2.md`. Background: `docs/FINAL-DECISION-REGISTER.md`, DEC-018 and DEC-037.

# ADR-03: Result contract convergence

Status: Accepted (recorded from decision register DEC-012)

Date: 2026-11-13

Closes: ATYA-007, ATYA-008

## Context

Speculative `IResult` and Abstractions contracts overlapped with `Foundation.Results`, leaving several competing result models.

## Decision

Retire the speculative `IResult` and Abstractions contracts and converge on `Foundation.Results`. Do not add a third bridge package.

## Consequences

`Foundation.Results` is the single result model. Legacy contracts are retired rather than bridged. Implementation of the convergence (deprecation markers, migration map, 2.0 removal) is ordinary package work and is not part of this record.

## Source

`docs/FINAL-DECISION-REGISTER.md`, DEC-012. Re-planned under `docs/PLAN-V2.md`.

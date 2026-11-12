# ADR-02: Strategic time model

Status: Accepted (recorded from decision register DEC-011)

Date: 2026-11-13

Closes: ATYA-006

## Context

The fleet had no decided time abstraction: `TimeProvider` and a custom clock interface were both candidates.

## Decision

Use `TimeProvider` as the platform currency for time. Add a thin opinionated abstraction on top of it only if adopter value is demonstrated.

## Consequences

New and changed code injects `TimeProvider`. Tests use the framework's fake time provider. No new clock abstraction is introduced speculatively; one that proves its value needs evidence from an adopter and a separate decision.

## Source

`docs/FINAL-DECISION-REGISTER.md`, DEC-011. Re-planned under `docs/PLAN-V2.md`.

# ADR-10: Test platform direction

Status: Accepted (owner decision, 2026-11-13)

Date: 2026-11-13

Closes: ATYA-010

## Context

`Atya.Build.Sdk` injects xunit.v3 in VSTest mode, while the UiAutomation template already runs on Microsoft Testing Platform (MTP). The fleet had no ratified direction, and coverage collection differs between the two. The decision register (DEC-014) required a decision but did not make one.

## Decision

Adopt Microsoft Testing Platform fleet-wide. The switch happens in the next `Atya.Build.Sdk` major version: enable the MTP runner, drop the VSTest packages, and move coverage to an MTP-compatible collector.

## Consequences

- Until that SDK major ships, package repositories stay on VSTest mode; no repository switches on its own.
- New templates target MTP from the start.
- The reusable CI workflow must support the MTP invocation and coverage output before the SDK major is rolled out.
- The implementation is a separate task raised against `Atya.Build.Sdk`; this ADR creates no code change.

## Source

Owner decision recorded under `docs/PLAN-V2.md`. Background: `docs/FINAL-DECISION-REGISTER.md`, DEC-014.

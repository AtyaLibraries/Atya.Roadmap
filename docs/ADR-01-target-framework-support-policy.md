# ADR-01: Target-framework support policy by package archetype

Status: Accepted (recorded from decision register DEC-010)

Date: 2026-11-13

Closes: ATYA-005

## Context

The target-framework strategy was an implicit Atya.Build.Sdk default rather than a published policy. No support or deprecation windows existed, and multi-targeting was undecided.

## Decision

Use an archetype-specific target-framework support policy. Each package archetype (foundations, adapters, analyzers/generators, tools, templates, web) declares its own target frameworks. Mechanical fleet-wide multi-targeting is rejected.

## Rules

- Do not multi-target a package without demonstrated adopter evidence and per-target packed-consumer CI.
- The SDK default is explicit and archetype-driven, not a single hidden fleet value.
- Support and deprecation windows are published per archetype.

## Consequences

Packages keep the smallest justified target set, which reduces build and test cost for a solo-maintained fleet. A later change to an archetype's targets needs its own accepted ADR.

## Source

`docs/FINAL-DECISION-REGISTER.md`, DEC-010. Re-planned under `docs/PLAN-V2.md`.

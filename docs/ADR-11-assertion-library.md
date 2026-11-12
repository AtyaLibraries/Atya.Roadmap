# ADR-11: Assertion library after FluentAssertions 7.x

Status: Accepted (owner decision, 2026-11-13)

Date: 2026-11-13

Closes: ATYA-011

## Context

The fleet pins FluentAssertions below 8 for licensing reasons. The 7.x line receives no fixes, and the pin is load-bearing in `Atya.Build.Sdk`, the Renovate preset, and the constitution. It will eventually break against a test-framework or .NET update. The decision register (DEC-014) required an exit strategy but did not choose one.

## Decision

Replace FluentAssertions 7.x with AwesomeAssertions, the community fork of FluentAssertions 7 under a permissive licence. Shouldly and plain framework asserts were considered and rejected because both require rewriting every existing test for no user-visible gain.

## Consequences

- The swap is made once, in `Atya.Build.Sdk`, by replacing the injected package; it rolls out with the same SDK major as ADR-10 so test projects change once.
- Before the swap, confirm the fork's current licence and the namespace used by the chosen version, and record both in the implementing task.
- The FluentAssertions `<8` ceiling stays in the SDK, the Renovate preset, and the constitution until the swap ships, then is removed from all three.
- The implementation is a separate task raised against `Atya.Build.Sdk`; this ADR creates no code change.

## Source

Owner decision recorded under `docs/PLAN-V2.md`. Background: `docs/FINAL-DECISION-REGISTER.md`, DEC-014.

# ATYA-003 implementation evidence

Date: 2026-07-21

Public issue: [#3 — Repair the release graph](https://github.com/AtyaLibraries/Atya.Roadmap/issues/3)

## Result

ATYA-003 is in progress. ADR-09 selects protected two-line releases with mandatory merge-back. The Roadmap now defines and tests release-time and retrospective verification modes.

The refreshed fleet measurement covered 31 repositories with both long-lived branches. Fourteen release/development trees differ and 24 newest public stable tags are not ancestors of development. Exact repository lists and raw diagnostics remain in the private maintainer record.

## Safety disposition

No reconciliation pull request was opened in this change. Live inspection found unique commits on both long-lived branches in repositories requiring special attention, so a blind promotion or merge-back could lose work. Protected release sources and publication triggers also require review before any repair is proposed.

The local-only Build SDK tag remains local and unpublished. It must not be pushed because the repository's tag workflow can publish a package. Serialization's public `v1.0.1` tag remains immutable while its corresponding release/package recovery stays assigned to ATYA-131.

## Temporal contract

- Release-time wrap-up requires tree equality, stable-tag ancestry, and released-pin conformance.
- Retrospective verification allows expected development drift but still requires stable-tag ancestry and released-pin conformance.
- Tree parity and tag ancestry are reported independently in both modes.

## Compatibility, migration, and recovery

This work changes no package or public API. Repositories adopt the contract at their next reviewed release reconciliation. A failed proposal is rolled back by abandoning or reverting only its task branch; published tags and packages are never rewritten.

## Downstream handoffs

- ATYA-039: implement manifest-driven fleet execution and continuous reporting using these two modes.
- ATYA-124: correct immutable-reference parsing and fixtures without treating the platform drift issue as policy authority.
- ATYA-121: decide Build SDK publisher routing and local-only tag recovery.
- ATYA-131: recover Serialization release/package lineage after its hard dependencies are complete.

No blocked downstream implementation was performed.

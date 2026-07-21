# ADR-09: Release-lineage strategy

Status: Accepted for ATYA-003 implementation

Date: 2026-07-21

## Context

The managed package repositories use protected `development` and `master` lines. Releases and stable tags have historically been produced from the release line, while normal work resumes on `development`. A refreshed fleet measurement confirms that tree parity and stable-tag ancestry are independent: a repository can satisfy either predicate while failing the other.

Continuous tree equality is not a valid steady-state rule. It would classify ordinary development after a release as a release failure. Stable-tag ancestry, however, remains a continuous provenance requirement because MinVer must be able to observe the newest public stable release from the development line.

## Decision

Retain the current two-line model and require an explicit merge-back after each release. Do not migrate the fleet to trunk-based releases as part of ATYA-003.

The release contract has two modes:

1. **Release-time wrap-up.** The approved release and development trees must be equal, the newest public stable tag must be an ancestor of `development`, and the released tree must use the approved SDK and Build SDK pins.
2. **Retrospective verification.** Development may have advanced, so tree inequality is diagnostic rather than a failure. Stable-tag ancestry and released-pin conformance remain required.

A reconciliation must preserve every commit unique to either long-lived branch. It is performed through protected pull requests and reviewed merge commits; published tags and packages are immutable. Promotion and merge-back are separate reviewable operations when both are needed.

## Rationale

This decision matches the live branch topology, protection model, release-source guards, and existing package workflow. A trunk migration would require organization-wide branch-policy and release-workflow changes owned by later tasks. Keeping merge-back explicit solves MinVer provenance without bypassing those dependencies.

## Compatibility and migration

The decision changes no package API and publishes no artifact. Existing repositories migrate at their next approved reconciliation: first preserve and review unique work on both lines, then promote or merge back as appropriate, and finally prove both release-time predicates. Normal development after that point is evaluated in retrospective mode.

## Recovery and rollback

Before a pull request is merged, abandon or revise only its task branch. After a faulty reconciliation merge, use a reviewed forward repair or revert that preserves published ancestry. Never move or replace a stable tag or published package.

## Deferred ownership

- Fleet CLI implementation and scheduled continuous execution belong to ATYA-039.
- Immutable-reference parsing defects belong to ATYA-124.
- Serialization `v1.0.1` release recovery belongs to ATYA-131 after its dependencies are satisfied.
- Build SDK publisher routing and the local-only tag disposition belong to ATYA-121 and its prerequisites.

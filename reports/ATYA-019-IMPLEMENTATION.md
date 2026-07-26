# ATYA-019 implementation evidence

Date: 2026-07-26

Public issue: [#21 — Define one immutable workflow and action reference policy](https://github.com/AtyaLibraries/Atya.Roadmap/issues/21)

## Result

ATYA-019 is complete as a definition-and-verification task. The Roadmap now carries one
authoritative statement of how workflow and action references are pinned across the fleet,
a validator that decides any single `uses:` reference against it, and fixtures that pin the
validator's behaviour on every ambiguous case.

The policy is defined and tested. It is **not rolled out**. No workflow file in any
repository was changed, and no non-conformant reference was fixed.

- Policy: [`docs/ATYA-019-IMMUTABLE-REFERENCE-POLICY.md`](../docs/ATYA-019-IMMUTABLE-REFERENCE-POLICY.md)
- Machine-readable contract: [`github/contracts/atya-019/immutable-reference-policy.json`](../github/contracts/atya-019/immutable-reference-policy.json)
- Validator: [`scripts/Test-ImmutableReference.ps1`](../scripts/Test-ImmutableReference.ps1)
- Contract test: [`tests/Test-ImmutableReferenceContract.ps1`](../tests/Test-ImmutableReferenceContract.ps1)

## Evidence basis

No private evidence was requested or used. `AUDIT-SEC-019` is a sanitization placeholder,
not a retrievable document; the standing ruling is CAVEAT-001 in
[`EVIDENCE-CAVEAT-LEDGER.md`](./EVIDENCE-CAVEAT-LEDGER.md), and the acceptance criterion
concerning the private evidence reference is satisfied by that entry and is not carried
open.

The security facts were established by direct source inspection: every
`.github/workflows`, `.github/actions`, and `actions` YAML file in all 36 organization
repositories was read, and the two drift examples named in the task scoping were verified
independently before being used as fixtures. Both were confirmed exactly as described.

## The decisive finding

The existing platform drift check tests reference conformance with a regex that requires
the literal mutable tag `@v1`:

```js
/uses:\s*AtyaLibraries\/github-workflows\/\.github\/workflows\/dotnet-package-ci\.yml@v1\b/i
```

The check is **inverted** with respect to any immutable-reference policy. Of the 28
repositories carrying a `ci.yml`, the 14 that use the mutable tag are reported clean and
the 14 that SHA-pin the reusable workflow are reported as drift. The root cause is that one
regex answers two questions at once — adoption and conformance — so the ref value became
load-bearing for an adoption test. This is recorded as requirement DV002, and the check was
not modified: it belongs to ATYA-124.

A second finding is that the version comment after a SHA is load-bearing rather than
decorative. Renovate's `github-actions` manager recovers `currentValue` from that comment;
without it the dependency is marked `enabled = false` with
`skipReason: 'unversioned-reference'`. Fourteen fleet references are SHA-pinned with no
comment and are therefore immutable but permanently frozen — they will never receive
another update, including a security update, and nothing reports it.

## Fleet measurement

Measured 2026-07-26 by snapshotting all 36 repositories and running the new validator over
the snapshot:

| Verdict | Count |
| --- | --- |
| Total `uses:` references | 168 |
| Conformant | 42 |
| Violation — IR001 (mutable ref) | 112 |
| Violation — IR002 (SHA with no usable version comment) | 14 |

"SHA-pinned" and "conformant" are not the same set: 56 references are SHA-pinned, but 14 of
those fail IR002. The per-finding breakdown, disjoint and summing to 126, is in §10 of the
policy document.

## Safety disposition

No reference was fixed, no workflow file outside this repository was touched, and no
repository other than `Atya.Roadmap` was modified. The exception register ships empty:
every known non-conformant reference is recorded as a finding assigned to a rollout task,
not waved through as an approved exception.

`docker://` and local `./` reference forms occur nowhere in the fleet. The policy resolves
them anyway, and their fixtures are labelled synthetic rather than presented as observed.

## Validation

- PowerShell 7 policy-contract, fixture, mixed-file, exit-code, and mutation validation: passed.
- 23 single-reference fixtures, 10 of them drawn from live observed references: passed.
- 5 policy-weakening mutations, each required to be detected: passed.
- Deliberate fixture break reproduced a failing suite and restoration reproduced a passing suite.
- Existing ATYA-024 contract suite, including its repository-wide sanitization scan of the new files: passed.
- Existing release-lineage contract suite: passed.
- JSON parsing of the contract and all 24 fixture files: passed.

This repository has no aggregate validator entry point and no CI workflow of its own; the
three suites are invoked individually.

## Compatibility, migration, and rollback

Adopting this policy changes no package, no public API, and no consumer of any
AtyaLibraries package. It changes only the text of `uses:` lines and the checks that read
them. A SHA-pin to the commit a tag currently points at is functionally identical to that
tag, so nothing changes behaviour at the moment of pinning.

Migration must be ordered **ATYA-124 before ATYA-026**. Rolling pinned workflows across the
fleet while the drift check still demands `@v1` would make every correctly migrated
repository report as drift, and that noise would be read as the migration having failed.

Renovate is the recommended migration route rather than hand-editing 126 references, which
invites transcription errors that pin to a wrong-but-valid SHA — worse than a tag, because
it is silent.

Rollback before rollout is a branch revert; nothing outside this repository depends on
these files. Rollback after rollout is a matter of ceasing to enforce rather than reverting
the fleet: already-pinned references remain valid and functional whether or not the policy
requiring them still exists. There is no state to unwind.

The most likely way this policy is wrong is RN003 — Renovate may not in fact advance
reusable-workflow pins. The correct response would be to add an explicit first-party bump
mechanism, not to return to `@v1`, which would restore the original exposure.

## Downstream handoffs

- **ATYA-124** — correct the drift check against §8 of the policy document (DV001–DV008).
  `Test-ImmutableReference.ps1` is a conforming reference implementation and may be ported.
  Also remediates findings F1, F8, and the `platform` share of F3.
- **ATYA-026** — roll pinned workflows across the fleet; remediates F2, F4, F5, F6 and the
  managed-fleet share of F3. Must follow ATYA-124.
- **ATYA-028** — confirm RN003 against a live Renovate result, and hold RN001, RN002, RN004.
- **ATYA-027** — self-tests for reusable workflows and composite actions, against this policy.
- **ATYA-039** — CLI fleet audits, using this policy as the conformance authority.
- **ATYA-040** — remediates F7 in `AtyaLibraries.github.io`.

No blocked downstream implementation was performed.

## Acceptance criteria not satisfied

None outstanding. The criterion "the private evidence reference is updated by maintainers"
is satisfied by CAVEAT-001 under the standing ruling and is not carried as an open item.

One requirement is deliberately recorded as unconfirmed rather than asserted: RN003, whether
`helpers:pinGitHubActionDigests` reaches reusable-workflow references in practice. ATYA-019
did not run Renovate against this fleet and does not claim it. It is assigned to ATYA-028.

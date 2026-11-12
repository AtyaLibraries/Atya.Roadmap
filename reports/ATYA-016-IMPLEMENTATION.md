# ATYA-016 implementation evidence

Date: 2026-07-21

Public issue: [publisher #8](https://github.com/AtyaLibraries/publisher/issues/8)

Product pull request: [publisher #10](https://github.com/AtyaLibraries/publisher/pull/10)

## Review result

The merged publisher change separates requested source execution from
production publication authority. Its untrusted build job has read-only source
access and no OIDC, attestation, production environment, NuGet credential, or
push authority. The production job does not check out or build the requested
repository; it consumes one bounded package artifact and trusted publisher
metadata from the immutable workflow revision.

The production job derives PackageId and repository provenance from the package
nuspec. Before NuGet login or push, it validates the derived identity against the
ATYA-001-generated publisher consumer. Unsupported policy versions, unknown or
mismatched identities, unsafe refs or paths, malformed metadata, ambiguous
outputs, missing or duplicate nuspecs, and case-normalization variants fail
closed.

The generated policy snapshot remains a consumer of the platform authority, not
a second package catalog. Its exact generator provenance and synchronization
procedure are recorded with the product change. A package admitted after the
snapshot remains denied until the generated consumer is reviewed into publisher.

## Sanitized acceptance evidence

- The publisher security regression suite passes 67 tests with no failures on
  Windows PowerShell 5.1 and PowerShell 7.6.2.
- An authorized PackageId/repository pair passes; unknown and mismatched pairs
  fail before the credential step.
- Negative fixtures assert their intended failure reasons and cover unsafe
  repositories, strict SemVer refs, noncanonical paths, malformed ZIP/XML,
  missing, duplicate, and namespace-confused nuspec metadata, package/entry/nuspec
  bounds, unsupported policy versions, duplicate policy identities, and URL
  host/port/userinfo/query/fragment/path/case variants.
- Static assertions verify job-scoped permissions, the no-source production
  boundary, credential ordering, immutable action references, and the single
  bounded artifact contract.
- Platform `main` remained at
  `34613b307f70508d7d7b6fb9916a2c43357b72cd`. Fresh deterministic generation and
  the publisher snapshot both produced Git blob
  `bc4d0fbfe4e752f7db5da17ddf047a1bbb3eb4b8`.
- YAML lint, PowerShell parsing, policy JSON parsing, sanitization, and diff
  checks pass locally.
- Pull-request checks passed on Linux and Windows for final product head
  `e96787e576c59139abcaab86e4f98ccd88010b85` in
  [pre-merge CI](https://github.com/AtyaLibraries/publisher/actions/runs/29859019726).
- Publisher PR #10 merged as
  `1ed15efc183e77579f4eded1c3fd43710d4d60d3`. All configured jobs passed for that
  exact commit in
  [post-merge CI](https://github.com/AtyaLibraries/publisher/actions/runs/29859175285).
- A clean detached worktree at the merge commit repeated the 67-test suite on
  both local PowerShell hosts plus deterministic policy generation, policy byte
  comparison, workflow parsing/lint, sanitization, and diff checks. It remained
  clean and was removed after verification.
- No release or publication workflow was triggered, and the public change and
  pull-request text contain no raw private evidence or reproduction material.

## Compatibility, migration, security, and rollback

Existing callers keep the repository, release-ref, solution, package-project,
and global-json dispatch fields. Release refs must resolve to exact SemVer tags,
paths must be safe repository-relative values, and identity casing must match the
generated policy. Dispatch does not gain a PackageId field or a new secret.

The deliberate compatibility change is fail-closed rejection of ambiguous or
noncanonical inputs and packages that cannot be uniquely authorized. New package
admissions require the platform-generated publisher consumer to be synchronized
through normal review.

Rollback is a normal revert that stops publication while a forward fix is
prepared. Published packages and release tags remain immutable. Failed policy
authorization is recovered by correcting the authoritative manifest or package
metadata and repeating the reviewed release process; it is never bypassed.

## Remaining work and dependent disposition

The product change and exact-merge acceptance are complete. After this evidence
change merges, publisher issue #8 can close and ATYA-016 can move from In Review
to Done with its verified evidence statement.

ATYA-018 and ATYA-024 can then move from Blocked to Ready. ATYA-113 remains
Blocked because ATYA-018 and ATYA-112 are incomplete. ATYA-121 remains Blocked
because ATYA-020 and ATYA-036 are incomplete.

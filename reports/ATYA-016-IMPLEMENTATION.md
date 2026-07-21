# ATYA-016 implementation evidence

Date: 2026-07-21

Public issue: [publisher #8](https://github.com/AtyaLibraries/publisher/issues/8)

Product pull request: [publisher #10](https://github.com/AtyaLibraries/publisher/pull/10)

## Review result

The draft publisher pull request separates requested source execution from
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

- The publisher security regression suite passes 44 tests with no failures.
- An authorized PackageId/repository pair passes; unknown and mismatched pairs
  fail before the credential step.
- Negative fixtures cover unsafe repositories, refs, and paths; malformed,
  missing, and duplicate nuspec metadata; package and entry bounds; unsupported
  policy versions; duplicate policy identities; and case/URL normalization.
- Static assertions verify job-scoped permissions, the no-source production
  boundary, credential ordering, immutable action references, and the single
  bounded artifact contract.
- The generated policy file is byte-identical to its recorded platform consumer
  blob.
- YAML lint, PowerShell parsing, policy JSON parsing, sanitization, and diff
  checks pass locally.
- Draft pull-request checks pass on Linux and Windows for product commit
  `4363f82f176e4d50c86cd62aeca76a3fab04b410`.
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

Before merge, rollback is closure of the draft product pull request. After merge,
rollback is a normal revert that stops publication while a forward fix is
prepared. Published packages and release tags remain immutable. Failed policy
authorization is recovered by correcting the authoritative manifest or package
metadata and repeating the reviewed release process; it is never bypassed.

## Remaining work and dependent disposition

Both product and roadmap changes remain draft review work. Publisher issue #8
stays open, and ATYA-016 must remain In Review rather than Done until both pull
requests are reviewed, merged, and completion evidence is verified.

Dependent statuses do not change during this review. After eventual ATYA-016
completion, only ATYA-018 and ATYA-024 are candidates for Blocked to Ready.
ATYA-113 remains blocked on ATYA-018 and ATYA-112. ATYA-121 remains blocked on
ATYA-020 and ATYA-036.
